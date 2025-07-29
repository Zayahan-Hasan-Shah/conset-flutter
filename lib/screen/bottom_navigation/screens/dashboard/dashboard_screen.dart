import 'package:conset/controllers/api_loader_controller/api_loader_controller.dart';
import 'package:conset/controllers/bottom_navigation_controller/bottom_navigation_controller.dart';
import 'package:conset/core/app_assets/app_assets.dart';
import 'package:conset/routes/routes_names.dart';
import 'package:conset/utils/global.dart';
import 'package:conset/widgets/common_widgets/custom_app_bar.dart';
import 'package:conset/widgets/common_widgets/custom_container.dart';
import 'package:conset/widgets/common_widgets/custom_text_form.dart';
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
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(patientProvider.notifier).loadPatients();
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase().trim();
      });
    });
  }

  List<dynamic> _filterPatients(List<dynamic> patients) {
    if (_searchQuery.isEmpty) return patients;

    return patients.where((patient) {
      final mrNoMatch =
          patient.mrNo?.toLowerCase().contains(_searchQuery) ?? false;
      final nameMatch =
          patient.fullName?.toLowerCase().contains(_searchQuery) ?? false;
      return mrNoMatch || nameMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavigationState = ref.watch(bottomNavigationProvider);
    final bottomNavigationController = ref.watch(
      bottomNavigationProvider.notifier,
    );
    final isLoading = ref.watch(apiLoaderProvider);
    final patientList = ref.watch(patientProvider);
    final filteredList = _filterPatients(patientList);
    return Scaffold(
      appBar: CustomAppBar(text: 'Dashboard'),
      body:
          isLoading == false
              ? RefreshIndicator(
                onRefresh: () async {
                  ref.read(apiLoaderProvider.notifier).state = true;
                  ref.read(apiLoaderProvider.notifier).state = false;
                },
                child:
                    filteredList.isEmpty
                        ? const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('No patients found'),
                        )
                        : LayoutBuilder(
                          builder: (
                            BuildContext context,
                            BoxConstraints constraints,
                          ) {
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
                                          image: AssetImage(
                                            AppAssets.appBackground,
                                          ),
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
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final patient = filteredList[index];
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
        obscureText: false,
        keyboardType: TextInputType.text,
        filled: true,
        hint: 'Search by Name or MRNO',
        prefixIcon: const Icon(Icons.search),
        inputFormatters: [],
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
