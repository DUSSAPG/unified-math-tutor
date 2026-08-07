import 'package:flutter/material.dart';

import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_theme.dart';
import 'lab_collapsible_controls.dart';

/// A collapsible panel with its own tap-to-toggle header, used for controls
/// that need a persistent, self-explanatory header rather than a separate
/// [LabControlHandle] — e.g. "Previous attempts" or mission instructions.
/// Built on [LabCollapsibleControls] for the actual show/hide behavior.
class LabBottomControlDrawer extends StatefulWidget {
  const LabBottomControlDrawer({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  final String title;
  final Widget child;
  final bool initiallyExpanded;

  @override
  State<LabBottomControlDrawer> createState() => _LabBottomControlDrawerState();
}

class _LabBottomControlDrawerState extends State<LabBottomControlDrawer> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            label: widget.title,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: colors.primaryText,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: colors.secondaryText,
                    ),
                  ],
                ),
              ),
            ),
          ),
          LabCollapsibleControls(
            collapsed: !_expanded,
            semanticLabel: widget.title,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
