import 'package:conset/models/patient_model.dart';
import 'package:conset/models/pdf_view_args_model.dart';
import 'package:conset/routes/routes_names.dart';
import 'package:conset/screen/auth/login_screen.dart';
import 'package:conset/screen/bottom_navigation/landing_page.dart';
import 'package:conset/screen/bottom_navigation/screens/dashboard/dashboard_screen.dart';
import 'package:conset/screen/bottom_navigation/screens/patient_details/patient_details.dart';
import 'package:conset/screen/bottom_navigation/screens/patient_details/pdf_saved_view.dart';
import 'package:conset/screen/bottom_navigation/screens/patient_details/widget/pdf_viewer_screen.dart';
import 'package:conset/screen/onboarding/splash_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: RoutesNames.splashScreen,
  routes: [
    GoRoute(
      path: RoutesNames.splashScreen,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: RoutesNames.landingPage,
      builder: (context, state) => LandingPage(),
    ),
    GoRoute(
      path: RoutesNames.loginScreen,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: RoutesNames.dashboardScreen,
      builder: (context, state) => DashboardScreen(),
    ),
    GoRoute(
      path: RoutesNames.patientDetailScreen,
      builder: (context, state) {
        final patient = state.extra as Patient;
        return PatientDetails(patient: patient);
      },
    ),
    GoRoute(
      path: RoutesNames.pdfViewer,
      builder: (context, state) {
        final args = state.extra as PdfViewerArgs;
        return PDFViewerScreen(
          pdfAssetPath: args.pdfUrl,
          patient: args.patient,
        );
      },
    ),
    GoRoute(
      path: RoutesNames.pdfSavedView,
      builder: (context, state) {
        final args = state.extra as PdfViewerArgs;
        return PDFPreviewScreen(
          filePath: args.pdfUrl,
          patient: args.patient,
        );
      },
    ),
  ],
);
