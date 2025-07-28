import 'dart:developer';
import 'dart:typed_data';
import 'package:conset/controllers/pdf_controller/pdf_viewer_controller.dart';
import 'package:conset/core/form_assets/form_assets.dart';
import 'package:conset/models/patient_model.dart';
import 'package:conset/models/pdf_view_args_model.dart';
import 'package:conset/routes/routes_names.dart';
import 'package:conset/screen/bottom_navigation/screens/patient_details/widget/input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends ConsumerStatefulWidget {
  final String pdfAssetPath;
  final Patient? patient;

  const PDFViewerScreen({Key? key, required this.pdfAssetPath, this.patient})
    : super(key: key);

  @override
  ConsumerState<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends ConsumerState<PDFViewerScreen> {
  final pdfController = PDFVIEWERController();

  @override
  Widget build(BuildContext context) {
    log('✅ PDFViewerScreen received patient: ${widget.patient?.fullName}');
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

  Future<void> _openSignatureDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (_) =>
              InputDialog(formId: widget.pdfAssetPath, patient: widget.patient),
    );

    if (result == null) return;

    final snack = ScaffoldMessenger.of(context);

    if (widget.pdfAssetPath == FormAssets.pfr004001) {
      final husbandName = result['husbandName'] as String?;
      final husbandAge = result['husbandAge'] as String?;
      final husbandCnic = result['husbandCnic'] as String?;
      final wifeName = result['wifeName'] as String?;
      final Uint8List? husbandSig = result['husbandSignature'];
      final Uint8List? wifeSig = result['wifeSignature'];

      if ([
            husbandName,
            husbandAge,
            husbandCnic,
            wifeName,
          ].any((e) => e == null || e.isEmpty) ||
          husbandSig == null ||
          wifeSig == null) {
        snack.showSnackBar(
          const SnackBar(content: Text("⚠️ Missing required fields.")),
        );
        return;
      }

      await pdfController.pfr004001Form(
        formPath: widget.pdfAssetPath,
        husbandName: husbandName!,
        husbandAge: husbandAge!,
        husbandCnic: husbandCnic!,
        husbandSignature: husbandSig,
        wifeName: wifeName!,
        wifeSignature: wifeSig,
        onPdfSaved: (outputPath) {
          if (!mounted) return;
          context.push(
            RoutesNames.pdfSavedView,
            extra: PdfViewerArgs(pdfUrl: outputPath),
          );
        },
      );

      snack.showSnackBar(
        const SnackBar(content: Text("✅ Form pfr004001 signed successfully.")),
      );
    } else if (widget.pdfAssetPath == FormAssets.pfr004003) {
      final witnessName = result['witnessName'] as String?;
      final patientName = result['patientName'] as String?;
      final husbandName = result['husbandName'] as String?;
      final attendeeName = result['attendeeName'] as String?;
      final Uint8List? patientSig = result['patientSignature'];
      final Uint8List? husbandSig = result['husbandSignature'];
      final Uint8List? witnessSig = result['witnessSignature'];

      if ([
            witnessName,
            patientName,
            husbandName,
            attendeeName,
          ].any((e) => e == null || e.isEmpty) ||
          patientSig == null ||
          husbandSig == null ||
          witnessSig == null) {
        snack.showSnackBar(
          const SnackBar(content: Text("⚠️ Missing required fields.")),
        );
        return;
      }

      await pdfController.pfr004003Form(
        formPath: widget.pdfAssetPath,
        witnessName: witnessName!,
        patientName: patientName!,
        husbandName: husbandName!,
        patientSignature: patientSig,
        husbandSignature: husbandSig,
        witnessSignature: witnessSig,
        attendeeName: attendeeName!,
        onPdfSaved: (outputPath) {
          if (!mounted) return;
          context.push(
            RoutesNames.pdfSavedView,
            extra: PdfViewerArgs(pdfUrl: outputPath, patient: widget.patient),
          );
        },
      );

      snack.showSnackBar(
        const SnackBar(content: Text("✅ Form pfr004003 signed successfully.")),
      );
    }
  }
}
