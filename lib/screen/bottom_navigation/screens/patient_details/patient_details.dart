import 'package:conset/core/color_assets/color_assets.dart';
import 'package:conset/models/patient_model.dart';
import 'package:conset/routes/routes_names.dart';
import 'package:conset/widgets/common_widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class PatientDetails extends StatelessWidget {
  final Patient patient;

  const PatientDetails({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TitleText(title: patient.firstName ?? 'N/A')),
      body: Padding(
        padding: EdgeInsets.all(3.h),
        child: Column(
          children: [
            _buildInfoRow('MRNO', patient.mrNo ?? 'N/A'),
            _buildDivider(),
            _buildInfoRow('First Name', patient.firstName ?? 'N/A'),
            _buildDivider(),
            _buildInfoRow('Last Name', patient.lastName ?? 'N/A'),
            _buildDivider(),
            _buildInfoRow('Sex', patient.sex.isNotEmpty ? patient.sex : 'N/A'),
            _buildDivider(),
            _buildInfoRow(
              'Phone',
              patient.phone.isNotEmpty ? patient.phone : 'N/A',
            ),
            _buildDivider(),
            if (patient.isVIP == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('VIP Patient'),
                  Icon(Icons.star, color: Colors.yellow, size: 20),
                ],
              ),
            SizedBox(height: 2.h),
            Text(
              'Forms',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: patient.pdfUrls.length,
                itemBuilder: (context, index) {
                  final pdfUrl = patient.pdfUrls[index];
                  final fileName = pdfUrl.split('/').last.toLowerCase();

                  return ListTile(
                    title: Text('$fileName'),
                    trailing: Icon(Icons.picture_as_pdf, color: Colors.red),
                    onTap: () {
                      if (fileName == 'pfr004001.pdf') {
                        context.push(
                          RoutesNames.pdfViewer,
                          extra: {'pdfUrl': pdfUrl},
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Unsupported form: $fileName'),
                          ),
                        );
                      }
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        TitleText(
          title: value,
          fontSize: 20.sp,
          color: ColorAssets.primaryColor,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(color: ColorAssets.blackColor.withOpacity(0.6));
  }
}
