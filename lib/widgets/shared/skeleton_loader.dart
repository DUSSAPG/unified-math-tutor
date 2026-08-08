import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';

// ─── Animated base box ────────────────────────────────────────────────────────

/// A single pulsating skeleton box — no external packages required.
class SkeletonBox extends StatefulWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Color.lerp(
            colors.cardSurface,
            colors.divider,
            _anim.value,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}

// ─── Topic card skeleton ──────────────────────────────────────────────────────

class SkeletonTopicCard extends StatelessWidget {
  const SkeletonTopicCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider),
      ),
      child: Row(
        children: [
          const SkeletonBox(width: 44, height: 44, borderRadius: 12),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonBox(height: 14, borderRadius: 6),
                const SizedBox(height: 8),
                SkeletonBox(
                  width: MediaQuery.sizeOf(context).width * 0.45,
                  height: 11,
                  borderRadius: 5,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const SkeletonBox(width: 24, height: 24, borderRadius: 6),
        ],
      ),
    );
  }
}

// ─── Home card skeleton ───────────────────────────────────────────────────────

class SkeletonHomeCard extends StatelessWidget {
  const SkeletonHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      height: 96,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(height: 18, borderRadius: 7),
          const SizedBox(height: 10),
          SkeletonBox(
            width: MediaQuery.sizeOf(context).width * 0.5,
            height: 13,
            borderRadius: 5,
          ),
          const Spacer(),
          const SkeletonBox(height: 3, borderRadius: 2),
        ],
      ),
    );
  }
}

// ─── Tutor message skeleton ───────────────────────────────────────────────────

class SkeletonTutorMessage extends StatelessWidget {
  final bool isUser;

  const SkeletonTutorMessage({super.key, this.isUser = false});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: width * 0.72),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            SkeletonBox(
              width: width * (isUser ? 0.5 : 0.65),
              height: 38,
              borderRadius: 14,
            ),
          ],
        ),
      ),
    );
  }
}
