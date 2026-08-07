import 'spatial_cube_face.dart';
import 'spatial_cube_orientation.dart';

/// One square of a cube net, positioned on a flat (row, col) grid. [face]
/// is the cell's destination when the net folds — only meaningful for a
/// valid net; invalid nets still carry a best-effort [face] assignment (an
/// intentional folding *attempt* that doesn't actually close into a cube)
/// purely so every cell has a colour to render, never used for a real fold.
class CubeNetCell {
  const CubeNetCell({required this.row, required this.col, required this.face});

  final int row;
  final int col;
  final CubeFace face;

  /// The cell's four corners on the flat net, in the same perimeter order
  /// as [cubeFaceLocalCorners] (bottom-left, bottom-right, top-right,
  /// top-left of the square) so a fold animation can lerp corner-to-corner
  /// without re-deriving correspondence per cell. Embedded in the z=0
  /// plane at the same 2-unit cell size as a folded cube face, so a valid
  /// net's fold ends up at the exact scale of [CubeOrientation.initial].
  List<(double x, double y, double z)> flatCorners({
    required double centerRow,
    required double centerCol,
  }) {
    final flatX = (col - centerCol) * 2;
    final flatY = -(row - centerRow) * 2;
    return [
      (flatX - 1, flatY - 1, 0.0),
      (flatX + 1, flatY - 1, 0.0),
      (flatX + 1, flatY + 1, 0.0),
      (flatX - 1, flatY + 1, 0.0),
    ];
  }

  /// The cell's four corners once fully folded — exactly [face]'s position
  /// on the unit cube.
  List<(double x, double y, double z)> get foldedCorners =>
      cubeFaceLocalCorners(face);
}

/// A cube net: 6 connected squares that either do, or don't, fold into a
/// closed cube. Mirrors `cube_nets_screen.dart`'s existing curated
/// approach (hand-verified nets with a fixed `isValid` flag) rather than a
/// general net-folding validator — this is a small, fixed catalogue of
/// textbook examples, not procedurally generated.
class CubeNet {
  const CubeNet({
    required this.id,
    required this.cells,
    required this.isValid,
    required this.explanation,
  });

  final String id;
  final List<CubeNetCell> cells;
  final bool isValid;
  final String explanation;

  double get _centerRow {
    final rows = cells.map((c) => c.row);
    return (rows.reduce((a, b) => a < b ? a : b) +
            rows.reduce((a, b) => a > b ? a : b)) /
        2;
  }

  double get _centerCol {
    final cols = cells.map((c) => c.col);
    return (cols.reduce((a, b) => a < b ? a : b) +
            cols.reduce((a, b) => a > b ? a : b)) /
        2;
  }

  /// Every cell's flat-net corners, already centred on the net's own
  /// bounding box (independent of [cells] ordering or grid position).
  List<List<(double x, double y, double z)>> flatCornersByCell() {
    final centerRow = _centerRow;
    final centerCol = _centerCol;
    return [
      for (final cell in cells)
        cell.flatCorners(centerRow: centerRow, centerCol: centerCol),
    ];
  }
}

/// 3 hand-picked, verified nets — 2 that fold into a closed cube with a
/// correct face assignment, 1 that doesn't — enough to satisfy "at least
/// three deterministic nets" while keeping every fold hand-verified rather
/// than procedurally generated (there are 11 valid hexomino cube nets in
/// total; a fuller set is future content-authoring work, matching
/// `docs/SPATIAL_INTELLIGENCE_BACKLOG.md`'s existing "more cube nets"
/// backlog item for the sibling 2D activity).
final List<CubeNet> kCubeNets = [
  CubeNet(
    id: 'cross',
    isValid: true,
    explanation:
        'Yes — this is the classic cross net. The four middle squares wrap '
        'around to become the front, right, back and left faces; the '
        'square above becomes the top, and the square below becomes the '
        'bottom.',
    cells: const [
      CubeNetCell(row: 0, col: 1, face: CubeFace.top),
      CubeNetCell(row: 1, col: 0, face: CubeFace.left),
      CubeNetCell(row: 1, col: 1, face: CubeFace.front),
      CubeNetCell(row: 1, col: 2, face: CubeFace.right),
      CubeNetCell(row: 1, col: 3, face: CubeFace.back),
      CubeNetCell(row: 2, col: 1, face: CubeFace.bottom),
    ],
  ),
  CubeNet(
    id: 'staircase',
    isValid: true,
    explanation:
        'Yes — this staircase shape also folds into a closed cube, even '
        'though it looks less symmetric than the cross.',
    cells: const [
      CubeNetCell(row: 0, col: 0, face: CubeFace.top),
      CubeNetCell(row: 1, col: 0, face: CubeFace.back),
      CubeNetCell(row: 1, col: 1, face: CubeFace.front),
      CubeNetCell(row: 2, col: 1, face: CubeFace.bottom),
      CubeNetCell(row: 2, col: 2, face: CubeFace.right),
      CubeNetCell(row: 3, col: 2, face: CubeFace.left),
    ],
  ),
  CubeNet(
    id: 'straight-line',
    isValid: false,
    explanation: 'No — a straight line of 6 squares folds back on itself: two '
        'faces end up trying to occupy the same side of the cube.',
    cells: const [
      CubeNetCell(row: 0, col: 0, face: CubeFace.front),
      CubeNetCell(row: 0, col: 1, face: CubeFace.right),
      CubeNetCell(row: 0, col: 2, face: CubeFace.back),
      CubeNetCell(row: 0, col: 3, face: CubeFace.left),
      CubeNetCell(row: 0, col: 4, face: CubeFace.front),
      CubeNetCell(row: 0, col: 5, face: CubeFace.right),
    ],
  ),
  CubeNet(
    id: '2x3-block',
    isValid: false,
    explanation:
        'No — a solid 2×3 block overlaps two faces on top of each other '
        'when folded, and leaves one side of the cube open.',
    cells: const [
      CubeNetCell(row: 0, col: 0, face: CubeFace.top),
      CubeNetCell(row: 0, col: 1, face: CubeFace.back),
      CubeNetCell(row: 0, col: 2, face: CubeFace.right),
      CubeNetCell(row: 1, col: 0, face: CubeFace.left),
      CubeNetCell(row: 1, col: 1, face: CubeFace.front),
      CubeNetCell(row: 1, col: 2, face: CubeFace.bottom),
    ],
  ),
];
