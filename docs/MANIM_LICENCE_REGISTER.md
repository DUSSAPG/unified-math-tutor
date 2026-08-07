# Manim Licence Register

Date: 2026-07-25

This register is for a local production pipeline that creates static media assets for Math Intelligence. It is not legal advice.

## Summary

| Component | Licence Finding | Commercial Use | Notice / Attribution Obligations | Product Rule |
| --- | --- | --- | --- | --- |
| Manim Community engine | MIT. Repository reports dual MIT notices: original 3Blue1Brown LLC copyright and Manim Community Developers copyright. | Yes. | Include MIT copyright and permission notices if distributing engine code or substantial portions. Citation is requested by project docs but is not an MIT licence condition. | Approved for local offline render pipeline. |
| Manim Community examples | Generally part of repository, but examples should be treated as sample code, not production educational content. | Likely yes under repo licence, but still avoid copying visual pedagogy directly. | Preserve MIT notice if copied. | Use only for learning; write original scenes. |
| ManimGL / `3b1b/manim` engine | MIT for engine code. | Yes. | Include MIT notice if distributing engine code or substantial portions. | Research/reference only for RC1. |
| 3Blue1Brown `videos` scene code/content | Repository notice states Manim library is MIT, but video-repo contents are Creative Commons Attribution-NonCommercial-ShareAlike 4.0. | No for paid product without separate permission. | CC BY-NC-SA obligations if used, but non-commercial condition conflicts with paid product use. | Do not copy into Math Intelligence. |
| 3Blue1Brown characters/visual identity | Separate IP/trademark/style risk indicated by public maintainer comments. | Not approved. | Separate permission required. | Do not copy pi creatures, narration, thumbnails, characters or channel visual identity. |
| Original Math Intelligence scene scripts | Quantumlab-owned if written from scratch. | Yes. | Internal copyright and manifest record. | Approved after review. |
| Rendered outputs from original scenes | Quantumlab-owned output, subject to dependency/media/font constraints. | Yes. | Record source hash, engine version, font/media attributions and review status. | Copy into Flutter assets only after review. |
| FFmpeg binary/tooling | FFmpeg is generally LGPL v2.1+ by default; GPL/nonfree options can change redistribution status. | Yes if compliant; avoid nonfree builds. | Include FFmpeg licence notices if distributing FFmpeg. If only used as local build tooling, keep provenance in tooling docs. | Use a trusted LGPL-compatible build; do not bundle nonfree builds. |
| LaTeX / TeX packages | LaTeX is under LPPL; individual packages may vary. | Usually yes with licence compliance. | Keep package inventory; preserve notices for bundled packages. | Prefer plain text/Manim `Text` where possible; use minimal TeX templates. |
| Fonts | Varies by font. | Depends on font licence and embedding rights. | Include font licence/attribution if required. | Use app-approved fonts or open fonts with commercial embedding permission. |
| Images, audio, SVGs | Varies by asset. | Depends on source licence. | Record each asset in manifest or asset register. | Use original or commercially licensed assets only. |
| Docker image `manimcommunity/manim` | Convenience distribution of engine and dependencies; image contents include multiple packages. | Yes for local tooling if licences respected. | Do not redistribute image without full image licence inventory. | Use locally for reproducible rendering; do not ship with app. |
| AI-to-Manim generators | Candidate repos found with MIT labels, but use external LLM services and generate executable Python. | Licence may permit software use; generated output rights and service terms require separate review. | Preserve notices if copied; record model/provider terms and prompts. | Not approved for RC1. |

## Notice Obligations

If distributing Manim engine code, a fork, or substantial copied source:

- Include Manim Community MIT notices.
- Include original 3Blue1Brown LLC MIT notice where applicable.
- Include dependency notices for bundled Python packages and native binaries.

If only using Manim internally to render videos:

- Keep a licence register and dependency lockfile in the pipeline.
- Do not need to put Manim notices inside every rendered video solely because it was used as a tool.
- Still include notices for any copied code/assets/fonts/media that appear in the distributed app.

If copying or adapting example code:

- Preserve MIT notices if substantial code is copied.
- Prefer rewriting examples as original Math Intelligence scene scripts.

## Attribution Guidance

Suggested internal attribution file for the pipeline:

```text
This content production pipeline uses Manim Community Edition,
an MIT-licensed mathematical animation engine.
Manim includes original copyright by 3Blue1Brown LLC and
copyright by Manim Community Developers.
```

Do not imply endorsement by 3Blue1Brown, Grant Sanderson or Manim Community.

## Commercial Use Finding

Commercial use is permitted for:

- Manim Community engine code under MIT.
- ManimGL engine code under MIT.
- Original Math Intelligence scene scripts and renders.

Commercial use is not approved for:

- 3Blue1Brown `videos` repository content under CC BY-NC-SA.
- 3Blue1Brown characters, narration, channel assets or recognisable scene recreations.
- Any FFmpeg build marked nonfree or unredistributable.
- Fonts/media without commercial rights.

## Required Pre-Ship Checks

Before any rendered Manim asset ships in Math Intelligence:

1. Confirm the scene script is original.
2. Confirm no 3Blue1Brown scene, narration, character or visual asset is copied.
3. Record the Manim version and source hash.
4. Record all fonts, SVGs, images and audio used.
5. Confirm FFmpeg build provenance for compression.
6. Confirm accessibility description exists.
7. Mark `reviewStatus` as `approved`.
