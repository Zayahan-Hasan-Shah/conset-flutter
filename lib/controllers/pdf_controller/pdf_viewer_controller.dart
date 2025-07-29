import 'dart:developer';
import 'dart:io';

import 'package:conset/models/patient_model.dart';
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
    required void Function(String outputPath) onPdfSaved,
  }) async {
    try {
      final ByteData data = await rootBundle.load(formPath);
      List<int> bytes = data.buffer.asUint8List();

      log('1. $husbandName');
      log('2. $husbandAge');
      log('3. $husbandCnic');
      log('4. $husbandSignature');

      // load pdf
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final PdfTextExtractor extractor = PdfTextExtractor(document);

      String extractedText = extractor.extractText(
        startPageIndex: 1,
        endPageIndex: document.pages.count - 1,
      );
      log("🔍 Extracted Text from Page : \n$extractedText");
      log('Husband Signature Length: ${husbandSignature.length}');
      // Find match target
      List<MatchedItem> matches = extractor.findText([
        "Husband's.",
        "Wife's",
        "I________________",
        "nationality_______________",
        "years",
        "Number_______________",
        "type",
        "Date",
        "Name of Guardian/Substitue Conset Giver",
      ]);

      for (MatchedItem word in matches) {
        log('These are words : ${word.text}');
      }

      if (matches.isEmpty) {
        log('❌ No matching text found in the PDF Document!');
        document.dispose();
        return;
      }

      for (MatchedItem match in matches) {
        if (extractedText.toLowerCase().contains('year')) {
          log("🟡 Detected text containing 'year': possibly mislabeled.");
        }
        log("🔍 Found text: '${match.text}' at Page: ${match.pageIndex}");

        final PdfPage page = document.pages[match.pageIndex];
        final Rect bounds = match.bounds;

        // Replace text
        if (match.text == "Husband's.") {
          log(
            "📍 Drawing husband's signature at ${bounds.top}, ${bounds.left}",
          );
          page.graphics.drawImage(
            PdfBitmap(husbandSignature),
            Rect.fromLTWH(bounds.left + 40, bounds.top + 20, 100, 50),
          );
        }

        if (match.text == "Wife's") {
          page.graphics.drawImage(
            PdfBitmap(wifeSignature),
            Rect.fromLTWH(bounds.left + 70, bounds.top + 20, 100, 50),
          );
        }

        if (match.text == "I________________") {
          page.graphics.drawString(
            husbandName,
            PdfStandardFont(PdfFontFamily.helvetica, 10),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)),
            bounds: Rect.fromLTWH(bounds.left + 8, bounds.top - 8, 200, 20),
          );
        }
        if (match.text == "years") {
          page.graphics.drawString(
            husbandAge,
            PdfStandardFont(PdfFontFamily.helvetica, 10),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)),
            bounds: Rect.fromLTWH(bounds.left -20, bounds.top - 8, 40, 20),
          );
        }

        if (match.text == 'nationality_______________') {
          page.graphics.drawString(
            'Pakistan',
            PdfStandardFont(PdfFontFamily.helvetica, 10),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)),
            bounds: Rect.fromLTWH(bounds.left + 40, bounds.top - 20, 40, 20),
          );
        }

        if (match.text == "Number_______________") {
          page.graphics.drawString(
            husbandCnic,
            PdfStandardFont(PdfFontFamily.helvetica, 10),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)),
            bounds: Rect.fromLTWH(bounds.left + 30, bounds.top + 15, 150, 20),
          );
        }
        if (match.text == "type") {
          page.graphics.drawString(
            'Type',
            PdfStandardFont(PdfFontFamily.helvetica, 10),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)),
            // bounds: Rect.fromLTWH(bounds.left + 100, bounds.top, 150, 20),
            bounds: Rect.fromLTWH(bounds.left + 20, bounds.top - 6, 150, 20),
          );
        }
        if (match.text == 'Date') {
          final font = PdfStandardFont(PdfFontFamily.helvetica, 10);
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

        if (match.text == 'Name of Guardian/Substitue Conset Giver') {
          log(
            "📍 Drawing husband's signature at Guardian ${bounds.top}, ${bounds.left}",
          );
          page.graphics.drawImage(
            PdfBitmap(husbandSignature),
            Rect.fromLTWH(bounds.left + 80, bounds.top + 90, 100, 50),
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
      // OpenFile.open(outputPath);
      document.dispose();

      log('✅ PDF modified and saved at: $outputPath');

      onPdfSaved(outputPath);
    } catch (e) {
      log('❌ Error modifying PDF: $e');
    }
  }

  Future<void> pfr004003Form({
    required String formPath,
    required String witnessName,
    required String patientName,
    required String husbandName,
    required String attendeeName,
    required Uint8List patientSignature,
    required Uint8List husbandSignature,
    required Uint8List witnessSignature,
    Patient? patient,
    required void Function(String outputPath) onPdfSaved,
  }) async {
    try {
      final ByteData data = await rootBundle.load(formPath);
      List<int> bytes = data.buffer.asUint8List();

      log("✔ PFR004003 Form Filling Started");
      log('📌 Witness Name: $witnessName');
      log('📌 Patient Name: $patientName');
      log('📌 Husband Name: $husbandName');
      log('📌 Attendee Name: $attendeeName');

      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final PdfTextExtractor extractor = PdfTextExtractor(document);

      List<MatchedItem> matches = extractor.findText([
        "permit_________________________________________",
        "Full", "Patient's", "Name", // We will group these
        "Husband's", // use for husband's name and signature
        "Date",
        "Name", "of", "witness",
      ]);

      if (matches.isEmpty) {
        log('❌ No matches found!');
        document.dispose();
        return;
      }

      // Helper: Find first match of specific word
      MatchedItem? find(String text) =>
          matches.firstWhere((e) => e.text == text);

      for (MatchedItem match in matches) {
        final page = document.pages[match.pageIndex];
        // ✅ 1. Attendee Name
        final permitMatch = find(
          "permit_________________________________________",
        );
        if (permitMatch != null) {
          final bounds = permitMatch.bounds;
          page.graphics.drawString(
            attendeeName,
            PdfStandardFont(PdfFontFamily.helvetica, 12),
            bounds: Rect.fromLTWH(bounds.left + 20, bounds.top - 10, 200, 20),
          );
        }

        // ✅ 2. Patient Name & Signature (use "Full" as anchor)
        final patientAnchor = find("Full");
        if (patientAnchor != null) {
          final bounds = patientAnchor.bounds;
          page.graphics.drawString(
            patientName,
            PdfStandardFont(PdfFontFamily.helvetica, 12),
            bounds: Rect.fromLTWH(bounds.left + 80, bounds.top, 200, 20),
          );
          page.graphics.drawImage(
            PdfBitmap(patientSignature),
            Rect.fromLTWH(bounds.left + 80, bounds.top + 10, 100, 50),
          );
        }

        // ✅ 3. Witness Name & Signature
        final witnessMatch = find("witness");
        if (witnessMatch != null) {
          final page = document.pages[witnessMatch.pageIndex!];
          final bounds = witnessMatch.bounds!;
          page.graphics.drawString(
            witnessName,
            PdfStandardFont(PdfFontFamily.helvetica, 12),
            bounds: Rect.fromLTWH(bounds.left + 250, bounds.top - 30, 200, 20),
          );
          page.graphics.drawImage(
            PdfBitmap(witnessSignature),
            Rect.fromLTWH(bounds.left + 300, bounds.top - 30, 120, 50),
          );

          // Date for witness
          final String witnessDate = DateFormat(
            'dd/MM/yyyy',
          ).format(DateTime.now());
          page.graphics.drawString(
            witnessDate,
            PdfStandardFont(PdfFontFamily.helvetica, 12),
            bounds: Rect.fromLTWH(bounds.left + 200, bounds.top, 150, 20),
          );
        }

        // ✅ 4. Husband Name & Signature
        final husbandMatch = find("Husband's");
        if (husbandMatch != null) {
          final bounds = husbandMatch.bounds;
          page.graphics.drawString(
            husbandName,
            PdfStandardFont(PdfFontFamily.helvetica, 12),
            bounds: Rect.fromLTWH(bounds.left + 80, bounds.top, 200, 20),
          );
          page.graphics.drawImage(
            PdfBitmap(husbandSignature),
            Rect.fromLTWH(bounds.left + 80, bounds.top + 10, 100, 50),
          );
          final String husbandDate = DateFormat(
            'dd/MM/yyyy',
          ).format(DateTime.now());
          page.graphics.drawString(
            husbandDate,
            PdfStandardFont(PdfFontFamily.helvetica, 12),
            bounds: Rect.fromLTWH(bounds.left + 80, bounds.top + 20, 150, 20),
          );
        }

        // ✅ 5. Date
        final dateMatch = find("Date");
        if (dateMatch != null) {
          final bounds = dateMatch.bounds;
          final String currentDate = DateFormat(
            'dd/MM/yyyy',
          ).format(DateTime.now());
          page.graphics.drawString(
            currentDate,
            PdfStandardFont(PdfFontFamily.helvetica, 12),
            bounds: Rect.fromLTWH(bounds.left + 40, bounds.top, 150, 20),
          );
        }
      }

      // ✅ Save PDF
      Directory dir = await getApplicationDocumentsDirectory();
      String outputPath = '${dir.path}/pfr004003_signed_01.pdf';
      await File(outputPath).writeAsBytes(await document.save());

      // OpenFile.open(outputPath);
      document.dispose();

      log('✅ PDF modified and saved at: $outputPath');

      onPdfSaved(outputPath);
    } catch (e, st) {
      log('❌ Error modifying PDF: $e');
      log('$st');
    }
  }
}
