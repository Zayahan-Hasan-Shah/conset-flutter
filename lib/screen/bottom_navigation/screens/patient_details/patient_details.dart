import 'package:conset/controllers/pdf_controller/patient_form_controller.dart';
import 'package:conset/core/color_assets/color_assets.dart';
import 'package:conset/models/patient_model.dart';
import 'package:conset/models/pdf_view_args_model.dart';
import 'package:conset/routes/routes_names.dart';
import 'package:conset/screen/bottom_navigation/screens/patient_details/widget/custom_patient_container.dart';
import 'package:conset/widgets/common_widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class PatientDetails extends ConsumerStatefulWidget {
  final Patient patient;

  const PatientDetails({super.key, required this.patient});

  @override
  ConsumerState<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends ConsumerState<PatientDetails> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(patientFormsProvider(widget.patient.mrNo).notifier)
          .loadForms(widget.patient.pdfUrls);
    });
  }

  @override
  Widget build(BuildContext context) {
    final forms = ref.watch(patientFormsProvider(widget.patient.mrNo));
    final formsNotifier = ref.read(
      patientFormsProvider(widget.patient.mrNo).notifier,
    );
    final signedForms =
        forms.where((form) => form['isSigned'] == true).toList();

    return Scaffold(
      appBar: AppBar(
        title: TitleText(title: widget.patient.firstName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(RoutesNames.dashboardScreen);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorAssets.whiteColor,
        onPressed: _showUnsignedFormsDialog,
        child: const Icon(Icons.file_copy, color: ColorAssets.primaryColor),
      ),
      body: Container(
        color: ColorAssets.primaryColor,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomPatientContainer(title: 'MRNO', item: widget.patient.mrNo),
            _buildDivider(),
            CustomPatientContainer(
              title: 'Full Name',
              item: widget.patient.fullName,
            ),
            _buildDivider(),
            CustomPatientContainer(
              title: 'First Name',
              item: widget.patient.firstName,
            ),
            _buildDivider(),
            CustomPatientContainer(
              title: 'Middle Name',
              item: widget.patient.middleName,
            ),
            _buildDivider(),
            CustomPatientContainer(
              title: 'Last Name',
              item: widget.patient.lastName,
            ),
            _buildDivider(),
            CustomPatientContainer(title: 'SEX', item: widget.patient.sex),
            _buildDivider(),
            CustomPatientContainer(
              title: 'Phone Number',
              item: widget.patient.phone,
            ),
            _buildDivider(),
            CustomPatientContainer(
              title: 'VIP Patient',
              item: widget.patient.isVIP ? 'YES' : 'NO',
            ),
            _buildDivider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(
                    title: 'FORMS',
                    color: ColorAssets.whiteColor,
                    weight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:
                  signedForms.isEmpty
                      ? Center(
                        child: TitleText(
                          title: 'No signed forms yet.',
                          color: ColorAssets.whiteColor,
                          weight: FontWeight.bold,
                        ),
                      )
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: signedForms.length,
                        itemBuilder: (context, index) {
                          final form = signedForms[index];
                          final formPath = form['pdf'];
                          final fileName =
                              formPath.split('/').last.toLowerCase();
                          return ListTile(
                            title: TitleText(
                              title: fileName,
                              color: ColorAssets.whiteColor,
                              isEllipse: true,
                            ),
                            trailing: const Icon(
                              Icons.picture_as_pdf_outlined,
                              color: Colors.red,
                            ),
                            onTap: () {
                              context.push(
                                RoutesNames.pdfSavedView,
                                extra: PdfViewerArgs(
                                  pdfUrl: formPath,
                                  patient: widget.patient,
                                ),
                              );
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: ColorAssets.blackColor.withOpacity(0.6));
  }

  void _showUnsignedFormsDialog() {
    final forms = ref.read(patientFormsProvider(widget.patient.mrNo));
    final formsNotifier = ref.read(
      patientFormsProvider(widget.patient.mrNo).notifier,
    );
    final unsignedForms =
        forms.where((form) => form['isSigned'] == false).toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(
                title: 'Unsigned Forms of Patient',
                color: ColorAssets.blackColor,
                fontSize: 18,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 12),
              if (unsignedForms.isEmpty)
                const Center(child: Text('All forms have been signed.')),
              if (unsignedForms.isNotEmpty)
                ...unsignedForms.map((form) {
                  final pdfUrl = form['pdf'];
                  final fileName = pdfUrl.split('/').last.toLowerCase();

                  return ListTile(
                    leading: const Icon(
                      Icons.picture_as_pdf,
                      color: ColorAssets.primaryColor,
                    ),
                    title: TitleText(
                      title: fileName,
                      color: ColorAssets.primaryColor,
                      isEllipse: true,
                    ),
                    subtitle: TitleText(
                      title: 'Unsigned',
                      color: ColorAssets.primaryColor.withOpacity(0.6),
                    ),
                    onTap: () async {
                      Navigator.pop(context);

                      final result = await context.push<String>(
                        RoutesNames.pdfViewer,
                        extra: PdfViewerArgs(
                          pdfUrl: pdfUrl,
                          patient: widget.patient,
                        ),
                      );

                      if (!mounted || result == null) return;

                      formsNotifier.markFormAsSigned(pdfUrl, result);
                    },
                  );
                }),
              // const Divider(),
              // ListTile(
              //   leading: const Icon(Icons.add),
              //   title: const Text('Add New Form'),
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }
}
