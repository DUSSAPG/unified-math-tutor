import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../services/local_preferences_service.dart';

class RewardConfetti extends StatefulWidget {
  const RewardConfetti({super.key, this.play = true});

  final bool play;

  @override
  State<RewardConfetti> createState() => _RewardConfettiState();
}

class _RewardConfettiState extends State<RewardConfetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isEnabled(context)) _controller.forward();
    });
  }

  bool _isEnabled(BuildContext context) =>
      widget.play &&
      LocalPreferencesService.instance.rewardsEnabled.value &&
      !LocalPreferencesService.instance.reduceMotion.value &&
      !MediaQuery.disableAnimationsOf(context);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEnabled(context)) return const SizedBox.shrink();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        painter: _ConfettiPainter(_controller.value),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.progress);

  final double progress;
  static const _colors = [
    Color(0xFF5B8EFF),
    Color(0xFF34C759),
    Color(0xFFFFBD00),
    Color(0xFFFF9500),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (var index = 0; index < 28; index++) {
      final x = size.width * ((index * 37) % 100) / 100;
      final drift = math.sin(progress * math.pi * 2 + index) * 18;
      final y = -12 + (size.height + 24) * progress * (0.65 + (index % 5) / 12);
      final paint = Paint()..color = _colors[index % _colors.length];
      canvas.save();
      canvas.translate(x + drift, y);
      canvas.rotate(progress * math.pi * (index % 4 + 1));
      canvas.drawRect(const Rect.fromLTWH(-3, -5, 6, 10), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
