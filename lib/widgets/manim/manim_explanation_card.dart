import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../shared/theme/app_spacing.dart';

class ManimExplanationCard extends StatefulWidget {
  const ManimExplanationCard({
    super.key,
    required this.title,
    required this.staticFallbackAsset,
    required this.accessibilityDescription,
    required this.nowYouTryLabel,
    this.caption,
    this.onFinished,
  });

  final String title;
  final String staticFallbackAsset;
  final String accessibilityDescription;
  final String nowYouTryLabel;
  final String? caption;
  final VoidCallback? onFinished;

  @override
  State<ManimExplanationCard> createState() => _ManimExplanationCardState();
}

class _ManimExplanationCardState extends State<ManimExplanationCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _skipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onFinished?.call();
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _reduceMotion => MediaQuery.disableAnimationsOf(context);

  void _replay() {
    setState(() => _skipped = false);
    if (_reduceMotion) {
      widget.onFinished?.call();
      return;
    }
    _controller.forward(from: 0);
  }

  void _skip() {
    setState(() => _skipped = true);
    _controller.stop();
    widget.onFinished?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${widget.title}. ${widget.accessibilityDescription}',
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF132040),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1F3055)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wrap rather than Row: at large text scales on a narrow phone,
            // the title plus both buttons no longer fit on one line — Wrap
            // drops the buttons to a second line instead of overflowing.
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton.icon(
                  onPressed: _replay,
                  icon: const Icon(Icons.replay, size: 16),
                  label: const Text('Replay'),
                ),
                TextButton(
                  onPressed: _skip,
                  child: const Text('Skip'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: const Color(0xFF0B1120),
                height: 150,
                width: double.infinity,
                alignment: Alignment.center,
                child: _skipped
                    ? Text(
                        widget.nowYouTryLabel,
                        style: const TextStyle(
                          color: Color(0xFF34C759),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          if (_reduceMotion) return child!;
                          final value =
                              Curves.easeOut.transform(_controller.value);
                          return Transform.scale(
                            scale: 0.96 + value * 0.04,
                            child: Opacity(
                                opacity: 0.72 + value * 0.28, child: child),
                          );
                        },
                        child: SvgPicture.asset(
                          widget.staticFallbackAsset,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
                      ),
              ),
            ),
            if (widget.caption != null && widget.caption!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                widget.caption!,
                style: const TextStyle(
                  color: Color(0xFF8A9DC0),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
