import 'dart:typed_data';
import 'package:conset/controllers/pdf_controller/pdf_viewer_controller.dart';
import 'package:conset/core/form_assets/form_assets.dart';
import 'package:conset/screen/bottom_navigation/screens/patient_details/widget/input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends ConsumerStatefulWidget {
  final String pdfAssetPath;

  const PDFViewerScreen({Key? key, required this.pdfAssetPath})
    : super(key: key);

  @override
  ConsumerState<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends ConsumerState<PDFViewerScreen> {
  final pdfController = PDFVIEWERController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Sign PDF',
            onPressed: () => _openSignatureDialog(context),
          ),
        ],
      ),
      body: SfPdfViewer.asset(widget.pdfAssetPath),
    );
  }

  /// ✅ Open InputDialog, get all data, then sign the PDF
  Future<void> _openSignatureDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const InputDialog(),
    );

    if (widget.pdfAssetPath == FormAssets.pfr004001){
      if (result != null) {
      final husbandName = result['husbandName'] as String?;
      final husbandAge = result['husbandAge'] as String?;
      final husbandCnic = result['husbandCnic'] as String?;
      final wifeName = result['wifeName'] as String?;

      final Uint8List husbandSigBytes = result['husbandSignature'];
      final Uint8List wifeSigBytes = result['wifeSignature'];

      if (husbandSigBytes.isEmpty || wifeSigBytes.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Missing signatures.")));
        return;
      }

      await pdfController.pfr004001Form(
        formPath: widget.pdfAssetPath,
        husbandName: husbandName ?? '',
        husbandAge: husbandAge ?? '',
        husbandCnic: husbandCnic ?? '',
        husbandSignature: husbandSigBytes,
        wifeName: wifeName ?? '',
        wifeSignature: wifeSigBytes,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ PDF signed successfully!")),
      );
    }
    }
  }
}
