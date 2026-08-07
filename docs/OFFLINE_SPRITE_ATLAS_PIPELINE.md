# Offline Sprite Atlas Pipeline

Status: tooling implemented, not yet used to generate any production
artwork. Governed offline asset infrastructure for the Math Intelligence
Flutter app — no application navigation, onboarding, learning flow, ALI,
Tutor, Family Studio, entitlement logic, or existing lab mathematics was
touched.

## What this is

A deterministic Python 3.13 command-line tool
(`scripts/asset_pipeline/`) that turns a directory of source images into
a production-ready sprite atlas: one packed PNG, a JSON manifest, a
typed Dart source file, and CSV/JSON build reports. It runs entirely
**offline** — Flutter only ever loads the finished files it produces; no
Python is invoked at runtime, no network dependency exists anywhere in
the pipeline.

```
python -m scripts.asset_pipeline build \
    --source assets_src/football \
    --output assets/generated/football \
    --atlas-id football_core
```

(On this Windows environment, `python`/`pip` are not on `PATH` directly —
invoke via the `py` launcher instead: `py -m scripts.asset_pipeline
build ...`.)

## Architecture

One module per pipeline stage, each independently testable and free of
hidden global state (config is always passed explicitly as a
[`PipelineConfig`](../scripts/asset_pipeline/models.py)):

```
discovery.py    -> finds source files, derives stable ids, hashes, groups
                    numbered sequences into animations
image_io.py     -> context-managed decode -> RGBA numpy array
normalization.py-> pure-numpy mode conversion + blank-frame detection
trimming.py     -> vectorized transparent-border trim, anchor recovery
packing.py      -> deterministic shelf-packing, one preallocated buffer
metadata.py     -> AnimationRecord construction + JSON serialization
validation.py   -> overlap / bounds / max-size / schema checks
flutter_catalog.py -> generates a typed, const Dart source file
reporting.py    -> CSV + JSON build/validation reports
cli.py          -> orchestration + atomic, overwrite-safe publishing
```

`models.py` holds every dataclass (and the `AssetPipelineError` family)
these modules pass between each other — nothing else does file I/O
except `image_io.py`, `cli.py`, and the small write calls at the end of
`cli.run_build`.

### Source → output flow

```
assets_src/football/
    ball.png
    player/kick_01.png
    player/kick_02.png
        │
        ▼  discovery.discover_and_group()
   [AssetGroup(ball), AssetGroup(player/kick, 2 frames)]
        │
        ▼  image_io.load_frame() + trimming.maybe_trim()  (per frame)
   [(DecodedFrame, TrimResult), ...]
        │
        ▼  packing.pack_frames()
   one preallocated numpy RGBA buffer + [PackedFrame, ...]
        │
        ▼  metadata.build_animation_records() + validation.*
   [AnimationRecord, ...], geometry/schema errors (if any)
        │
        ▼  cli.run_build() writes, only if report.ok:
   football_core.png
   football_core.json
   football_core_atlas.dart
   football_core_report.csv
   football_core_report.json
```

## Determinism guarantees

- **Discovery order never matters.** `discover_source_files` sorts every
  path; `group_into_assets` sorts group ids and frame indices explicitly.
- **Packing order is a fixed, total sort key**
  (`-height, -width, asset_id`) — never insertion order, never a
  dict/set iteration order.
- **JSON serialization uses a fixed key-construction order** (Python
  dicts preserve insertion order), not `sort_keys`, so the schema reads
  in a deliberate order and stays byte-identical across runs.
- **The Dart catalogue generator** formats every value itself (fixed
  float `repr()`, explicit string escaping) rather than delegating to
  anything with locale- or platform-dependent formatting.
- Verified directly in `tests/asset_pipeline/test_cli.py`
  (`DeterminismTests`): building the same source twice into two
  different output directories produces byte-identical PNG, JSON, and
  Dart files.

## Memory strategy

- **One allocation.** `packing.pack_frames` runs a dry-run layout pass
  first to compute the exact required atlas size, then calls
  `np.zeros((height, width, 4), uint8)` **exactly once** and blits every
  frame directly into it — never repeated concatenation/resizing.
- **Prompt handle closing.** `image_io.load_frame` uses
  `with Image.open(...) as handle:`, so the Pillow file handle closes as
  soon as the frame is decoded to a numpy array.
- **Incremental decoding.** `image_io.iter_frames` is a generator, not a
  list — a caller processing many sources never holds more decoded
  frames in memory than it's actively using. (`cli.run_build` does
  currently materialize the full `decoded_and_trims` list before
  packing, since shelf-packing needs every frame's size up front to sort
  and lay them out — a genuine incremental/streaming pack is future work
  if atlases grow large enough to need it; noted as an unresolved risk
  below.)
- **Peak memory is reported, not guessed.** `reporting
  .estimate_peak_memory_bytes` is exactly `width * height * 4` — the
  true size of the preallocated buffer — included in every build's JSON
  report. `reporting.check_size_warning` warns once an atlas reaches 80%
  of `max_atlas_size` on either axis, ahead of an actual failure.

## Failure behaviour ("fail safely rather than silently dropping
assets")

Every "reject" case in the brief raises an `AssetPipelineError` subclass
(`models.py`) instead of skipping the offending asset:

| Condition | Exception |
|---|---|
| Two files resolve to the same asset id | `DuplicateAssetIdError` |
| A file can't be decoded as an image | `UnreadableImageError` |
| A frame is fully transparent | `BlankFrameError` |
| Packed atlas would exceed `max_atlas_size` | `AtlasSizeExceededError` |
| Output has content and `--overwrite` wasn't passed | `AssetPipelineError` |
| Source directory doesn't exist | `SourceDirectoryNotFoundError` |

Geometry and schema problems (overlaps, out-of-bounds frames, a
malformed manifest) are instead collected into the returned
`BuildReport.errors` — still a failure (`report.ok` is `False`, nothing
is published), but with every problem listed at once rather than
aborting at the first.

**Atomic, overwrite-safe publishing** (`cli.build_command`): the whole
build writes into a `tempfile.TemporaryDirectory()` created **as a
sibling of the real output directory** (same filesystem, so the final
move is a true atomic rename rather than a cross-volume copy). Only once
the build has fully succeeded and passed validation does each artifact
get moved into the real output directory via `os.replace` (atomic,
replace-if-exists — no directory-level rename dance needed). Any failure
at any stage — a raised exception or a validation error — means the
temp directory is cleaned up by its own context manager and the real
output directory is **never touched**. Verified in
`test_cli.py::FailureModeTests` (including a forced late-stage failure
via mocking, asserting no stray temp directory survives) and
`OverwriteBehaviourTests`.

## CLI reference

```
python -m scripts.asset_pipeline build \
    --source SOURCE_DIR --output OUTPUT_DIR --atlas-id ATLAS_ID
    [--max-atlas-size N]      # default 2048
    [--padding N]             # default 2
    [--extrusion N]           # default 1
    [--trim | --no-trim]      # default --trim
    [--overwrite]             # default off
    [--frame-duration-ms N]   # default 100
    [--loop once|loop|ping_pong]  # default loop
    [--content-version N]     # default 1
    [--anchor-x X] [--anchor-y Y]  # default 0.5, 0.5 (centre)
```

Governed defaults live in `PipelineConfig` (`models.py`) — every CLI
flag is an explicit override of one, never a hidden global.

## Flutter integration seam (currently dormant)

`lib/models/sprite_atlas.dart` defines `SpriteAtlas`/`SpriteAnimation`/
`SpriteFrameRect`/`SpriteLoopMode` — mirrors the exact fail-fast,
required-field-checking style of the existing `VisualAsset.fromJson`
(`lib/models/visual_asset.dart`). Every class is `const`-constructible
*and* has a `fromJson`/`fromManifestJson` factory, so it serves two
paths with one shared schema:

1. **Generated code** — `flutter_catalog.py` emits one `*_atlas.dart`
   file per atlas declaring a single `const SpriteAtlas` value built
   from these types directly (zero runtime JSON parsing, compile-time
   constant).
2. **Runtime loading** — `lib/services/sprite_atlas_catalog_service.dart`
   (`SpriteAtlasCatalogService`) mirrors
   `VisualAssetCatalogService`'s shape exactly: lazy-load-and-cache,
   injectable `AssetBundle`, `byAssetId` returns `null` for an unknown
   id rather than throwing.

**Neither is wired into the app.** Nothing imports
`sprite_atlas_catalog_service.dart` from `main.dart`, `bootstrap.dart`,
or any screen; `pubspec.yaml` was not changed; atlas generation is not
part of application startup. This is intentionally the "narrow
integration seam" the brief asked for — a future sprint decides which
lab (Football Precision, Aircraft Landing Lab, or a future Flame game)
adopts it first, and existing procedural `CustomPainter` rendering stays
available as the fallback throughout.

## Reduced-motion fallback

Every `AnimationRecord`/`SpriteAnimation` carries a
`reduced_motion_fallback_frame` / `reducedMotionFallbackFrame` index
(defaults to `0`, the first frame) — a future consumer under Reduce
Motion shows that single static frame via
`SpriteAnimation.reducedMotionFallback` instead of playing the full
sequence, matching the Reduce-Motion convention already used throughout
this app's Interactive Labs (static final frame instead of an animated
sequence). The index is clamped defensively
(`frames[index.clamp(0, frames.length - 1)]`) so a malformed manifest
can never index out of range.

## Future inputs (not implemented this sprint)

The pipeline's stages are deliberately generic about *where* a source
PNG came from — `discovery.py` just walks a directory. A future sprint
could point `--source` at:

- **ComfyUI** output (the existing local pipeline at `D:/AI/ComfyUI`
  already produces the Discovery Library's illustrations) — would need a
  transparent-background export convention so `trimming.py`'s border
  trim behaves as expected.
- **Blender** render passes (sprite-sheet exports of a 3D rig).
- **Aseprite** exports (native sprite/animation tool; its own JSON export
  format would need a small adapter feeding into `discovery.py`'s
  `AssetGroup` shape, not a pipeline rewrite).

None of this is implemented or scaffolded beyond this pipeline already
being source-agnostic — noted here only so the intent isn't lost.

## Unresolved risks

- **Shelf packing is not space-optimal.** MaxRects/skyline packing would
  pack tighter; shelf packing was chosen for simplicity and obvious
  determinism. Revisit if real atlases start hitting `max_atlas_size`
  often (the 80%-threshold warning exists to surface this before it
  becomes a hard failure).
- **`cli.run_build` decodes and trims every frame before packing**
  (packing needs every frame's final size up front to lay them out) —
  fine for the scale seen so far, but not the fully streaming/incremental
  pipeline the brief's general performance principles gesture at for
  very large atlases. Would need a different packing strategy (e.g. a
  fixed grid instead of shelf packing) to decode-and-place one frame at
  a time.
- **No content actually migrated yet.** This sprint deliberately ships
  tooling only — Football Precision and Aircraft Landing Lab's real
  visuals are untouched, so the pipeline's real-world behaviour against
  production-quality source art (varied sizes, actual transparency
  patterns) is still unverified beyond the synthetic test fixtures.
