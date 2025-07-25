// import 'dart:typed_data';
// import 'dart:io';
// import 'dart:ui';

// import 'package:flutter/services.dart' show rootBundle;
// import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:conset/core/form_assets/form_assets.dart';


// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final signaturePdfControllerProvider = Provider<SignaturePdfController>((ref) {
//   return SignaturePdfController();
// });

// class SignaturePdfController {
//   final Map<String, Map<String, Rect>> signaturePositions = {
//     FormAssets.pfr004001: {
//       'Patient': Rect.fromLTWH(100, 700, 150, 75),
//       'Guardian': Rect.fromLTWH(100, 300, 150, 75),
//       'Husband': Rect.fromLTWH(20, 800, 150, 75),
//       'Wife': Rect.fromLTWH(300, 750, 150, 75),
//     },
//     FormAssets.pfr004004: {
//       'Husband': Rect.fromLTWH(100, 500, 150, 75),
//       'Wife': Rect.fromLTWH(100, 600, 150, 75),
//     },
//   };

//   Future<String> addSignatureToPDF({
//     required String pdfAssetPath,
//     required Uint8List signatureBytes,
//     required String role,
//   }) async {
//     final originalPdf = await rootBundle.load(pdfAssetPath);
//     final document = PdfDocument(inputBytes: originalPdf.buffer.asUint8List());
//     final signatureImage = PdfBitmap(signatureBytes);

//     final rect = signaturePositions[pdfAssetPath]?[role];
//     if (rect == null) {
//       throw Exception('No signature position defined for $role in $rect');
//     }

//     final page = document.pages[0]; // Or dynamic logic if multi-page
//     page.graphics.drawImage(signatureImage, rect);

//     final bytes = await document.save();
//     document.dispose();

//     final dir = await getApplicationDocumentsDirectory();
//     final path = '${dir.path}/signed_${role}_${DateTime.now().millisecondsSinceEpoch}.pdf';
//     await File(path).writeAsBytes(bytes);

//     return path;
//   }
// }