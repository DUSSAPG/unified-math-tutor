import 'package:flutter/material.dart';

import '../../app/safe_navigation.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';

/// Shared shell for the 4 Spatial Intelligence activities (Cube Nets,
/// Rotations, Transformations, Spatial Puzzles): consistent app bar, back
/// destination, an explanatory caption, and a scrollable content area for
/// each activity's own interactive widget. Deliberately carries no
/// "Preview"/"coming soon" badge, unlike `VisualMathsPlaceholderScaffold` —
/// these are real, finished activities, not bounded previews.
class SpatialActivityScaffold extends StatelessWidget {
  const SpatialActivityScaffold({
    super.key,
    required this.title,
    required this.caption,
    required this.child,
  });

  final String title;
  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () =>
              popOrGo(context, '/math-studio/spatial-intelligence'),
        ),
        title: Text(
          title,
          style:
              TextStyle(color: colors.primaryText, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: AppResponsive.contentMaxWidth(context)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    caption,
                    style: TextStyle(
                        color: colors.secondaryText, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
