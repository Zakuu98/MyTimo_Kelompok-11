import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mytimo/providers/auth_provider.dart';
import 'package:mytimo/providers/dashboard_provider.dart';
import 'package:mytimo/providers/navigation_provider.dart';
import 'package:mytimo/providers/plant_provider.dart';
import 'package:mytimo/screens/auth/login_screen.dart';
import 'package:mytimo/screens/auth/register_screen.dart';
import 'package:mytimo/screens/home/home_screen.dart';

void main() {
  Widget buildTestableApp({
    Widget? home,
    AuthProvider? customAuth,
    Size screenSize = const Size(390, 844),
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => customAuth ?? AuthProvider()),
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
          home: home ?? const LoginScreen(),
        ),
      ),
    );
  }

  group('LoginScreen Figma Compliance & Validation Tests', () {
    testWidgets('Renders all Figma elements accurately on 390x844', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableApp(screenSize: const Size(390, 844)));
      await tester.pumpAndSettle();

      // Titles & Labels
      expect(find.text('Masuk Akun'), findsOneWidget);
      expect(find.text('MyTimo'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Kata Sandi'), findsOneWidget);
      expect(find.text('Lupa Kata Sandi?'), findsOneWidget);
      expect(find.text('Masuk'), findsOneWidget);
      expect(find.textContaining('Belum punya akun', findRichText: true), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders without overflow on compact screen (360x640)', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableApp(screenSize: const Size(360, 640)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Masuk Akun'), findsOneWidget);
      expect(find.text('Masuk'), findsOneWidget);
    });

    testWidgets('Validates email must use @gmail.com', (tester) async {
      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'petani@yahoo.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'KebunTomat123!');
      await tester.tap(find.text('Masuk'));
      await tester.pumpAndSettle();

      expect(find.text('Email harus menggunakan @gmail.com'), findsOneWidget);
    });

    testWidgets('Validates password rules (min 8 chars, uppercase, lowercase, symbol)', (tester) async {
      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'budi.santoso@gmail.com');

      // Less than 8 chars
      await tester.enterText(find.byType(TextFormField).at(1), 'Ab1!');
      await tester.tap(find.text('Masuk'));
      await tester.pumpAndSettle();
      expect(find.text('Kata sandi minimal 8 karakter'), findsOneWidget);

      // No uppercase
      await tester.enterText(find.byType(TextFormField).at(1), 'password123!');
      await tester.tap(find.text('Masuk'));
      await tester.pumpAndSettle();
      expect(find.text('Harus mengandung minimal 1 huruf besar (A-Z)'), findsOneWidget);
    });

    testWidgets('Only registered users can login (rejects unregistered account)', (tester) async {
      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      // Enter unregistered email
      await tester.enterText(find.byType(TextFormField).at(0), 'unknown.petani@gmail.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'Password123!');
      await tester.tap(find.text('Masuk'));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      expect(find.text('Akun belum terdaftar, silakan daftar terlebih dahulu'), findsWidgets);
    });

    testWidgets('Rejects registered account with incorrect password', (tester) async {
      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      // Pre-seeded registered account: budi.santoso@gmail.com
      await tester.enterText(find.byType(TextFormField).at(0), 'budi.santoso@gmail.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'WrongPassword123!');
      await tester.tap(find.text('Masuk'));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      expect(find.text('Kata sandi salah'), findsWidgets);
    });

    testWidgets('Successfully logs in with valid registered account', (tester) async {
      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'budi.santoso@gmail.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'KebunTomat123!');
      await tester.tap(find.text('Masuk'));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      // Expect popup dialog
      expect(find.text('Login Berhasil!'), findsOneWidget);
      await tester.tap(find.text('Lanjut ke Beranda'));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Toggles password visibility on eye icon tap', (tester) async {
      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      final editableFinder = find.byType(EditableText).at(1);
      EditableText editableWidget = tester.widget<EditableText>(editableFinder);
      expect(editableWidget.obscureText, isTrue);

      // Tap eye icon to show password
      final eyeIconFinder = find.byIcon(Icons.visibility_off_outlined);
      expect(eyeIconFinder, findsOneWidget);
      await tester.tap(eyeIconFinder);
      await tester.pumpAndSettle();

      editableWidget = tester.widget<EditableText>(editableFinder);
      expect(editableWidget.obscureText, isFalse);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap again to hide
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      editableWidget = tester.widget<EditableText>(editableFinder);
      expect(editableWidget.obscureText, isTrue);
    });

    testWidgets('Navigates to RegisterScreen when "Daftar" is tapped', (tester) async {
      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('Belum punya akun', findRichText: true));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterScreen), findsOneWidget);
    });
  });
}
