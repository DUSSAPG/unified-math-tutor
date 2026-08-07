"""Tests for scripts.asset_pipeline.reporting."""

from __future__ import annotations

import json
import unittest

from scripts.asset_pipeline import reporting
from scripts.asset_pipeline.models import BuildReport, FrameReportEntry


def _report(**overrides) -> BuildReport:
    defaults = dict(
        atlas_id="test",
        frame_count=2,
        animation_count=1,
        atlas_width=64,
        atlas_height=32,
        peak_memory_bytes=64 * 32 * 4,
        max_atlas_size=256,
    )
    defaults.update(overrides)
    return BuildReport(**defaults)


class EstimatePeakMemoryBytesTests(unittest.TestCase):
    def test_four_bytes_per_pixel(self):
        self.assertEqual(reporting.estimate_peak_memory_bytes(10, 20), 800)

    def test_zero_size_atlas(self):
        self.assertEqual(reporting.estimate_peak_memory_bytes(0, 0), 0)


class CheckSizeWarningTests(unittest.TestCase):
    def test_no_warning_when_comfortably_under_the_limit(self):
        self.assertEqual(reporting.check_size_warning(50, 50, 256), [])

    def test_warns_at_80_percent_of_the_limit(self):
        warnings = reporting.check_size_warning(210, 50, 256)
        self.assertEqual(len(warnings), 1)
        self.assertIn("256", warnings[0])

    def test_warns_when_height_alone_crosses_the_threshold(self):
        self.assertEqual(len(reporting.check_size_warning(10, 210, 256)), 1)


class ReportToJsonTests(unittest.TestCase):
    def test_round_trips_through_json(self):
        report = _report(
            warnings=["careful"],
            errors=[],
            entries=[FrameReportEntry(asset_id="a", source_file="a.png", status="ok")],
        )
        text = reporting.report_to_json_string(report)
        data = json.loads(text)
        self.assertEqual(data["atlasId"], "test")
        self.assertTrue(data["ok"])
        self.assertEqual(data["warnings"], ["careful"])
        self.assertEqual(data["entries"][0]["assetId"], "a")

    def test_ok_is_false_when_errors_present(self):
        report = _report(errors=["boom"])
        data = reporting.report_to_json(report)
        self.assertFalse(data["ok"])

    def test_json_output_is_deterministic(self):
        report = _report(
            entries=[
                FrameReportEntry(asset_id="a", source_file="a.png", status="ok"),
                FrameReportEntry(asset_id="b", source_file="b.png", status="warning", message="hmm"),
            ]
        )
        self.assertEqual(
            reporting.report_to_json_string(report),
            reporting.report_to_json_string(report),
        )


class ReportToCsvTests(unittest.TestCase):
    def test_header_and_rows(self):
        report = _report(
            entries=[
                FrameReportEntry(asset_id="a", source_file="a.png", status="ok"),
                FrameReportEntry(
                    asset_id="b", source_file="b.png", status="error", message="bad"
                ),
            ]
        )
        csv_text = reporting.report_to_csv_string(report)
        lines = csv_text.strip("\n").split("\n")
        self.assertEqual(lines[0], "asset_id,source_file,status,message")
        self.assertEqual(lines[1], "a,a.png,ok,")
        self.assertEqual(lines[2], "b,b.png,error,bad")

    def test_empty_entries_still_has_a_header(self):
        csv_text = reporting.report_to_csv_string(_report(entries=[]))
        self.assertEqual(csv_text.strip("\n"), "asset_id,source_file,status,message")


if __name__ == "__main__":
    unittest.main()
