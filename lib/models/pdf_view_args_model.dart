import 'package:conset/models/patient_model.dart';

class PdfViewerArgs {
  final String pdfUrl;
  final Patient? patient;

  PdfViewerArgs({required this.pdfUrl, this.patient});
}
