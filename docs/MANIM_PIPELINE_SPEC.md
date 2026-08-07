# Manim Pipeline Spec

Date: 2026-07-25

Target root:

```text
D:\AI\Quantumlab\tools\manim_pipeline
```

This is a proposed external production pipeline. It must not execute inside the Flutter app.

## Goals

- Use a Python virtual environment.
- Use Manim Community Edition.
- Keep versioned scene scripts.
- Use deterministic seeds.
- Render locally.
- Copy output into Flutter assets only after review.
- Keep all generated media traceable through a manifest.

## Proposed Directory Layout

```text
D:\AI\Quantumlab\tools\manim_pipeline
  README.md
  pyproject.toml
  uv.lock or requirements-lock.txt
  .venv\
  config\
    manim.cfg
    render_profiles.json
  scenes\
    v001\
      equivalent_fractions.py
      equation_balance.py
      slope_rise_over_run.py
  renders\
    review\
    approved\
    rejected\
  manifests\
    animations.manifest.jsonl
  notices\
    MANIM_NOTICES.md
    DEPENDENCY_NOTICES.md
  scripts\
    render_scene.ps1
    render_batch.ps1
    hash_scene.ps1
    compress_asset.ps1
    copy_approved_to_flutter.ps1
```

Flutter import target:

```text
D:\AI\Quantumlab\apps\edex\unified_math_tutor\assets\animations\manim\
```

## Environment Model

Preferred RC1 setup:

```powershell
cd D:\AI\Quantumlab\tools\manim_pipeline
py -3.11 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install manim==0.20.1
manim checkhealth
```

Required native tools:

- FFmpeg, from a trusted redistributable build.
- Optional MiKTeX/TeX Live for `MathTex`/`Tex`.
- System fonts with commercial embedding rights.

Docker alternative:

```powershell
docker run --rm -it -v "D:\AI\Quantumlab\tools\manim_pipeline:/manim" manimcommunity/manim manim -qm scenes/v001/equivalent_fractions.py EquivalentFractions
```

Use Docker for reproducibility when Windows native dependencies become noisy, but do not redistribute the Docker image as part of the app.

## Render Profiles

Suggested `config/render_profiles.json`:

```json
{
  "preview": {
    "quality": "l",
    "resolution": "854,480",
    "fps": 15,
    "format": "mp4",
    "renderer": "cairo"
  },
  "review": {
    "quality": "m",
    "resolution": "1280,720",
    "fps": 30,
    "format": "mp4",
    "renderer": "cairo"
  },
  "release_720p": {
    "quality": "m",
    "resolution": "1280,720",
    "fps": 30,
    "format": "mp4",
    "renderer": "cairo"
  },
  "thumbnail": {
    "saveLastFrame": true,
    "format": "png",
    "renderer": "cairo"
  }
}
```

Use Cairo for deterministic batch rendering. Use OpenGL only for scenes that require it and then record it in the manifest.

## Manifest Format

Use JSON Lines, one record per rendered asset:

```json
{
  "animationId": "mi-fractions-equivalence-v001-en",
  "conceptId": "equivalent_fractions",
  "locale": "en",
  "sourceScene": "scenes/v001/equivalent_fractions.py::EquivalentFractions",
  "sourceHash": "sha256:REPLACE_WITH_HASH",
  "manimVersion": "0.20.1",
  "renderProfile": "release_720p",
  "outputAsset": "assets/animations/manim/equivalent_fractions/en/v001.mp4",
  "durationMs": 14000,
  "contentVersion": "v001",
  "reviewStatus": "draft",
  "accessibilityDescription": "A number line and fraction bars show that one half covers the same amount as two quarters and three sixths."
}
```

Allowed `reviewStatus` values:

- `draft`
- `needs_revision`
- `approved`
- `rejected`
- `imported`

Only `approved` assets may be copied into Flutter. After copying, update to `imported`.

## Proof-of-Concept Scenes

These must be original Math Intelligence scenes, not copied 3Blue1Brown scenes.

### 1. Equivalent Fractions

Scene ID:

```text
mi-fractions-equivalence-v001-en
```

Concept:

- Show a single unit bar.
- Split into halves, then quarters, then sixths.
- Highlight that `1/2`, `2/4` and `3/6` occupy equal length.
- End with a compact rule: multiplying numerator and denominator by the same number preserves value.

Accessibility description:

```text
Fraction bars compare one half, two quarters and three sixths as equal portions of the same whole.
```

### 2. Equation Balance

Scene ID:

```text
mi-equation-balance-v001-en
```

Concept:

- Show a balance scale with `x + 3` on the left and `7` on the right.
- Remove `3` from both sides.
- Resolve to `x = 4`.
- Emphasise: whatever you do to one side, do to the other.

Accessibility description:

```text
A balance scale demonstrates solving x plus three equals seven by subtracting three from both sides.
```

### 3. Slope as Rise Over Run

Scene ID:

```text
mi-slope-rise-run-v001-en
```

Concept:

- Show coordinate axes and a line passing through two points.
- Animate horizontal run first, then vertical rise.
- Display `slope = rise / run`.
- Substitute a small example, such as rise `2`, run `3`, slope `2/3`.

Accessibility description:

```text
A line on a coordinate grid shows slope as the vertical rise divided by the horizontal run between two points.
```

## Review Workflow

1. Author original scene script under `scenes\vNNN`.
2. Render preview with fixed `--seed`.
3. Compute `sourceHash` from scene source.
4. Write/update manifest record with `reviewStatus: draft`.
5. Human review checks:
   - mathematical correctness,
   - age appropriateness,
   - visual clarity on phone and tablet,
   - no copied 3Blue1Brown scene/style/character,
   - no unsupported AI/adaptive claim,
   - no unlicensed font/media,
   - accessibility description present.
6. Mark as `approved` or `needs_revision`.
7. Compress approved source render into release profile.
8. Copy approved output into Flutter assets.
9. Add the asset path to Flutter asset configuration in a separate app-change PR.
10. Keep source scripts and manifests outside the app repo unless a deliberate content-source repo is created.

## Compression and Import

Preferred app delivery:

- MP4 H.264 for broad Android compatibility.
- WebM only if the app playback stack is verified.
- PNG thumbnail per animation.

Suggested compression target:

```text
720p, 30 fps, H.264, CRF 23-28, no audio unless required.
```

Copy rule:

```text
renders\approved\<animationId>.mp4
  -> D:\AI\Quantumlab\apps\edex\unified_math_tutor\assets\animations\manim\<conceptId>\<locale>\<contentVersion>.mp4
```

Do not copy:

- source `.py` scripts,
- Manim cache folders,
- LaTeX temp files,
- logs,
- generated AI drafts,
- unreviewed renders.

## Security Controls

- Treat all scene scripts as executable code.
- No app secrets in pipeline environment variables.
- No automatic execution of AI-generated Python.
- No network access during render except dependency installation in a controlled setup phase.
- Pin Manim and Python versions.
- Use deterministic `--seed`.
- Use a clean render output directory per batch.
- Review diffs in scene scripts before render.

## RC1 Deployment Model

For RC1:

- Keep Manim as a local authoring tool only.
- Produce at most three original POC scenes.
- Import only approved compressed media files.
- Do not add runtime Python, Manim, FFmpeg or LaTeX to the Flutter app.
- Do not use AI-to-Manim generators.

For post-RC1:

- Add CI-style render verification.
- Generate manifests automatically.
- Add visual snapshot comparison.
- Add dependency notice extraction from lockfiles.
- Consider Docker as canonical renderer if Windows native setup drifts.
