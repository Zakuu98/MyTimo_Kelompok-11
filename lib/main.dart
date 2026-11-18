import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/plant_provider.dart';
import 'providers/treatment_provider.dart';
import 'screens/treatment/treatment_plan_screen.dart';
import 'screens/treatment/treatment_recommendation_screen.dart';
import 'screens/treatment/treatment_status_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/history/scan_history_screen.dart';
import 'screens/landing/landing_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/plants/add_plant_screen.dart';
import 'screens/plants/plant_list_screen.dart';
import 'screens/scan/camera_scan_screen.dart';
import 'theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

/// Root widget — di web dibungkus frame HP, di mobile langsung full screen
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Widget utama aplikasi
    final providers = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => PlantProvider()),
        ChangeNotifierProvider(create: (_) => TreatmentProvider()),
      ],
      child: const MyTimoApp(),
    );

    // Di web: tampilkan dalam bingkai HP
    if (kIsWeb) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFF0d0d1a),
          body: Center(
            child: Container(
              width: 390,
              height: 844,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(44),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xAA000000),
                    blurRadius: 70,
                    spreadRadius: 20,
                  ),
                ],
              ),
              child: providers,
            ),
          ),
        ),
      );
    }

    // Di HP asli: langsung full screen
    return providers;
  }
}

/// Aplikasi utama MyTimo
class MyTimoApp extends StatelessWidget {
  const MyTimoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTimo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          primary: AppColors.primaryGreen,
          secondary: AppColors.tomatoRed,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const MainNavigationScreen(),
        '/plants': (context) => const PlantListScreen(),
        '/add-plant': (context) => const AddPlantScreen(),
        '/scan': (context) => const CameraScanScreen(),
        '/history': (context) => const ScanHistoryScreen(),
        '/treatment': (context) => const TreatmentPlanScreen(),
        '/treatment/recommendation': (context) =>
            const TreatmentRecommendationScreen(),
        '/treatment/status': (context) => const TreatmentStatusScreen(),
      },
    );
  }
}
