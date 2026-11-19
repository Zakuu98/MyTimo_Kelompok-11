import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mytimo/providers/auth_provider.dart';
import 'package:mytimo/providers/dashboard_provider.dart';
import 'package:mytimo/providers/navigation_provider.dart';
import 'package:mytimo/providers/plant_provider.dart';
import 'package:mytimo/screens/auth/login_screen.dart';
import 'package:mytimo/screens/auth/register_screen.dart';
import 'package:mytimo/screens/landing/landing_screen.dart';

void main() {
  Widget buildTestableApp({Widget? home, Size screenSize = const Size(390, 844)}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => PlantProvider()),
      ],
      child: MediaQuery(
        data: MediaQueryData(
          size: screenSize,
          padding: const EdgeInsets.only(top: 44, bottom: 34),
        ),
        child: MaterialApp(
          home: home ?? const LandingScreen(),
        ),
      ),
    );
  }

  group('LandingScreen Figma Compliance & Responsiveness Tests', () {
    testWidgets('Renders all Figma elements accurately on standard 390x844 screen', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableApp(screenSize: const Size(390, 844)));
      await tester.pumpAndSettle();

      // Check title
      expect(find.text('MyTimo App'), findsOneWidget);

      // Check subtitle
      expect(find.text('Deteksi Penyakit Tomat Secepat Kilat\ndengan AI'), findsOneWidget);

      // Check buttons
      expect(find.text('Mulai Sekarang'), findsOneWidget);
      expect(find.text('Masuk ke Akun Anda'), findsOneWidget);

      // Verify no overflow errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders without overflow on compact screen (360x640)', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableApp(screenSize: const Size(360, 640)));
      await tester.pumpAndSettle();

      // Ensure no overflow
      expect(tester.takeException(), isNull);
      expect(find.text('MyTimo App'), findsOneWidget);
      expect(find.text('Mulai Sekarang'), findsOneWidget);
    });

    testWidgets('Renders without overflow on large modern screen (412x915)', (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableApp(screenSize: const Size(412, 915)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('MyTimo App'), findsOneWidget);
      expect(find.text('Mulai Sekarang'), findsOneWidget);
    });

    testWidgets('Navigates to RegisterScreen when "Mulai Sekarang" is tapped', (tester) async {
      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mulai Sekarang'));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterScreen), findsOneWidget);
    });

    testWidgets('Navigates to LoginScreen when "Masuk ke Akun Anda" is tapped', (tester) async {
      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Masuk ke Akun Anda'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}
