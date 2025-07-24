import 'package:conset/controllers/api_loader_controller/api_loader_controller.dart';
import 'package:conset/controllers/bottom_navigation_controller/bottom_navigation_controller.dart';
import 'package:conset/core/app_assets/app_assets.dart';
import 'package:conset/models/patient_model.dart';
import 'package:conset/routes/routes_names.dart';
import 'package:conset/screen/bottom_navigation/screens/patient_details/patient_details.dart';
import 'package:conset/utils/global.dart';
import 'package:conset/widgets/common_widgets/custom_container.dart';
import 'package:conset/widgets/common_widgets/custom_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:conset/controllers/patient_controller/patient_controller.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(patientProvider.notifier).loadPatients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavigationState = ref.watch(bottomNavigationProvider);
    final bottomNavigationController = ref.watch(
      bottomNavigationProvider.notifier,
    );
    final isLoading = ref.watch(apiLoaderProvider);
    final patientList = ref.watch(patientProvider);
    return Scaffold(
      body:
          isLoading == false
              ? RefreshIndicator(
                onRefresh: () async {
                  ref.read(apiLoaderProvider.notifier).state = true;
                  ref.read(apiLoaderProvider.notifier).state = false;
                },
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 0.5.h),
                          Center(
                            child: Container(
                              width: 95.w,
                              height: 14.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AppAssets.appBackground),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                              child: Center(
                                child: Image.asset(
                                  AppAssets.clinicLogo,
                                  width: 50.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          buildSearchBar(),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: patientList.length,
                            itemBuilder: (context, index) {
                              final patient = patientList[index];
                              return GestureDetector(
                                onTap: () {
                                  context.push(
                                    RoutesNames.patientDetailScreen,
                                    extra: patient,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                    vertical: 1.h,
                                  ),
                                  child: CustomContainer(
                                    mrNo: patient.mrNo,
                                    firstName: patient.firstName,
                                    middleName: patient.middleName,
                                    lastName: patient.lastName,
                                    fullName: patient.fullName,
                                    birthDate: patient.birthDate,
                                    isVIP: patient.isVIP,
                                    nationality: patient.nationality,
                                    phone: patient.phone,
                                    sex: patient.sex,
                                    pdfUrls: patient.pdfUrls,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
              : buildShimmerEffect(),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: CustomTextFormField(
        controller: _searchController,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        obscureText: false,
        keyboardType: TextInputType.text,
        filled: true,
        hint: 'Search',
        prefixIcon: Icon(Icons.search),
        inputFormatters: [],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a search term';
          }
          return null;
        },
      ),
    );
  }
}
