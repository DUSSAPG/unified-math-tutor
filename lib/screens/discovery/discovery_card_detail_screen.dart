import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../models/discovery_card.dart';
import '../../services/captain_math_service.dart';
import '../../services/discovery_card_catalog_service.dart';
import '../../services/nav_visibility_service.dart';
import '../../shared/math_notation_formatter.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/captain_math_card.dart';
import '../../widgets/discovery/discovery_export_sheet.dart';
import '../../widgets/discovery/discovery_illustration.dart';
import 'discovery_category_labels.dart';

/// Think -> Reveal -> follow-up flow for a single Discovery Card. Hides the
/// shell chrome while active (matches the focused-flow pattern used by
/// active practice/exam-sim sessions) and restores it on exit.
class DiscoveryCardDetailScreen extends StatefulWidget {
  const DiscoveryCardDetailScreen({super.key, required this.cardId});

  final String cardId;

  @override
  State<DiscoveryCardDetailScreen> createState() => _DiscoveryCardDetailScreenState();
}

class _DiscoveryCardDetailScreenState extends State<DiscoveryCardDetailScreen> {
  late final Future<DiscoveryCard> _cardFuture;
  bool _revealed = false;
  bool _followUpAnswered = false;
  bool _followUpCorrect = false;
  final _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cardFuture = DiscoveryCardCatalogService.instance.byId(widget.cardId);
    NavVisibilityService.instance.hide();
  }

  @override
  void dispose() {
    NavVisibilityService.instance.show();
    _answerController.dispose();
    super.dispose();
  }

  void _reveal() {
    setState(() => _revealed = true);
    CaptainMathService.instance.showEncouragement();
  }

  void _checkFollowUp(DiscoveryCard card) {
    final parsed = num.tryParse(_answerController.text.trim().replaceAll(',', '.'));
    final correct = parsed != null && (parsed - card.followUp.answerValue).abs() < 0.01;
    setState(() {
      _followUpAnswered = true;
      _followUpCorrect = correct;
    });
    if (correct) CaptainMathService.instance.showCompletion();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1120),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => popOrGo(context, '/math-studio/discovery'),
        ),
        actions: [
          FutureBuilder<DiscoveryCard>(
            future: _cardFuture,
            builder: (context, snapshot) {
              final card = snapshot.data;
              if (card == null) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.ios_share, color: Colors.white),
                tooltip: l10n.mathStudioExportButton,
                onPressed: () => showDiscoveryExportSheet(context, card),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<DiscoveryCard>(
          future: _cardFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Icon(Icons.error_outline, color: Color(0xFF8A9DC0), size: 32),
              );
            }
            final card = snapshot.data;
            if (card == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final text = card.textFor(Localizations.localeOf(context));

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: AppResponsive.contentMaxWidth(context)),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          DiscoveryIllustration(
                            card: card,
                            semanticLabel: text.illustrationAlt,
                            size: 64,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  text.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  discoveryCategoryLabel(l10n, card.category),
                                  style: const TextStyle(
                                    color: Color(0xFF8A9DC0),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      CaptainMathCard(state: CaptainMathState.curious),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        MathNotationFormatter.format(text.scenario),
                        style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        MathNotationFormatter.format(text.challengeQuestion),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (!_revealed) ...[
                        Text(
                          text.thinkPrompt,
                          style: const TextStyle(
                            color: Color(0xFF8A9DC0),
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ElevatedButton(
                          onPressed: _reveal,
                          child: Text(l10n.mathStudioRevealButton),
                        ),
                      ] else ...[
                        _SectionHeading(text: l10n.mathStudioRevealedLabel),
                        const SizedBox(height: AppSpacing.sm),
                        for (final step in text.workedSteps)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              '• ${MathNotationFormatter.format(step)}',
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          MathNotationFormatter.format(text.explanation),
                          style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 13, height: 1.4),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _SectionHeading(text: l10n.mathStudioWhereYoullUseThisLabel),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          text.whereYoullUseThis,
                          style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 13, height: 1.4),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _SectionHeading(text: l10n.mathStudioFollowUpLabel),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          MathNotationFormatter.format(text.followUpQuestion),
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextField(
                          controller: _answerController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: l10n.mathStudioFollowUpAnswerLabel,
                            labelStyle: const TextStyle(color: Color(0xFF8A9DC0)),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF1F3055)),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ElevatedButton(
                          onPressed: () => _checkFollowUp(card),
                          child: Text(l10n.mathStudioFollowUpCheckButton),
                        ),
                        if (_followUpAnswered) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            _followUpCorrect
                                ? l10n.mathStudioFollowUpCorrect
                                : l10n.mathStudioFollowUpTryAgain,
                            style: TextStyle(
                              color: _followUpCorrect
                                  ? const Color(0xFF34C759)
                                  : const Color(0xFF8A9DC0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (_followUpCorrect) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              MathNotationFormatter.format(text.followUpAnswerText),
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ],
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String text;
  const _SectionHeading({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF5B8EFF),
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
    );
  }
}
