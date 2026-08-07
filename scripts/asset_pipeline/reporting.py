"""Structured build/validation reporting (research principle 7).

Turns a [BuildReport] into CSV rows (one per frame) and a JSON summary —
the two formats a human or a CI pipeline would actually want to consume.
"""

from __future__ import annotations

import csv
import io
import json

from .models import BuildReport

# Warn once an atlas reaches this fraction of its configured maximum, so a
# team can plan ahead of an actual AtlasSizeExceededError.
_ATLAS_WARNING_THRESHOLD = 0.8


def estimate_peak_memory_bytes(atlas_width: int, atlas_height: int) -> int:
    """Peak atlas memory: one byte per RGBA channel per pixel — the exact
    size of the preallocated numpy buffer, and (approximately) what
    Flutter will hold in memory once the atlas is decoded."""
    return atlas_width * atlas_height * 4


def check_size_warning(
    atlas_width: int, atlas_height: int, max_atlas_size: int
) -> list[str]:
    """Warns (does not fail) when an atlas is close to its configured
    maximum."""
    threshold = max_atlas_size * _ATLAS_WARNING_THRESHOLD
    if atlas_width >= threshold or atlas_height >= threshold:
        margin_pct = int((1 - _ATLAS_WARNING_THRESHOLD) * 100)
        return [
            f"Atlas is {atlas_width}x{atlas_height}px, within {margin_pct}% "
            f"of the configured max of {max_atlas_size}px — consider "
            "splitting this atlas soon."
        ]
    return []


def report_to_json(report: BuildReport) -> dict:
    return {
        "atlasId": report.atlas_id,
        "ok": report.ok,
        "frameCount": report.frame_count,
        "animationCount": report.animation_count,
        "atlasWidth": report.atlas_width,
        "atlasHeight": report.atlas_height,
        "peakMemoryBytes": report.peak_memory_bytes,
        "maxAtlasSize": report.max_atlas_size,
        "warnings": list(report.warnings),
        "errors": list(report.errors),
        "entries": [
            {
                "assetId": entry.asset_id,
                "sourceFile": entry.source_file,
                "status": entry.status,
                "message": entry.message,
            }
            for entry in report.entries
        ],
    }


def report_to_json_string(report: BuildReport) -> str:
    return json.dumps(report_to_json(report), indent=2) + "\n"


def report_to_csv_string(report: BuildReport) -> str:
    buffer = io.StringIO()
    writer = csv.writer(buffer, lineterminator="\n")
    writer.writerow(["asset_id", "source_file", "status", "message"])
    for entry in report.entries:
        writer.writerow(
            [entry.asset_id, entry.source_file, entry.status, entry.message]
        )
    return buffer.getvalue()
