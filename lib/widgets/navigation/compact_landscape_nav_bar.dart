import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/theme/app_theme.dart';

/// D2.1 — the compact-landscape presentation of root navigation: an
/// icon-only bar, shorter than the portrait BottomNavigationBar, that
/// reclaims real height for content on a short phone-landscape viewport
/// (e.g. Pixel 6a, 412px tall) while keeping every destination reachable
/// and the collapse control genuinely discoverable — never gesture-only.
///
/// [onHide] is bound to a real, labelled, always-visible icon button; a
/// double-tap anywhere on the bar is an *additional* shortcut to the same
/// action, not the only way to trigger it.
class CompactLandscapeNavBar extends StatelessWidget {
  static const double height = 48;

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onHide;

  const CompactLandscapeNavBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.onHide,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;

    final destinations = <(IconData, String)>[
      (LucideIcons.home, l10n.navHome),
      (LucideIcons.bookOpen, l10n.navTopics),
      (LucideIcons.calculator, l10n.navPractice),
      (LucideIcons.flame, l10n.navJourney),
      (LucideIcons.moreHorizontal, l10n.navMore),
    ];

    // The double-tap shortcut lives only on the already-selected tab: it's
    // the one icon with no other useful single-tap purpose (tapping your
    // current tab is normally a no-op), so combining onTap + onDoubleTap on
    // that ONE GestureDetector lets Flutter's arena disambiguate correctly.
    // Splitting single-tap and double-tap across an ancestor/descendant
    // pair of *different* GestureDetector instances (tried first) doesn't
    // coordinate the same way — Flutter needs both callbacks on the same
    // recognizer to resolve single-vs-double without misfiring or lagging
    // the explicit Hide button, which must stay immediately reliable.
    return Container(
      height: height,
      color: colors.cardSurface,
      child: Row(
        children: [
          for (var i = 0; i < destinations.length; i++)
            Expanded(
              child: _CompactNavIcon(
                icon: destinations[i].$1,
                label: destinations[i].$2,
                selected: i == currentIndex,
                onTap: () => onDestinationSelected(i),
                onDoubleTap: i == currentIndex ? onHide : null,
              ),
            ),
          _HideNavigationButton(onTap: onHide, label: l10n.navHideAction),
        ],
      ),
    );
  }
}

class _CompactNavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Non-null only on the currently-selected destination — see the parent
  /// bar's build method for why double-tap is scoped to that one icon.
  final VoidCallback? onDoubleTap;

  const _CompactNavIcon({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          child: SizedBox(
            height: CompactLandscapeNavBar.height,
            child: Center(
              child: Icon(
                icon,
                size: 22,
                color: selected ? colors.accent : colors.secondaryText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The always-visible, labelled "Hide navigation" control — a real button,
/// never relying on the double-tap shortcut alone.
class _HideNavigationButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const _HideNavigationButton({required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        child: InkWell(
          key: const Key('compactLandscapeNavHideButton'),
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: CompactLandscapeNavBar.height,
            child: Center(
              child: Icon(
                Icons.keyboard_double_arrow_down,
                size: 18,
                color: colors.tertiaryText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The persistent, slim, bottom-edge "Show navigation" handle left behind
/// when the compact bar is collapsed. Restores the bar through this real
/// control — not a gesture the learner has to discover on their own.
class CompactLandscapeNavHandle extends StatelessWidget {
  static const double height = 28;

  final VoidCallback onShow;

  const CompactLandscapeNavHandle({super.key, required this.onShow});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Semantics(
      button: true,
      label: l10n.navShowAction,
      child: Tooltip(
        message: l10n.navShowAction,
        child: InkWell(
          key: const Key('compactLandscapeNavShowHandle'),
          onTap: onShow,
          child: Container(
            height: height,
            color: colors.cardSurface,
            alignment: Alignment.center,
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
