import 'dart:developer';
import 'dart:typed_data';
import 'package:conset/core/color_assets/color_assets.dart';
import 'package:conset/widgets/common_widgets/custom_text_form.dart';
import 'package:conset/widgets/common_widgets/fractinally_elevated_button.dart';
import 'package:conset/widgets/common_widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:sizer/sizer.dart';


class InputDialog extends StatefulWidget {
  const InputDialog({super.key});

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final husbandName = TextEditingController();
  final husbandAge = TextEditingController();
  final husbandCnic = TextEditingController();
  final husbandIdType = TextEditingController();
  final husbandSignature = SignatureController(
    penColor: ColorAssets.primaryColor,
    penStrokeWidth: 8,
    onDrawStart: () => log('Husband onDrawStart called!'),
    onDrawEnd: () => log('Husband onDrawEnd called!'),
  );
  final wifeName = TextEditingController();
  final wifeSignature = SignatureController(
    penColor: ColorAssets.primaryColor,
    penStrokeWidth: 8,
    onDrawStart: () => log('Wife onDrawStart called!'),
    onDrawEnd: () => log('Wife onDrawEnd called!'),
  );

  @override
  void dispose() {
    husbandName.dispose();
    husbandAge.dispose();
    husbandCnic.dispose();
    husbandIdType.dispose();
    wifeName.dispose();
    wifeSignature.dispose();
    super.dispose();
  }

  Future<void> saveToPDF(BuildContext context) async {
    if (husbandSignature.isEmpty || wifeSignature.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No signature to save')));
      return;
    }

    // await PdfViewerController().pfr004001Form(formPath: formPath, husbandName: husbandName, husbandAge: husbandAge, husbandCnic: husbandCnic, husbandSignature: husbandSignature, wifeName: wifeName, wifeSignature: wifeSignature)
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        FractionallyElevatedButton(
          onTap: () => Navigator.pop(context),
          child: TitleText(title: 'Cancel'),
        ),
        FractionallyElevatedButton(
          onTap: () async {
            saveToPDF(context);
            final Uint8List? husbandSig = await husbandSignature.toPngBytes();
            final Uint8List? wifeSig = await wifeSignature.toPngBytes();
            debugPrint("📦 Husband Signature Bytes: ${husbandSig?.length ?? 0}");
            debugPrint("📦 Wife Signature Bytes: ${wifeSig?.length ?? 0}");
            Navigator.pop(context, {
              'husbandName': husbandName.text.trim(),
              'husbandAge': husbandAge.text.trim(),
              'husbandCnic': husbandCnic.text.trim(),
              'nationality': 'Pakistani',
              'husbandIdType': husbandIdType.text.trim(),
              'husbandSignature': husbandSig,
              'wifeName': wifeName.text.trim(),
              'wifeSignature': wifeSig,
            });
          },
          child: TitleText(title: 'Submit'),
        ),
      ],
      content: SizedBox(
        width: 100.w,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextFormField(
                controller: husbandName,
                obscureText: false,
                hint: 'Husband Name',
              ),
              SizedBox(height: 2.h),
              CustomTextFormField(
                controller: husbandAge,
                obscureText: false,
                hint: 'Husband Age',
              ),
              SizedBox(height: 2.h),
              CustomTextFormField(
                controller: husbandCnic,
                obscureText: false,
                hint: 'Husband CNIC',
              ),
              SizedBox(height: 2.h),
              CustomTextFormField(
                controller: husbandIdType,
                obscureText: false,
                hint: 'ID Type',
              ),
              SizedBox(height: 2.h),
              CustomTextFormField(
                controller: wifeName,
                obscureText: false,
                hint: 'Wife Name',
              ),
              SizedBox(height: 2.h),
              Signature(
                controller: husbandSignature,
                height: 100,
                backgroundColor: Colors.grey[200]!,
              ),
              SizedBox(height: 2.h),
              Signature(
                controller: wifeSignature,
                height: 100,
                backgroundColor: Colors.grey[200]!,
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
