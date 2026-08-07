import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../shared/theme/app_theme.dart';

/// Allie speaks to the parent — reassurance and light guidance, never an
/// instruction to "teach". Purely presentational: static authored [message]
/// text passed in per screen, no service, no state, no input. Deliberately
/// never a working conversational surface — Allie has no live/AI
/// implementation anywhere in this app.
class AllieCard extends StatelessWidget {
  const AllieCard({super.key, required this.message, this.compact = false});

  final String message;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final size = compact ? 36.0 : 44.0;

    return Semantics(
      label: '${l10n.allieLabel}. $message',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.divider),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9F5B).withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.emoji_people,
                  color: const Color(0xFFFF9F5B),
                  size: size * 0.55,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.allieLabel,
                      style: const TextStyle(
                        color: Color(0xFFFF9F5B),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: TextStyle(
                        color: colors.primaryText,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
