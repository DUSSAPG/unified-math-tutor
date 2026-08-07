"""Offline, deterministic sprite-atlas + Flutter-manifest build pipeline.

Governed asset preprocessing tooling for the Math Intelligence Flutter
app. Runs entirely offline: it reads source images from disk and writes
finished atlases/manifests back to disk. Nothing in this package is
imported by the Flutter app or invoked at runtime — see
``docs/OFFLINE_SPRITE_ATLAS_PIPELINE.md`` for the full architecture and
the (currently dormant) Flutter integration seam.

Usage::

    python -m scripts.asset_pipeline build \\
        --source assets_src/football \\
        --output assets/generated/football \\
        --atlas-id football_core
"""

from __future__ import annotations

__version__ = "1.0.0"

from .cli import main

__all__ = ["main", "__version__"]
