import 'package:flutter/material.dart';

/// Icon-chip / title / subtitle / chevron tile that pushes a route on tap.
/// Shared shape for Math Studio hub tiles, Interactive Labs hub tiles, and
/// pillar-embedded entry cards for reusable formats (Recall Cards,
/// Interactive Labs) — one implementation instead of several near-identical
/// private widgets.
class RouteLinkCard extends StatelessWidget {
  const RouteLinkCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badgeText,
    this.badgeColor = const Color(0xFFFF9500),
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badgeText;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF132040),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Semantics(
          button: true,
          label: badgeText == null ? '$title. $subtitle' : '$title. $subtitle. $badgeText',
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF1F3055)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (badgeText != null) ...[
                            const SizedBox(width: 8),
                            // Fixed scale: the badge is a small status pill,
                            // not primary reading content — its text is
                            // already included in the tile's Semantics
                            // label above, so exempting it from the system
                            // text scale avoids the pill forcing an overflow
                            // on narrow phones at large accessibility scales.
                            MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaler: TextScaler.noScaling),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: badgeColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  badgeText!,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF8A9DC0),
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Color(0xFF4A6080)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
