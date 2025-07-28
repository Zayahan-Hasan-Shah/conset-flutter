import 'dart:typed_data';
import 'package:conset/core/color_assets/color_assets.dart';
import 'package:conset/core/form_assets/form_assets.dart';
import 'package:conset/models/patient_model.dart';
import 'package:conset/widgets/common_widgets/custom_text_form.dart';
import 'package:conset/widgets/common_widgets/fractinally_elevated_button.dart';
import 'package:conset/widgets/common_widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:sizer/sizer.dart';

class InputDialog extends StatefulWidget {
  final String formId;
  final Patient? patient;

  const InputDialog({super.key, required this.formId, this.patient});

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final husbandName = TextEditingController();
  final husbandAge = TextEditingController();
  final husbandCnic = TextEditingController();
  final husbandIdType = TextEditingController();
  final wifeName = TextEditingController();
  final witnessName = TextEditingController();
  final attendeeName = TextEditingController();

  final husbandSignature = SignatureController(
    penColor: ColorAssets.primaryColor,
    penStrokeWidth: 8,
  );

  final wifeSignature = SignatureController(
    penColor: ColorAssets.primaryColor,
    penStrokeWidth: 8,
  );

  final patientSignature = SignatureController(
    penColor: ColorAssets.primaryColor,
    penStrokeWidth: 8,
  );

  final witnessSignature = SignatureController(
    penColor: ColorAssets.primaryColor,
    penStrokeWidth: 8,
  );

  @override
  void dispose() {
    husbandName.dispose();
    husbandAge.dispose();
    husbandCnic.dispose();
    husbandIdType.dispose();
    wifeName.dispose();
    witnessName.dispose();
    husbandSignature.dispose();
    wifeSignature.dispose();
    patientSignature.dispose();
    witnessSignature.dispose();
    attendeeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Fill Required Details'),
      content: SizedBox(
        width: 100.w,
        child: SingleChildScrollView(child: _buildFormFields()),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: FractionallyElevatedButton(
                onTap: () => Navigator.pop(context),
                widthFactor: 1.0, // full width inside Expanded
                child: TitleText(
                  title: 'Cancel',
                  color: ColorAssets.whiteColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FractionallyElevatedButton(
                onTap: () async {
                  final Uint8List? husbandSig =
                      await husbandSignature.toPngBytes();
                  final Uint8List? wifeSig = await wifeSignature.toPngBytes();
                  final Uint8List? patientSig =
                      await patientSignature.toPngBytes();
                  final Uint8List? witnessSig =
                      await witnessSignature.toPngBytes();

                  if (widget.formId == FormAssets.pfr004001) {
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
                  } else if (widget.formId == FormAssets.pfr004003) {
                    Navigator.pop(context, {
                      'husbandName': husbandName.text.trim(),
                      'witnessName': witnessName.text.trim(),
                      'patientName': widget.patient?.fullName ?? '',
                      'husbandSignature': husbandSig,
                      'witnessSignature': witnessSig,
                      'patientSignature': patientSig,
                      'attendeeName': attendeeName.text.trim(),
                    });
                  }
                },
                widthFactor: 1.0,

                child: TitleText(
                  title: 'Submit',
                  color: ColorAssets.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    if (widget.formId == FormAssets.pfr004001) return _pfr004001Build();
    if (widget.formId == FormAssets.pfr004003) return _pfr004003Build();
    return const Text('Unsupported form type');
  }

  Widget _pfr004001Build() {
    return Column(
      children: [
        CustomTextFormField(
          controller: husbandName,
          hint: 'Husband Name',
          obscureText: false,
        ),
        SizedBox(height: 2.h),
        CustomTextFormField(
          controller: husbandAge,
          hint: 'Husband Age',
          obscureText: false,
        ),
        SizedBox(height: 2.h),
        CustomTextFormField(
          controller: husbandCnic,
          hint: 'Husband CNIC',
          obscureText: false,
        ),
        SizedBox(height: 2.h),
        CustomTextFormField(
          controller: husbandIdType,
          hint: 'ID Type',
          obscureText: false,
        ),
        SizedBox(height: 2.h),
        CustomTextFormField(
          controller: wifeName,
          hint: 'Wife Name',
          obscureText: false,
        ),
        SizedBox(height: 2.h),
        TitleText(title: 'Husband\'s Signature'),
        SizedBox(height: 2.h),
        Signature(
          controller: husbandSignature,
          height: 200,
          width: double.infinity,
          backgroundColor: Colors.grey[200]!,
        ),
        SizedBox(height: 2.h),
        TitleText(title: 'Wife\'s Signature'),
        SizedBox(height: 2.h),
        Signature(
          controller: wifeSignature,
          height: 200,
          width: double.infinity,
          backgroundColor: Colors.grey[200]!,
        ),
      ],
    );
  }

  Widget _pfr004003Build() {
    return Column(
      children: [
        TitleText(title: 'Patient: ${widget.patient?.fullName ?? ''}'),
        SizedBox(height: 2.h),
        CustomTextFormField(
          controller: husbandName,
          hint: 'Husband Name',
          obscureText: false,
        ),
        SizedBox(height: 2.h),
        CustomTextFormField(
          controller: witnessName,
          hint: 'Witness Name',
          obscureText: false,
        ),
        SizedBox(height: 2.h),
        CustomTextFormField(
          controller: attendeeName,
          hint: 'Attendee Name',
          obscureText: false,
        ),
        SizedBox(height: 2.h),
        TitleText(title: 'Husband Signature'),
        SizedBox(height: 2.h),
        Signature(
          controller: husbandSignature,
          height: 100,
          backgroundColor: Colors.grey[200]!,
        ),
        SizedBox(height: 2.h),
        TitleText(title: 'Witness Signature'),
        SizedBox(height: 2.h),
        Signature(
          controller: witnessSignature,
          height: 100,
          backgroundColor: Colors.grey[200]!,
        ),
        SizedBox(height: 2.h),
        TitleText(title: 'Patient Signature'),
        SizedBox(height: 2.h),
        Signature(
          controller: patientSignature,
          height: 100,
          backgroundColor: Colors.grey[200]!,
        ),
      ],
    );
  }
}
