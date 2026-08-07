import 'package:flutter/material.dart';

/// Native-Flutter placeholder apple — a plain shape, not platform emoji,
/// matching [PandaVisual]'s "governed placeholder, replaceable later"
/// contract. Kept as a tiny, self-contained widget so a future asset swap
/// only touches this one file.
class AppleVisual extends StatelessWidget {
  const AppleVisual({super.key, this.size = 48, this.faded = false});

  final double size;

  /// Dimmed rendering for the "already accepted / mid-drag placeholder"
  /// look, so an accepted slot doesn't read as simply missing.
  final bool faded;

  @override
  Widget build(BuildContext context) {
    final opacity = faded ? 0.25 : 1.0;
    return SizedBox(
      width: size,
      height: size,
      child: Opacity(
        opacity: opacity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size * 0.85,
              height: size * 0.85,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE53935),
              ),
            ),
            Positioned(
              top: size * 0.06,
              child: Container(
                width: size * 0.28,
                height: size * 0.24,
                decoration: BoxDecoration(
                  color: const Color(0xFF43A047),
                  borderRadius: BorderRadius.circular(size * 0.14),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                width: size * 0.08,
                height: size * 0.16,
                decoration: BoxDecoration(
                  color: const Color(0xFF6D4C2B),
                  borderRadius: BorderRadius.circular(size * 0.04),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
