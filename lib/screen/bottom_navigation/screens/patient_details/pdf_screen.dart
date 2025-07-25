import 'dart:typed_data';
import 'package:conset/controllers/pdf_controller/pdf_viewer_controller.dart';
import 'package:conset/screen/bottom_navigation/screens/patient_details/widget/input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signature/signature.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends ConsumerStatefulWidget {
  final String pdfAssetPath;

  const PDFViewerScreen({Key? key, required this.pdfAssetPath}) : super(key: key);

  @override
  ConsumerState<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends ConsumerState<PDFViewerScreen> {
  final pdfController = PDFVIEWERController(); // ✅ Matches your controller name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Sign PDF',
            onPressed: () => _showSignatureDialog(context),
          ),
        ],
      ),
      body: SfPdfViewer.asset(widget.pdfAssetPath),
    );
  }

  Future<void> _showSignatureDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const InputDialog(),
    );

    if (result != null) {
      final husbandSignatureController = result['husbandSignature'] as SignatureController?;
      final wifeSignatureController = result['wifeSignature'] as SignatureController?;

      final Uint8List? husbandBytes = await husbandSignatureController?.toPngBytes();
      final Uint8List? wifeBytes = await wifeSignatureController?.toPngBytes();

      if (result['husbandName'] != null &&
          result['wifeName'] != null &&
          result['husbandAge'] != null &&
          result['husbandCnic'] != null &&
          husbandBytes != null &&
          wifeBytes != null) {

        await pdfController.pfr004001Form(
          formPath: widget.pdfAssetPath,
          husbandName: result['husbandName'],
          husbandAge: result['husbandAge'],
          husbandCnic: result['husbandCnic'],
          husbandSignature: result['husbandSignature'],
          wifeName: result['wifeName'],
          wifeSignature: wifeBytes,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ PDF signed successfully.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Please fill all required fields.")),
        );
      }
    }
  }
}
