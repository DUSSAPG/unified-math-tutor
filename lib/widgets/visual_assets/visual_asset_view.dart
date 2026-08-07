import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/visual_asset.dart';
import '../../services/visual_asset_service.dart';
import '../../shared/theme/app_theme.dart';

/// Renders one [VisualAsset] by id: the SVG-first / PNG-fallback educational
/// diagram widget the Visual Asset System is built around. Resolves the
/// asset from [VisualAssetCatalogService], never shows a broken-image glyph
/// for a missing/unknown id (a labeled placeholder tile instead — same
/// contract as [DiscoveryIllustration]), and plays a subtle one-time
/// entrance fade/scale that's skipped outright under Reduce Motion (same
/// pattern as `ManimExplanationCard`, just without its replay/skip chrome —
/// this widget is a plain embeddable diagram, not a full explanation card).
class VisualAssetView extends StatefulWidget {
  const VisualAssetView({
    super.key,
    required this.assetId,
    this.height = 160,
    this.animate = true,
  });

  /// The [VisualAsset.id] to resolve and render.
  final String assetId;
  final double height;

  /// Set false to render statically with no entrance animation at all
  /// (independent of Reduce Motion) — e.g. inside a list where many
  /// instances animating at once would be noisy.
  final bool animate;

  @override
  State<VisualAssetView> createState() => _VisualAssetViewState();
}

class _VisualAssetViewState extends State<VisualAssetView>
    with SingleTickerProviderStateMixin {
  late Future<VisualAsset?> _future =
      VisualAssetCatalogService.instance.byId(widget.assetId);

  // Constructed eagerly in initState (not as a lazy `late final` field
  // initializer) so it always exists by the time dispose() runs, even when
  // `animate` is false and the controller is otherwise never touched — a
  // lazy first-access inside dispose() tries to create an AnimationController
  // (which looks up an ancestor via createTicker) after the element is
  // already deactivated, throwing "Looking up a deactivated widget's
  // ancestor is unsafe."
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didUpdateWidget(covariant VisualAssetView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetId != widget.assetId) {
      _future = VisualAssetCatalogService.instance.byId(widget.assetId);
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _reduceMotion => MediaQuery.disableAnimationsOf(context);

  Widget _placeholder(AppSemanticColors colors, {required String label}) {
    return Container(
      height: widget.height,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.image_outlined, color: colors.tertiaryText, size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(color: colors.tertiaryText, fontSize: 11),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return FutureBuilder<VisualAsset?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _placeholder(colors, label: 'Loading diagram…');
        }
        final asset = snapshot.data;
        if (asset == null) {
          // A missing/unregistered id is a normal, expected case this
          // widget must degrade gracefully for — never a crash, never a
          // broken-image glyph.
          return _placeholder(colors, label: 'Diagram unavailable');
        }

        final art = ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: widget.height,
            width: double.infinity,
            color: colors.cardSurface,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              asset.svgAssetPath,
              fit: BoxFit.contain,
              width: double.infinity,
              placeholderBuilder: (context) =>
                  _placeholder(colors, label: 'Loading diagram…'),
            ),
          ),
        );

        return Semantics(
          label: asset.accessibilityDescription,
          image: true,
          child: ExcludeSemantics(
            child: widget.animate && !_reduceMotion
                ? _AnimatedEntrance(controller: _controller, child: art)
                : art,
          ),
        );
      },
    );
  }
}

class _AnimatedEntrance extends StatefulWidget {
  const _AnimatedEntrance({required this.controller, required this.child});

  final AnimationController controller;
  final Widget child;

  @override
  State<_AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<_AnimatedEntrance> {
  @override
  void initState() {
    super.initState();
    if (widget.controller.value == 0) widget.controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      child: widget.child,
      builder: (context, child) {
        final value = Curves.easeOut.transform(widget.controller.value);
        return Transform.scale(
          scale: 0.96 + value * 0.04,
          child: Opacity(opacity: 0.72 + value * 0.28, child: child),
        );
      },
    );
  }
}
