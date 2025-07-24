// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// class PDFViewerScreen extends ConsumerWidget {
//   final String pdfAssetPath;
//   const PDFViewerScreen({Key? key, required this.pdfAssetPath})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('PDF Viewer')),
//       body: SfPdfViewer.asset(pdfAssetPath, pageSpacing: 10),
//     );
//   }
// }

import 'dart:typed_data';
import 'package:conset/controllers/pdf_controller/pdf_viewer_controller.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
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
  final pdfController = PDFViewerController();

  Uint8List? _husbandSignature;
  Uint8List? _wifeSignature;
  String? _husbandName;
  String? _wifeName;

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
    final SignatureController husbandSigCtrl = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
    );
    final SignatureController wifeSigCtrl = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
    );
    final husbandNameCtrl = TextEditingController();
    final wifeNameCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Enter Names & Signatures"),
            content: SizedBox(
              height: 500,
              width: 300,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text("Husband Name"),
                    TextField(controller: husbandNameCtrl),
                    const SizedBox(height: 8),
                    Signature(
                      controller: husbandSigCtrl,
                      height: 100,
                      backgroundColor: Colors.grey[200]!,
                    ),
                    const Text("Wife Name"),
                    TextField(controller: wifeNameCtrl),
                    const SizedBox(height: 8),
                    Signature(
                      controller: wifeSigCtrl,
                      height: 100,
                      backgroundColor: Colors.grey[200]!,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final husbandSignature = await husbandSigCtrl.toPngBytes();
                  final wifeSignature = await wifeSigCtrl.toPngBytes();

                  if (husbandNameCtrl.text.isEmpty ||
                      wifeNameCtrl.text.isEmpty ||
                      husbandSignature == null ||
                      wifeSignature == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please complete all fields"),
                      ),
                    );
                    return;
                  }

                  // Set data after validation
                  setState(() {
                    _husbandName = husbandNameCtrl.text.trim();
                    _wifeName = wifeNameCtrl.text.trim();
                    _husbandSignature = husbandSignature;
                    _wifeSignature = wifeSignature;
                  });

                  // Close the dialog
                  if (Navigator.canPop(context)) Navigator.pop(context);

                  // Proceed
                  await _signPdf();
                },

                child: const Text("Sign"),
              ),
            ],
          ),
    );
  }

  Future<void> _signPdf() async {
    if (_husbandSignature != null &&
        _wifeSignature != null &&
        _husbandName != null &&
        _wifeName != null) {
      await pdfController.processConsentForm(
        formPath: widget.pdfAssetPath,
        husbandName: _husbandName!,
        wifeName: _wifeName!,
        husbandSignatureImage: _husbandSignature!,
        wifeSignatureImage: _wifeSignature!,
      );
    }
  }
}
