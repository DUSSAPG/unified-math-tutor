import 'package:flutter/material.dart';

/// Static offline indicator banner. Wire [visible] to a `ValueNotifier<bool>`
/// in your state when real connectivity detection is added.
/// Hidden by default (visible: false).
class OfflineBanner extends StatelessWidget {
  final bool visible;

  const OfflineBanner({super.key, this.visible = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 280),
      crossFadeState:
          visible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: const Color(0xFF1A0A00),
        child: const Row(
          children: [
            Icon(Icons.wifi_off_rounded, color: Color(0xFFFF9500), size: 16),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Offline Mode',
                    style: TextStyle(
                      color: Color(0xFFFF9500),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Some features may be unavailable.',
                    style: TextStyle(
                      color: Color(0xFF8A9DC0),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      secondChild: const SizedBox.shrink(),
    );
  }
}
