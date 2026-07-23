import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../core/config/publishing_config.dart';
import '../models/recall_card.dart';

/// Print/PDF/share pipeline for Recall Cards. Mirrors
/// [DiscoveryCardExportService]'s exact pw.Document/pw.MultiPage/
/// Printing.sharePdf pattern and branded-footer convention, generalised to a
/// list of cards (1 card for a single Recall Card's share action, up to 5 for
/// a Quick Review session's printable recall sheet) rather than introducing
/// a second PDF approach.
class RecallCardExportService {
  const RecallCardExportService();

  static String buildBrandedFooterLine(int pageNumber, int pageCount) {
    final website = PublishingConfig.websiteQrEnabled && PublishingConfig.websiteUrl != null
        ? '  —  ${PublishingConfig.websiteUrl}'
        : '';
    return '${PublishingConfig.publishingHierarchy}'
        '  —  Recall Cards'
        '  —  ${PublishingConfig.tagline}'
        '  —  © ${PublishingConfig.copyrightYear} ${PublishingConfig.copyrightHolder}'
        '  —  $pageNumber/$pageCount'
        '$website';
  }

  Future<pw.Font> _font() async {
    return pw.Font.ttf(await rootBundle.load('assets/fonts/DMSans-Variable.ttf'));
  }

  pw.Widget _header(String title, {String? learnerName}) {
    final subtitle =
        learnerName != null && learnerName.trim().isNotEmpty ? ' — ${learnerName.trim()}' : '';
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          PublishingConfig.publishingHierarchy,
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
        pw.SizedBox(height: 4),
        pw.Text('$title$subtitle',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.Divider(),
      ],
    );
  }

  /// The printable "recall sheet": prompts only, with space to write an
  /// answer, and no reveal/explanation content — for offline practice before
  /// checking the separate answer sheet.
  Future<Uint8List> buildRecallSheetPdf(
    List<RecallCard> cards, {
    required ui.Locale locale,
    String? learnerName,
  }) async {
    final document = pw.Document();
    final font = await _font();
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: font),
        footer: (context) => pw.Text(
          buildBrandedFooterLine(context.pageNumber, context.pagesCount),
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
        ),
        build: (context) => [
          _header('Recall Sheet', learnerName: learnerName),
          pw.SizedBox(height: 12),
          for (var i = 0; i < cards.length; i++) ...[
            pw.Text('${i + 1}. ${cards[i].textFor(locale).frontPrompt}',
                style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 28),
            pw.Divider(color: PdfColors.grey300),
          ],
        ],
      ),
    );
    return document.save();
  }

  /// The answer sheet companion: answer, explanation and common mistake for
  /// each card in the same order as the recall sheet.
  Future<Uint8List> buildAnswerSheetPdf(
    List<RecallCard> cards, {
    required ui.Locale locale,
    String? learnerName,
  }) async {
    final document = pw.Document();
    final font = await _font();
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: font),
        footer: (context) => pw.Text(
          buildBrandedFooterLine(context.pageNumber, context.pagesCount),
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
        ),
        build: (context) => [
          _header('Answer Sheet', learnerName: learnerName),
          pw.SizedBox(height: 12),
          for (var i = 0; i < cards.length; i++) ...[
            () {
              final text = cards[i].textFor(locale);
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('${i + 1}. ${text.frontPrompt}',
                      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text(text.answer, style: const pw.TextStyle(fontSize: 11)),
                  pw.SizedBox(height: 2),
                  pw.Text(text.explanation,
                      style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                  pw.SizedBox(height: 10),
                ],
              );
            }(),
          ],
        ],
      ),
    );
    return document.save();
  }

  Future<void> shareRecallSheet(
    List<RecallCard> cards, {
    required ui.Locale locale,
    String? learnerName,
  }) async {
    await Printing.sharePdf(
      bytes: await buildRecallSheetPdf(cards, locale: locale, learnerName: learnerName),
      filename: 'math-studio-recall-cards-sheet.pdf',
    );
  }

  Future<void> shareAnswerSheet(
    List<RecallCard> cards, {
    required ui.Locale locale,
    String? learnerName,
  }) async {
    await Printing.sharePdf(
      bytes: await buildAnswerSheetPdf(cards, locale: locale, learnerName: learnerName),
      filename: 'math-studio-recall-cards-answers.pdf',
    );
  }
}
