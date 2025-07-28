import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:conset/models/patient_model.dart';

class PDFPreviewScreen extends StatelessWidget {
  final String filePath;
  final Patient? patient;

  const PDFPreviewScreen({
    Key? key,
    required this.filePath,
    this.patient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('🧾 Opening saved PDF at: $filePath');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signed PDF Preview'),
      ),
      body: SfPdfViewer.file(File(filePath)),
    );
  }
}
