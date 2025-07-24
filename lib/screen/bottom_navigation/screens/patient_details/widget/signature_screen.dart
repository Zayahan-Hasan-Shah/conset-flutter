import 'package:conset/core/color_assets/color_assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signature/signature.dart';
import 'package:sizer/sizer.dart';

class SignatureCaptureScreen extends StatefulWidget {
  final String title;

  const SignatureCaptureScreen({super.key, required this.title});

  @override
  State<SignatureCaptureScreen> createState() => _SignatureCaptureScreenState();
}

class _SignatureCaptureScreenState extends State<SignatureCaptureScreen> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: ColorAssets.primaryColor,
  );

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
    title: Text(widget.title),
    content: SizedBox(
      width: 80.w,
      height: 30.h,
      child: Signature(
        controller: _controller,
        backgroundColor: Colors.grey[200]!,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          _controller.clear();
          Navigator.of(context).pop();
        },
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () => _controller.clear(),
        child: const Text('Clear'),
      ),
      TextButton(
        onPressed: () async {
          if (_controller.isNotEmpty) {
            final signature = await _controller.toPngBytes();
            if (signature != null) {
              Navigator.of(context).pop(signature);
            }
          }
        },
        child: const Text('Save'),
      ),
    ],
  );
  }
}
