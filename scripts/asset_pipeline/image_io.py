"""Context-managed source-image decoding.

Loads one file at a time and closes the Pillow handle promptly
(``with Image.open(...) as handle:``). [iter_frames] is a generator, not
a list, so a caller processing many sources never holds more decoded
frames in memory than it is actively using — the "don't retain every
decoded image unnecessarily" / "process incrementally" performance
principles.
"""

from __future__ import annotations

from collections.abc import Iterable, Iterator

from PIL import Image, UnidentifiedImageError

from .models import BlankFrameError, DecodedFrame, SourceImage, UnreadableImageError
from .normalization import is_blank, to_rgba_array


def load_frame(source: SourceImage) -> DecodedFrame:
    """Decodes one source file into a [DecodedFrame], normalized to RGBA.

    Raises [UnreadableImageError] for a corrupt/unsupported file and
    [BlankFrameError] for a fully-transparent frame — both fail the build
    rather than being silently skipped (research: "fail safely rather
    than silently dropping assets").
    """
    try:
        with Image.open(source.path) as handle:
            handle.load()
            pixels = to_rgba_array(handle)
    except (OSError, UnidentifiedImageError) as error:
        raise UnreadableImageError(
            f"Could not read image '{source.path}': {error}"
        ) from error

    if is_blank(pixels):
        raise BlankFrameError(f"Source frame '{source.path}' is fully transparent.")

    height, width = pixels.shape[:2]
    return DecodedFrame(
        source=source,
        pixels=pixels,
        original_width=width,
        original_height=height,
    )


def iter_frames(sources: Iterable[SourceImage]) -> Iterator[DecodedFrame]:
    """Decodes frames one at a time. A generator, not a list — see the
    module docstring."""
    for source in sources:
        yield load_frame(source)
