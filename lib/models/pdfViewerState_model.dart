import 'dart:io';
import 'dart:typed_data';

class PDFViewerState {
  final Map<String, Uint8List> signatures;
  final File? signedPdfFile;

  PDFViewerState({required this.signatures, this.signedPdfFile});

  // Initial factory constructor
  factory PDFViewerState.initial() => PDFViewerState(signatures: {}, signedPdfFile: null);

  PDFViewerState copyWith({
    Map<String, Uint8List>? signatures,
    File? signedPdfFile,
  }) {
    return PDFViewerState(
      signatures: signatures ?? this.signatures,
      signedPdfFile: signedPdfFile ?? this.signedPdfFile,
    );
  }
}