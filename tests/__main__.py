"""Discovers and runs every test under ``tests/`` — invoked as
``py -m tests`` from the repo root (the closest equivalent this Windows
environment has to the brief's ``python tests``, since ``python``/``py``
here is only available via the ``py`` launcher, not directly on PATH).
"""

from __future__ import annotations

import sys
import unittest
from pathlib import Path

if __name__ == "__main__":
    repo_root = Path(__file__).resolve().parent.parent
    loader = unittest.TestLoader()
    suite = loader.discover(
        start_dir=str(Path(__file__).resolve().parent),
        pattern="test_*.py",
        top_level_dir=str(repo_root),
    )
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)
    sys.exit(0 if result.wasSuccessful() else 1)
