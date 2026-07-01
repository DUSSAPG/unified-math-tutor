class GraphPoint {
  const GraphPoint(this.x, this.y);

  final double x;
  final double y;

  factory GraphPoint.fromJson(Object? value) {
    if (value is! List || value.length != 2) {
      throw const FormatException('Graph point must be a two-number list.');
    }
    return GraphPoint(
      (value[0] as num).toDouble(),
      (value[1] as num).toDouble(),
    );
  }
}

class GraphQuestion {
  const GraphQuestion({
    required this.points,
    this.xLabel = 'x',
    this.yLabel = 'y',
    this.svgAsset,
    this.latexCaption,
  });

  final List<GraphPoint> points;
  final String xLabel;
  final String yLabel;
  final String? svgAsset;
  final String? latexCaption;

  static GraphQuestion? fromQuestionJson(Map<String, dynamic> json) {
    if (json['type'] != 'graph_read') return null;
    final graph = json['graph'];
    if (graph is! Map<String, dynamic>) {
      throw const FormatException('graph_read question must contain "graph".');
    }
    final rawPoints = graph['points'];
    if (rawPoints is! List || rawPoints.isEmpty) {
      throw const FormatException(
        'graph_read question graph must contain points.',
      );
    }
    return GraphQuestion(
      points: rawPoints.map(GraphPoint.fromJson).toList(),
      xLabel: graph['xLabel'] as String? ?? 'x',
      yLabel: graph['yLabel'] as String? ?? 'y',
      svgAsset: graph['svgAsset'] as String?,
      latexCaption: graph['latexCaption'] as String?,
    );
  }
}
