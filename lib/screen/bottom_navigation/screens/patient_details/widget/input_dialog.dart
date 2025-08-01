import 'dart:typed_data';
import 'package:conset/controllers/pdf_controller/input_dialog_controller.dart';
import 'package:conset/core/color_assets/color_assets.dart';
import 'package:conset/core/constant_assets/id_types.dart';
import 'package:conset/core/form_assets/form_assets.dart';
import 'package:conset/models/patient_model.dart';
import 'package:conset/utils/global.dart';
import 'package:conset/widgets/common_widgets/custom_text_form.dart';
import 'package:conset/widgets/common_widgets/fractinally_elevated_button.dart';
import 'package:conset/widgets/common_widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signature/signature.dart';
import 'package:sizer/sizer.dart';

class InputDialog extends ConsumerStatefulWidget {
  final String formId;
  final Patient? patient;

  const InputDialog({super.key, required this.formId, this.patient});

  @override
  ConsumerState<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends ConsumerState<InputDialog> {
  final _formKey = GlobalKey<FormState>();
  String? selectedIdType;
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
    attendeeName.dispose();
    husbandSignature.dispose();
    wifeSignature.dispose();
    patientSignature.dispose();
    witnessSignature.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(inputDialogProvider);
    final loadingNotifier = ref.read(inputDialogProvider.notifier);

    return AlertDialog(
      title: const Text('Fill Required Details'),
      content: SizedBox(
        width: 100.w,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(child: _buildFormFields()),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: FractionallyElevatedButton(
                onTap: () => Navigator.pop(context),
                widthFactor: 1.0,
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
                  if (!_formKey.currentState!.validate()) return;

                  loadingNotifier.setLoading(true);

                  final Uint8List? husbandSig =
                      await husbandSignature.toPngBytes();
                  final Uint8List? wifeSig = await wifeSignature.toPngBytes();
                  final Uint8List? patientSig =
                      await patientSignature.toPngBytes();
                  final Uint8List? witnessSig =
                      await witnessSignature.toPngBytes();

                  if (widget.formId == FormAssets.pfr004001) {
                    if (husbandSig == null || wifeSig == null) {
                      loadingNotifier.setLoading(false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please provide both signatures."),
                        ),
                      );
                      return;
                    }

                    Navigator.pop(context, {
                      'husbandName': husbandName.text.trim(),
                      'husbandAge': husbandAge.text.trim(),
                      'husbandCnic': husbandCnic.text.trim(),
                      'nationality': 'Pakistani',
                      'idType': selectedIdType,
                      'husbandIdType': selectedIdType,
                      'husbandSignature': husbandSig,
                      'wifeName': wifeName.text.trim(),
                      'wifeSignature': wifeSig,
                    });
                  } else if (widget.formId == FormAssets.pfr004003) {
                    if (husbandSig == null ||
                        witnessSig == null ||
                        patientSig == null ) {
                      loadingNotifier.setLoading(false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please provide all signatures."),
                        ),
                      );
                      return;
                    }

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

                  loadingNotifier.setLoading(false);
                },
                widthFactor: 1.0,
                child:
                    isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : TitleText(
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
        _validatedField(husbandName, 'Husband Name', validator: validator),
        _validatedField(
          husbandAge,
          'Husband Age',
          keyboardType: TextInputType.number,
          validator: numberValidator,
        ),
        _validatedField(
          husbandCnic,
          'Husband CNIC',
          keyboardType: TextInputType.number,
          validator: cnicValidator,
        ),
        // _validatedField(husbandIdType, 'ID Type'),
        Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: DropdownButtonFormField<String>(
            value: selectedIdType,
            decoration: InputDecoration(
              labelText: 'ID Type',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items:
                idTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
            onChanged: (value) => setState(() => selectedIdType = value),
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? 'Please select ID type'
                        : null,
          ),
        ),
        _validatedField(wifeName, 'Wife Name', validator: validator),
        _signatureBlock('Husband\'s Signature', husbandSignature),
        _signatureBlock('Wife\'s Signature', wifeSignature),
      ],
    );
  }

  Widget _pfr004003Build() {
    return Column(
      children: [
        TitleText(title: 'Patient: ${widget.patient?.fullName ?? ''}'),
        SizedBox(height: 2.h),
        _validatedField(husbandName, 'Husband Name', validator: validator),
        _validatedField(witnessName, 'Witness Name', validator: validator),
        _validatedField(attendeeName, 'Attendee Name', validator: validator),
        _signatureBlock('Husband Signature', husbandSignature),
        _signatureBlock('Witness Signature', witnessSignature),
        _signatureBlock('Patient Signature', patientSignature),
      ],
    );
  }

  Widget _validatedField(
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: CustomTextFormField(
        controller: controller,
        hint: hint,
        keyboardType: keyboardType,
        obscureText: false,
        validator: validator,
      ),
    );
  }

  Widget _signatureBlock(String label, SignatureController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: label),
        SizedBox(height: 1.h),
        Signature(
          controller: controller,
          height: 200,
          backgroundColor: Colors.grey[200]!,
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}
