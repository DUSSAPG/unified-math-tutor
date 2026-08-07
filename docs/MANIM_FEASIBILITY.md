# Manim Feasibility for Math Intelligence

Date: 2026-07-25

Scope: offline mathematical-animation production pipeline only. This document does not approve runtime Python execution inside the Flutter app.

## Recommendation

Use **Manim Community Edition** for the production pipeline and keep it outside the Flutter app under:

```text
D:\AI\Quantumlab\tools\manim_pipeline
```

Use the pipeline to produce reviewed video/image assets that are copied into Flutter assets only after human review.

## Sources Reviewed

- Manim Community repository: <https://github.com/ManimCommunity/manim>
- Manim Community licence files: <https://github.com/ManimCommunity/manim/blob/main/LICENSE> and <https://github.com/ManimCommunity/manim/blob/main/LICENSE.community>
- Manim Community docs: <https://docs.manim.community/en/stable/>
- Manim Community Docker docs: <https://docs.manim.community/en/stable/installation/docker.html>
- ManimGL repository: <https://github.com/3b1b/manim>
- ManimGL licence file: <https://github.com/3b1b/manim/blob/master/LICENSE.md>
- 3Blue1Brown video-scene repository notice: <https://github.com/3b1b/videos>
- FFmpeg licence summary: <https://github.com/FFmpeg/FFmpeg/blob/master/LICENSE.md>
- LaTeX Project Public License: <https://www.latex-project.org/lppl/>

## Edition Comparison

| Area | Manim Community | ManimGL / 3b1b Manim |
| --- | --- | --- |
| Primary package | `manim` | `manimgl` |
| Licence | MIT, with separate MIT notices for original 3Blue1Brown LLC code and Manim Community code | MIT for engine code |
| Maintenance | More active community edition, current docs identify v0.20.1 | Maintained by 3Blue1Brown; README says Community Edition is friendlier/stabler for general users |
| Installation | Python package tooling, official Windows/macOS/Linux docs, Docker image | Python package tooling; Windows setup documented but more manual |
| Rendering backends | Cairo and OpenGL selectable via CLI | OpenGL-first workflow |
| Output formats | PNG, GIF, MP4, WebM, MOV; save last frame; section videos | Video output through `manimgl` / `manim-render`; flags differ |
| Windows support | Official Windows installation path linked from Manim Community site | README includes Windows install steps with FFmpeg, MiKTeX and pip |
| Docker support | Official `manimcommunity/manim` image with version tags | No comparable first-party Docker path found in reviewed docs |
| Documentation | Extensive current docs and reference manual | Docs exist, but README says documentation is in progress |
| Stability for batch rendering | Better fit because CLI render options, Docker, stable tags and docs are explicit | Better for studying 3Blue1Brown workflow, less suitable for RC1 batch production |

## Commercial Use

Commercial use of the **Manim engine code** is permitted under MIT, provided copyright and permission notices are included with redistributed copies or substantial portions of the software.

Commercial use of **original Math Intelligence scene scripts and rendered output** is acceptable if:

- scripts are created by Quantumlab,
- no third-party visual assets are copied,
- fonts and media assets are separately licensed,
- FFmpeg/LaTeX dependency obligations are satisfied,
- no 3Blue1Brown scene content, narration, characters or channel-specific assets are copied.

## Must Not Copy Into a Paid Product

Do not copy:

- 3Blue1Brown video scenes from `3b1b/videos`.
- 3Blue1Brown narration, scripts, thumbnails, channel artwork or pi-creature/character designs.
- Example scenes as production content without reviewing their licence and rewriting them as original assets.
- Online-gallery example assets, screenshots or rendered clips as app content.
- Fonts without commercial embedding rights.
- FFmpeg binaries built with `--enable-nonfree`; those builds may be unredistributable.
- Generated AI scene code unless the prompt, model terms, licence, dependencies and safety review are recorded.

## AI-to-Manim Generators

Reviewed candidates:

- `makefinks/manim-generator`: MIT-labelled repository, uses LiteLLM/OpenRouter/OpenAI/Anthropic-style external providers and executes generated Manim code.
- `HarleyCoops/Math-To-Manim`: MIT-labelled repository, appears to be a larger AI-assisted animation tool with generated code/media workflow.
- `rohitg00/manim-video-generator`: MIT-labelled repository, uses OpenAI GPT to generate Manim code.
- `3brown1blue` PyPI package: MIT-labelled package but explicitly markets "3Blue1Brown-style" generation, which is a brand/style risk for Math Intelligence.

Recommendation: **do not install or depend on AI-to-Manim generators for RC1**. They introduce arbitrary Python execution, external service dependencies, prompt-output provenance problems and style/IP risk. If explored post-RC1, run them only in a locked sandbox with no app secrets, no network except approved model endpoints, deterministic saved prompts, dependency lockfiles and mandatory human code review before rendering.

## Security Risks

- Manim scene scripts are Python code and can execute arbitrary local operations.
- AI-generated scene scripts can hide filesystem, network or subprocess calls.
- LaTeX compilation can execute external tools depending on configuration; disable shell escape and keep templates minimal.
- FFmpeg processes untrusted media; use trusted local sources only.
- Do not run scene generation inside Flutter or on user devices.
- Keep the production Flutter app asset-only: video/image files plus manifest metadata.

## Dependency Risks

- Manim Community currently requires Python 3.11+.
- Native packages include Cairo/Pango/text rendering, FFmpeg, OpenGL-related packages and optional LaTeX/Typst.
- Windows setup is feasible but sensitive to PATH, FFmpeg binary provenance and MiKTeX/TeX package installation.
- Docker is useful for reproducibility but may need extra TeX packages.
- Dependency licences need a per-lockfile review before distributing any tooling bundle.
- Rendered outputs should be treated as assets created by the pipeline, not as bundled engine/runtime dependencies.

## Storage and Rendering Implications

Expected asset budget for short concept clips:

- 720p MP4/WebM, 10-20 seconds: usually about 0.5-3 MB after compression.
- 1080p MP4/WebM, 10-20 seconds: often about 2-8 MB depending on motion and bitrate.
- GIF should be avoided for app assets except tiny previews; it is usually much larger than MP4/WebM.
- Still PNG frames are useful for thumbnails but not animation delivery.

Rendering implications:

- Low-quality preview renders are suitable during authoring.
- Batch-review renders should be deterministic via fixed `--seed`, pinned scene version, pinned Manim version and recorded source hash.
- Final app assets should be encoded separately from source renders with fixed compression profiles.

## RC1 vs Post-RC1

**RC1 recommendation:** approve feasibility and create the external local pipeline skeleton, but ship only a very small manually reviewed set of original animations if there is time for legal and visual QA. Do not add AI generation or runtime Python.

**Post-RC1 recommendation:** expand into a formal content production workflow with locked dependencies, automated render manifests, visual regression snapshots, transcript/accessibility review and a licence register generated from the Python lockfile plus binary dependency inventory.
