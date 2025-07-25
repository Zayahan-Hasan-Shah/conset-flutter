import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:intl/intl.dart';

class PDFVIEWERController {
  // pfr004001Form - 01
  Future<void> pfr004001Form({
    required String formPath,
    required String husbandName,
    required String husbandAge,
    required String husbandCnic,
    required Uint8List husbandSignature,
    required String wifeName,
    required Uint8List wifeSignature,
  }) async {
    try {
      final ByteData data = await rootBundle.load(formPath);
      List<int> bytes = data.buffer.asUint8List();

      debugPrint('1. $husbandName');
      debugPrint('2. $husbandAge');
      debugPrint('3. $husbandCnic');
      debugPrint('4. $husbandSignature');

      // load pdf
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final PdfTextExtractor extractor = PdfTextExtractor(document);

      String extractedText = extractor.extractText(
        startPageIndex: 1,
        endPageIndex: document.pages.count - 1,
      );
      debugPrint("🔍 Extracted Text from Page : \n$extractedText");
      debugPrint('Husband Signature Length: ${husbandSignature.length}');
      // Find match target
      List<MatchedItem> matches = extractor.findText([
        "Husband's.",
        "Wife's",
        "I________________",
        "nationality_______________",
        "_________years old,",
        "Number_______________",
        "type",
        "Date",
      ]);

      for (MatchedItem word in matches) {
        debugPrint('These are words : ${word.text}');
      }

      if (matches.isEmpty) {
        debugPrint('❌ No matching text found in the PDF Document!');
        document.dispose();
        return;
      }

      for (MatchedItem match in matches) {
        debugPrint(
          "🔍 Found text: '${match.text}' at Page: ${match.pageIndex}",
        );

        final PdfPage page = document.pages[match.pageIndex];
        final Rect bounds = match.bounds;

        // Replace text
        if (match.text == "Husband's.") {
          debugPrint(
            "📍 Drawing husband's signature at ${bounds.top}, ${bounds.left}",
          );
          page.graphics.drawImage(
            PdfBitmap(husbandSignature),
            Rect.fromLTWH(bounds.left + 20, bounds.top, 100, 50),
          );
        }

        if (match.text == "Wife's") {
          page.graphics.drawImage(
            PdfBitmap(wifeSignature),
            Rect.fromLTWH(bounds.left, bounds.top - 20, 100, 50),
          );
        }

        if (match.text == "I________________") {
          page.graphics.drawString(
            husbandName,
            PdfStandardFont(PdfFontFamily.helvetica, 12),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)),
            bounds: Rect.fromLTWH(bounds.left + 8, bounds.top - 10, 200, 20),
          );
        }
        if (match.text == " _________years old,") {
          page.graphics.drawString(
            husbandAge,
            PdfStandardFont(PdfFontFamily.helvetica, 12),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)),
            bounds: Rect.fromLTWH(bounds.left - 50, bounds.top, 40, 20),
          );
        }

        if (match.text == 'nationality_______________') {
          page.graphics.drawString(
            'Pakistan',
            PdfStandardFont(PdfFontFamily.helvetica, 12),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)),
            bounds: Rect.fromLTWH(bounds.left - 30, bounds.top - 20, 40, 20),
          );
        }

        if (match.text == "Number_______________") {
          page.graphics.drawString(
            husbandCnic,
            PdfStandardFont(PdfFontFamily.helvetica, 12),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)),
            bounds: Rect.fromLTWH(bounds.left + 70, bounds.top - 8, 150, 20),
          );
        }
        if (match.text == "type") {
          page.graphics.drawString(
            'Type',
            PdfStandardFont(PdfFontFamily.helvetica, 12),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)),
            // bounds: Rect.fromLTWH(bounds.left + 100, bounds.top, 150, 20),
            bounds: Rect.fromLTWH(bounds.left + 100, bounds.top, 150, 20),
          );
        }
        if (match.text == 'Date') {
          final font = PdfStandardFont(PdfFontFamily.helvetica, 12);
          final brush = PdfSolidBrush(PdfColor(0, 0, 0));
          final String currentDate = DateFormat(
            'dd/MM/yyyy',
          ).format(DateTime.now());

          page.graphics.drawString(
            currentDate,
            font,
            brush: brush,
            bounds: Rect.fromLTWH(
              match.bounds.left + 40,
              match.bounds.top,
              100,
              20,
            ),
          );
        }
      }

      final di1r = await getTemporaryDirectory();
      final testFile = File('${di1r.path}/husband_signature.png');
      await testFile.writeAsBytes(husbandSignature);
      OpenFile.open(testFile.path);

      Directory dir = await getApplicationDocumentsDirectory();
      String outputPath = '${dir.path}/pfr004001_signed_01.pdf';
      await File(outputPath).writeAsBytes(await document.save());

      // ✅ Open the modified PDF
      OpenFile.open(outputPath);
      document.dispose();

      print('✅ PDF modified and saved at: $outputPath');
    } catch (e) {
      print('❌ Error modifying PDF: $e');
    }
  }

  Future<void> pfr004003({
    required String formPath,
    required String witnessName,
    required String patientName,
    required String husbandName,
    required Uint8List patientSignature,
    required Uint8List HusbandSignature,
    required Uint8List witnessSignature,
  }) async {
    try {
      final ByteData data = await rootBundle.load(formPath);
      List<int> bytes = data.buffer.asUint8List();

      debugPrint("✔ PFR004003");
      debugPrint('1. $witnessName');
      debugPrint('2. $patientName');
      debugPrint('3. $husbandName');
      debugPrint('4. $patientSignature');

      // load pdf
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final PdfTextExtractor extractor = PdfTextExtractor(document);

      String extractedText = extractor.extractText(
        startPageIndex: 1,
        endPageIndex: document.pages.count - 1,
      );

      // Find match target
      List<MatchedItem> matches = extractor.findText([
        "permit_________________________________________",
        "Full Patient's Name", // will use for patient's signature also
        "Date",
        "Husband's Name", // will use for husband's signature
        "I_____________________________________________",
      ]);

      for (MatchedItem word in matches) {
        debugPrint('These are words : ${word.text}');
      }

      if (matches.isEmpty) {
        debugPrint('❌ No matching text found in the PDF Document!');
        document.dispose();
        return;
      }

      for (MatchedItem match in matches) {
        debugPrint(
          "🔍 Found text: '${match.text}' at Page: ${match.pageIndex}",
        );

        final PdfPage page = document.pages[match.pageIndex];
        final Rect bounds = match.bounds;

        


      }
    } catch (e) {}
  }
}
