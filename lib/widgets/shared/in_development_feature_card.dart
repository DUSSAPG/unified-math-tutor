import 'package:flutter/material.dart';

/// Honest "in development" state for a feature area with no real content
/// yet. Deliberately carries no `onTap`/`InkWell` — it must never look like
/// a disabled or locked button, only like descriptive text about what's
/// coming. Modelled on `_AtelierFeatureCard` in
/// explore_math_intelligence_screen.dart.
class InDevelopmentFeatureCard extends StatelessWidget {
  const InDevelopmentFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.badge,
    required this.note,
    this.subItems = const [],
  });

  final IconData icon;
  final String title;
  final String body;
  final String badge;
  final String note;
  final List<String> subItems;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title. $body. $badge. $note',
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF132040).withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1F3055)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF8A9DC0).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF8A9DC0), size: 20),
            ),
            const SizedBox(width: 12),
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
                            color: Color(0xFFD5DCEA),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Fixed scale, matching RouteLinkCard's identical badge
                      // pill: small status text, already duplicated in this
                      // card's own Semantics label above, so exempting it
                      // from the system text scale avoids the pill competing
                      // with the title for width at large accessibility
                      // scales.
                      MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: TextScaler.noScaling),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9500),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            badge,
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
                  ),
                  const SizedBox(height: 3),
                  Text(
                    body,
                    style: const TextStyle(
                      color: Color(0xFF8A9DC0),
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                  if (subItems.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    for (final item in subItems)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          '•  $item',
                          style: const TextStyle(
                            color: Color(0xFF8A9DC0),
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                      ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    note,
                    style: const TextStyle(
                      color: Color(0xFF5F7099),
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
