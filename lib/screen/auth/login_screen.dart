import 'package:carousel_slider/carousel_slider.dart';
import 'package:conset/controllers/auth_controller/UI_login_controller/login_controller.dart';
import 'package:conset/controllers/auth_controller/api_login_auth_controller/login_auth_controller.dart';
import 'package:conset/core/app_assets/app_assets.dart';
import 'package:conset/core/color_assets/color_assets.dart';
import 'package:conset/routes/routes_names.dart';
import 'package:conset/services/common_services/app_service/app_service.dart';
import 'package:conset/utils/global.dart';
import 'package:conset/widgets/common_widgets/bottom_curve_clipper.dart';
import 'package:conset/widgets/common_widgets/custom_text_form.dart';
import 'package:conset/widgets/common_widgets/fractinally_elevated_button.dart';
import 'package:conset/widgets/common_widgets/guide_text.dart';
import 'package:conset/widgets/common_widgets/heading_text.dart';
import 'package:conset/widgets/common_widgets/title_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// CarouselSlider images
  final List<String> imageList = [
    AppAssets.carousalImage1,
    AppAssets.carousalImage2,
    AppAssets.carousalImage3,
  ];

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildCarouselSlider(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          HeadingText(text: 'Login ID'),
                          AppSize.vrtSpace(0.5.h),
                          userTextField(false),
                          AppSize.vrtSpace(1.h),
                          HeadingText(text: 'Password'),
                          AppSize.vrtSpace(0.5.h),
                          passTextField(false),
                          AppSize.vrtSpace(1.5.h),
                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: GuideText(
                          //     text1: 'Not Registered?',
                          //     text2: ' Click to signup',
                          //     ontap: () {
                          //       // context.push(RouteNames.signup);
                          //     },
                          //   ),
                          // ),
                          AppSize.vrtSpace(1.5.h),
                          loginButton(),
                          AppSize.vrtSpace(1.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return ClipPath(
      clipper: BottomCurveClipper(),
      child: Container(
        height: 35.h,
        width: double.infinity,
        color: ColorAssets.primaryColor,
        child: CarouselSlider(
          options: CarouselOptions(
            height: 35.h,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            autoPlayInterval: Duration(seconds: 3),
          ),
          items:
              imageList.map((imagePath) {
                return Image.asset(imagePath, fit: BoxFit.cover);
              }).toList(),
        ),
      ),
    );
  }

  CustomTextFormField userTextField(bool userFilled) {
    return CustomTextFormField(
      controller: emailController,
      hint: "Email",
      obscureText: false,
      validator: validator,
      filled: userFilled,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        if (value?.isNotEmpty ?? false) {
        } else {}
      },
    );
  }

  CustomTextFormField passTextField(bool passFilled) {
    final loginState = ref.watch(loginNotifierProvider);
    final loginWidgetController = ref.read(loginNotifierProvider.notifier);

    return CustomTextFormField(
      hint: 'Password',
      filled: passFilled,
      obscureText: loginWidgetController.passwordObsecure,
      controller: passwordController,
      validator: validator,
      onSuffixTap: () {
        final obsecureValue = !loginWidgetController.passwordObsecure;
        loginWidgetController.setPasswordObsecureState(obsecureValue);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      suffix:
          loginWidgetController.passwordObsecure
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
    );
  }

  Widget loginButton() {
    final loginButtonController =
        ref.watch(loginNotifierProvider.notifier).buttonLoader;

    return Center(
      child: FractionallyElevatedButton(
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            await onInit(
              emailController.text.trim(),
              passwordController.text.trim(),
            );
          }
        },
        child:
            loginButtonController
                ? Center(
                  child: CircularProgressIndicator(
                    color: ColorAssets.whiteColor,
                  ),
                )
                : TitleText(
                  title: "Login",
                  color: ColorAssets.whiteColor,
                  fontSize: 20,
                  weight: FontWeight.w700,
                ),
      ),
    );
  }

  /// API CALL FOR LOGIN
  Future<void> onInit(String email, String password) async {
    final loginNotifier = ref.read(loginNotifierProvider.notifier);
    try {
      loginNotifier.setLoginButtonLoaderState(true);

      final response = await ref
          .read(loginAuthProvider.notifier)
          .loginAuth(email, password);

      if (response != null) {
        String email = response.email;
        String password = response.password;

        customSnackbar(
          context,
          'Successfully Logged In',
          'Welcome',
          ColorAssets.greenColor,
        );
        context.push(RoutesNames.landingPage);
      } else {
        customSnackbar(
          context,
          'Invalid Credentials',
          'Please Try Again',
          ColorAssets.errorColor,
        );
      }
    } catch (e) {
      print(e);
      customSnackbar(
        context,
        'An error occurred',
        'Please try again later',
        ColorAssets.errorColor,
      );
    } finally {
      loginNotifier.setLoginButtonLoaderState(false);
    }
  }
}
