import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:conset/models/patient_model.dart';
import 'package:conset/routes/routes_names.dart'; 

class PDFPreviewScreen extends StatelessWidget {
  final String filePath;
  final Patient? patient;

  const PDFPreviewScreen({Key? key, required this.filePath, this.patient})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('🧾 Opening saved PDF at: $filePath');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signed Consent Form'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pushReplacement(RoutesNames.patientDetailScreen, extra: patient);
          },
        ),
      ),
      body: SfPdfViewer.file(File(filePath)),
    );
  }
}
