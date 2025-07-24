import 'dart:io';

import 'package:conset/controllers/patient_controller/editing_form_controller/drawing_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DrawingPdfEditor extends StatefulWidget {
  final String pdfAssetPath;
  const DrawingPdfEditor({super.key, required this.pdfAssetPath});

  @override
  State<DrawingPdfEditor> createState() => _DrawingPdfEditorState();
}

class _DrawingPdfEditorState extends State<DrawingPdfEditor> {
  final DrawingController _drawController = DrawingController();
  final GlobalKey _canvasKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draw on PDF'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDrawingToPdf,
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => _drawController.clear?.call(),
          ),
        ],
      ),
      body: Stack(
        children: [
          SfPdfViewer.asset(widget.pdfAssetPath),
          Positioned.fill(
            child: RepaintBoundary(
              key: _canvasKey,
              child: DrawingCanvas(controller: _drawController),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveDrawingToPdf() async {
    RenderBox box = _canvasKey.currentContext!.findRenderObject() as RenderBox;
    final image = await _drawController.exportToImage(box.size);

    final original = await rootBundle.load(widget.pdfAssetPath);
    final document = PdfDocument(inputBytes: original.buffer.asUint8List());
    final page = document.pages[0];
    page.graphics.drawImage(PdfBitmap(image), const Rect.fromLTWH(0, 0, 500, 700));

    final bytes = await document.save();
    document.dispose();

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/annotated_${DateTime.now().millisecondsSinceEpoch}.pdf';
    await File(path).writeAsBytes(bytes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to $path')),
    );
  }
}

class DrawingCanvas extends StatefulWidget {
  final DrawingController controller;
  const DrawingCanvas({super.key, required this.controller});

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<Offset?> points = [];

  @override
  void initState() {
    super.initState();
    widget.controller.getPoints = () => points;
    widget.controller.clear = () {
      setState(() => points.clear());
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset point = box.globalToLocal(details.globalPosition);
        setState(() => points.add(point));
      },
      onPanEnd: (_) => setState(() => points.add(null)),
      child: CustomPaint(
        painter: _DrawPainter(points),
        size: Size.infinite,
      ),
    );
  }
}

class _DrawPainter extends CustomPainter {
  final List<Offset?> points;
  _DrawPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DrawPainter oldDelegate) => true;
}


