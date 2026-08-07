"""Data models for the offline sprite-atlas pipeline.

Pure dataclasses only — no I/O, no global state (research principle 4).
Every pipeline stage (discovery, image_io, normalization, trimming,
packing, metadata, validation, flutter_catalog, reporting) passes and
returns these types explicitly rather than mutating anything shared.

Anchor convention: an animation/sprite's anchor is stored as a fraction
of its *original, untrimmed* frame size (default ``0.5, 0.5`` — the
centre). Because it is defined against ``original_width``/
``original_height`` (which every record also carries), the anchor
fraction is invariant to trimming by construction — recovering the
anchor's pixel position within a *trimmed* frame is a one-line
computation the Flutter/Dart side (or a test) can do itself:
``anchor_px_original - (trimmed_offset_x, trimmed_offset_y)``.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path

import numpy as np


class AssetPipelineError(Exception):
    """Base class for every pipeline failure. The pipeline fails safely by
    design (research: "fail safely rather than silently dropping assets")
    — every error case raises one of these instead of skipping or
    truncating data."""


class SourceDirectoryNotFoundError(AssetPipelineError):
    """The configured source directory does not exist."""


class DuplicateAssetIdError(AssetPipelineError):
    """Two source images resolved to the same asset id."""


class UnreadableImageError(AssetPipelineError):
    """A source file could not be decoded as an image."""


class BlankFrameError(AssetPipelineError):
    """A source frame is fully transparent (contains no visible pixels)."""


class AtlasSizeExceededError(AssetPipelineError):
    """The packed atlas would exceed ``PipelineConfig.max_atlas_size``."""


class OutputExistsError(AssetPipelineError):
    """The output directory already has content and ``--overwrite`` was
    not supplied."""


class ManifestValidationError(AssetPipelineError):
    """A generated manifest failed schema or geometry validation."""


class LoopMode(str, Enum):
    """How an animation record should play back in Flutter."""

    ONCE = "once"
    LOOP = "loop"
    PING_PONG = "ping_pong"


@dataclass(frozen=True, slots=True)
class SourceImage:
    """One discovered source file: identified and hashed, not yet decoded."""

    id: str
    path: Path
    sha256: str


@dataclass(frozen=True, slots=True)
class AssetGroup:
    """A stable asset id and its ordered source frames.

    A single un-numbered file (``ball.png``) is a group of one. A
    numbered sequence (``kick_01.png``, ``kick_02.png``, ...) is a group
    of several, already sorted into playback order.
    """

    asset_id: str
    images: tuple[SourceImage, ...]


@dataclass(frozen=True, slots=True)
class DecodedFrame:
    """A single decoded, RGBA-normalized source frame, ready to trim."""

    source: SourceImage
    pixels: np.ndarray  # (height, width, 4) uint8, RGBA
    original_width: int
    original_height: int


@dataclass(frozen=True, slots=True)
class TrimResult:
    """The result of trimming transparent borders from a [DecodedFrame]."""

    pixels: np.ndarray  # trimmed (height, width, 4) uint8 RGBA
    offset_x: int  # left offset of the trimmed box within the original
    offset_y: int  # top offset of the trimmed box within the original
    width: int
    height: int


@dataclass(frozen=True, slots=True)
class PackedFrame:
    """One frame after packing: its atlas placement plus everything a
    manifest record needs to describe it."""

    source: SourceImage
    atlas_x: int
    atlas_y: int
    atlas_width: int
    atlas_height: int
    original_width: int
    original_height: int
    trimmed_offset_x: int
    trimmed_offset_y: int


@dataclass(frozen=True, slots=True)
class FrameRect:
    """The serializable, manifest-facing shape of one [PackedFrame]."""

    source_file: str
    source_hash: str
    x: int
    y: int
    width: int
    height: int
    original_width: int
    original_height: int
    trimmed_offset_x: int
    trimmed_offset_y: int


@dataclass(frozen=True, slots=True)
class AnimationRecord:
    """One manifest record. A single sprite and a numbered-sequence
    animation share this exact shape — a single-frame record just has one
    entry in [frames]."""

    asset_id: str
    frames: tuple[FrameRect, ...]
    atlas_file: str
    anchor_x: float
    anchor_y: float
    frame_duration_ms: int
    loop: LoopMode
    reduced_motion_fallback_frame: int
    content_version: int
    verified: bool

    @property
    def source_files(self) -> tuple[str, ...]:
        return tuple(f.source_file for f in self.frames)

    @property
    def source_hashes(self) -> tuple[str, ...]:
        return tuple(f.source_hash for f in self.frames)


@dataclass(frozen=True, slots=True)
class PipelineConfig:
    """Governed defaults with explicit keyword overrides (research
    principle 5). Only ``source``/``output``/``atlas_id`` have no default —
    the CLI always requires them."""

    source: Path
    output: Path
    atlas_id: str
    max_atlas_size: int = 2048
    padding: int = 2
    extrusion: int = 1
    trim: bool = True
    overwrite: bool = False
    frame_duration_ms: int = 100
    loop: LoopMode = LoopMode.LOOP
    content_version: int = 1
    anchor_x: float = 0.5
    anchor_y: float = 0.5
    supported_extensions: tuple[str, ...] = (".png", ".jpg", ".jpeg")


@dataclass(slots=True)
class FrameReportEntry:
    """One row of the per-frame CSV/JSON report."""

    asset_id: str
    source_file: str
    status: str  # "ok" | "warning" | "error"
    message: str = ""


@dataclass(slots=True)
class BuildReport:
    """The structured build/validation report (research principle 7)."""

    atlas_id: str
    frame_count: int
    animation_count: int
    atlas_width: int
    atlas_height: int
    peak_memory_bytes: int
    max_atlas_size: int
    warnings: list[str] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)
    entries: list[FrameReportEntry] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.errors
