import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../core/config/publishing_config.dart';
import '../models/discovery_card.dart';

/// Print/PDF/share pipeline for a single Discovery Card. Mirrors
/// [ParentReportService]'s exact pw.Document/pw.MultiPage/Printing.sharePdf
/// pattern rather than introducing a new PDF approach; deliberately not
/// merged with that service, to avoid an unrelated refactor of working code.
class DiscoveryCardExportService {
  const DiscoveryCardExportService();

  /// Branded footer text: hierarchy, card id + version, tagline, copyright,
  /// page number, and (only if enabled) the configured website line. Kept as
  /// a pure string builder — separate from PDF rendering — so branding
  /// content can be asserted directly in tests without parsing PDF bytes.
  static String buildBrandedFooterLine(
    DiscoveryCard card,
    int pageNumber,
    int pageCount,
  ) {
    final website = PublishingConfig.websiteQrEnabled && PublishingConfig.websiteUrl != null
        ? '  —  ${PublishingConfig.websiteUrl}'
        : '';
    return '${PublishingConfig.publishingHierarchy}'
        '  —  ${card.id} v${card.contentVersion}'
        '  —  ${PublishingConfig.tagline}'
        '  —  © ${PublishingConfig.copyrightYear} ${PublishingConfig.copyrightHolder}'
        '  —  $pageNumber/$pageCount'
        '$website';
  }

  static String _defaultTitle() => 'Math Studio Discovery Card';

  Future<pw.Font> _font() async {
    return pw.Font.ttf(await rootBundle.load('assets/fonts/DMSans-Variable.ttf'));
  }

  pw.Widget _header(
    DiscoveryCard card,
    DiscoveryCardLocaleText text, {
    String? learnerName,
  }) {
    final title = learnerName != null && learnerName.trim().isNotEmpty
        ? '$_defaultHeaderPrefix — ${learnerName.trim()}'
        : _defaultTitle();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          PublishingConfig.publishingHierarchy,
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
        pw.SizedBox(height: 4),
        pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 2),
        pw.Text(text.title, style: const pw.TextStyle(fontSize: 14)),
        pw.Divider(),
      ],
    );
  }

  static const _defaultHeaderPrefix = 'Math Studio Discovery Card';

  Future<Uint8List> buildChallengeSheetPdf(
    DiscoveryCard card,
    DiscoveryCardLocaleText text, {
    String? learnerName,
  }) async {
    final document = pw.Document();
    final font = await _font();
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: font),
        footer: (context) => pw.Text(
          buildBrandedFooterLine(card, context.pageNumber, context.pagesCount),
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
        ),
        build: (context) => [
          _header(card, text, learnerName: learnerName),
          pw.SizedBox(height: 12),
          pw.Text(text.scenario),
          pw.SizedBox(height: 10),
          pw.Text(text.challengeQuestion, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 16),
          pw.Container(
            height: 260,
            width: double.infinity,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
    return document.save();
  }

  Future<Uint8List> buildWorkedSolutionPdf(
    DiscoveryCard card,
    DiscoveryCardLocaleText text, {
    String? learnerName,
  }) async {
    final document = pw.Document();
    final font = await _font();
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: font),
        footer: (context) => pw.Text(
          buildBrandedFooterLine(card, context.pageNumber, context.pagesCount),
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
        ),
        build: (context) => [
          _header(card, text, learnerName: learnerName),
          pw.SizedBox(height: 12),
          pw.Text(text.challengeQuestion, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Header(level: 1, text: 'Worked solution'),
          ...text.workedSteps.map((step) => pw.Bullet(text: step)),
          pw.SizedBox(height: 10),
          pw.Header(level: 1, text: 'Explanation'),
          pw.Text(text.explanation),
          pw.SizedBox(height: 10),
          pw.Header(level: 1, text: "Where you'll use this"),
          pw.Text(text.whereYoullUseThis),
          pw.SizedBox(height: 10),
          pw.Header(level: 1, text: 'Try one yourself'),
          pw.Text(text.followUpQuestion),
          pw.SizedBox(height: 4),
          pw.Text('Answer: ${text.followUpAnswerText}'),
        ],
      ),
    );
    return document.save();
  }

  Future<Uint8List> buildCombinedPdf(
    DiscoveryCard card,
    DiscoveryCardLocaleText text, {
    String? learnerName,
  }) async {
    final challenge = pw.Document();
    final font = await _font();
    final theme = pw.ThemeData.withFont(base: font, bold: font);

    challenge.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        footer: (context) => pw.Text(
          buildBrandedFooterLine(card, context.pageNumber, context.pagesCount),
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
        ),
        build: (context) => [
          _header(card, text, learnerName: learnerName),
          pw.SizedBox(height: 12),
          pw.Text(text.scenario),
          pw.SizedBox(height: 10),
          pw.Text(text.challengeQuestion, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 16),
          pw.Container(
            height: 260,
            width: double.infinity,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
    challenge.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        footer: (context) => pw.Text(
          buildBrandedFooterLine(card, context.pageNumber, context.pagesCount),
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
        ),
        build: (context) => [
          pw.Header(level: 0, text: 'Worked solution'),
          ...text.workedSteps.map((step) => pw.Bullet(text: step)),
          pw.SizedBox(height: 10),
          pw.Header(level: 1, text: 'Explanation'),
          pw.Text(text.explanation),
          pw.SizedBox(height: 10),
          pw.Header(level: 1, text: "Where you'll use this"),
          pw.Text(text.whereYoullUseThis),
          pw.SizedBox(height: 10),
          pw.Header(level: 1, text: 'Try one yourself'),
          pw.Text(text.followUpQuestion),
          pw.SizedBox(height: 4),
          pw.Text('Answer: ${text.followUpAnswerText}'),
        ],
      ),
    );
    return challenge.save();
  }

  Future<void> shareChallengeSheet(
    DiscoveryCard card,
    DiscoveryCardLocaleText text, {
    String? learnerName,
  }) async {
    await Printing.sharePdf(
      bytes: await buildChallengeSheetPdf(card, text, learnerName: learnerName),
      filename: 'math-studio-${card.id}-challenge.pdf',
    );
  }

  Future<void> shareWorkedSolution(
    DiscoveryCard card,
    DiscoveryCardLocaleText text, {
    String? learnerName,
  }) async {
    await Printing.sharePdf(
      bytes: await buildWorkedSolutionPdf(card, text, learnerName: learnerName),
      filename: 'math-studio-${card.id}-solution.pdf',
    );
  }

  Future<void> shareCombined(
    DiscoveryCard card,
    DiscoveryCardLocaleText text, {
    String? learnerName,
  }) async {
    await Printing.sharePdf(
      bytes: await buildCombinedPdf(card, text, learnerName: learnerName),
      filename: 'math-studio-${card.id}-combined.pdf',
    );
  }
}
