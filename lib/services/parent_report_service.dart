import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'session_history_service.dart';

class ParentReportService {
  const ParentReportService();

  Map<String, int> drillSuggestions(List<PracticeSessionResult> sessions) {
    final incorrectByTopic = <String, int>{};
    for (final session in sessions) {
      for (final question in session.questions) {
        if (question.selectedIndex == question.correctIndex) continue;
        final topic = question.topic.isEmpty ? 'Mixed Review' : question.topic;
        incorrectByTopic.update(topic, (count) => count + 1, ifAbsent: () => 1);
      }
    }
    return Map.fromEntries(
      incorrectByTopic.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)),
    );
  }

  Future<Uint8List> buildPdf(List<PracticeSessionResult> sessions) async {
    final suggestions = drillSuggestions(sessions);
    final document = pw.Document();
    final font = pw.Font.ttf(
      await rootBundle.load('assets/fonts/DMSans-Variable.ttf'),
    );
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: font),
        build: (_) => [
          pw.Header(level: 0, child: pw.Text('Sterling Math Parent Cheat Sheet')),
          pw.Text('Generated locally. No learner data was uploaded.'),
          pw.SizedBox(height: 12),
          pw.Header(level: 1, child: pw.Text('Suggested topic drills')),
          if (suggestions.isEmpty)
            pw.Text('Complete a practice session to generate suggestions.')
          else
            ...suggestions.entries.map(
              (entry) => pw.Bullet(
                text: '${entry.key}: ${entry.value} incorrect answer(s)',
              ),
            ),
          pw.Header(level: 1, child: pw.Text('Recent sessions')),
          ...sessions.map(
            (session) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${session.stage} - ${session.completedAt.toLocal()}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                ...session.questions.map(
                  (question) => pw.Bullet(
                    text:
                        '${question.topic.isEmpty ? 'Mixed Review' : question.topic}: '
                        '${question.selectedIndex == question.correctIndex ? 'Correct' : 'Review'}',
                  ),
                ),
                pw.SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
    return document.save();
  }

  Future<void> exportPdf(List<PracticeSessionResult> sessions) async {
    await Printing.sharePdf(
      bytes: await buildPdf(sessions),
      filename: 'mathtutor-parent-cheat-sheet.pdf',
    );
  }
}
