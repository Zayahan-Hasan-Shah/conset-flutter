import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';

class PDFViewerController {
  Future<void> processConsentForm({
    required String formPath,
    required String husbandName,
    required String wifeName,
    required Uint8List husbandSignatureImage,
    required Uint8List wifeSignatureImage,
  }) async {
    try {
      final ByteData data = await rootBundle.load(formPath);
      final Uint8List bytes = data.buffer.asUint8List();
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final PdfTextExtractor extractor = PdfTextExtractor(document);

      final matches = extractor.findText([
        "I ________________________ of nationality_______________",
        "Husband's Signature",
        "Wife's Signature",
      ]);

      if (matches.isEmpty) {
        print('❌ No matching keywords found in PDF.');
        return;
      }

      for (int i = 0; i < document.pages.count; i++) {
        final text = extractor.extractText(startPageIndex: i, endPageIndex: i);
        print('📄 Page $i content:\n$text');
      }

      for (final match in matches) {
        final page = document.pages[match.pageIndex];
        final bounds = match.bounds;

        switch (match.text) {
          case "I ________________________ of nationality_______________":
            page.graphics.drawString(
              husbandName,
              PdfStandardFont(PdfFontFamily.helvetica, 12),
              brush: PdfSolidBrush(PdfColor(0, 0, 0)),
              bounds: Rect.fromLTWH(bounds.left + 10, bounds.top + 18, 300, 20),
            );
            break;

          case "Husband's Signature":
            page.graphics.drawImage(
              PdfBitmap(husbandSignatureImage),
              Rect.fromLTWH(bounds.left, bounds.bottom + 5, 150, 40),
            );
            break;

          case "Wife's Signature":
            page.graphics.drawImage(
              PdfBitmap(wifeSignatureImage),
              Rect.fromLTWH(bounds.left, bounds.bottom + 5, 150, 40),
            );
            break;
        }

        debugPrint(
          "🔍 Found: '${match.text}' on page ${match.pageIndex} at ${match.bounds}",
        );
      }

      _insertDate(document);

      final dir = await getApplicationDocumentsDirectory();
      final outputPath = '${dir.path}/signed_consent_form.pdf';
      await File(outputPath).writeAsBytes(await document.save());

      document.dispose();

      await OpenFile.open(outputPath);
    } catch (e) {
      print('❌ Error modifying PDF: $e');
    }
  }

  void _insertDate(PdfDocument document) {
    final font = PdfStandardFont(PdfFontFamily.helvetica, 12);
    final brush = PdfSolidBrush(PdfColor(0, 0, 0));
    final String dateStr = DateFormat('dd/MM/yyyy').format(DateTime.now());

    final page = document.pages[document.pages.count - 1];
    page.graphics.drawString(
      'Date: $dateStr',
      font,
      brush: brush,
      bounds: const Rect.fromLTWH(400, 1080, 150, 20),
    );
  }
}
