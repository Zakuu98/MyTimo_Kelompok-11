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
          home: home ?? const RegisterScreen(),
        ),
      ),
    );
  }

  group('RegisterScreen Figma Compliance & Validation Tests', () {
    testWidgets('Renders all Figma elements accurately on 390x844', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableApp(screenSize: const Size(390, 844)));
      await tester.pumpAndSettle();

      // Titles & Labels
      expect(find.text('Daftar Akun MyTimo'), findsOneWidget);
      expect(find.text('Pantau Kesehatan Tanaman Kamu'), findsOneWidget);
      expect(find.text('Nama'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Kata Sandi'), findsOneWidget);
      expect(find.text('Daftar'), findsOneWidget);
      expect(find.textContaining('Sudah punya akun', findRichText: true), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders without overflow on compact screen (360x640)', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableApp(screenSize: const Size(360, 640)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Daftar Akun MyTimo'), findsOneWidget);
      expect(find.text('Daftar'), findsOneWidget);
    });

    testWidgets('Validates email must use @gmail.com', (tester) async {
      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      // Test non-gmail email
      await tester.enterText(find.byType(TextFormField).at(0), 'Petani Sukses');
      await tester.enterText(find.byType(TextFormField).at(1), 'petani@yahoo.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'Password123!');
      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle();

      expect(find.text('Email harus menggunakan @gmail.com'), findsOneWidget);

      // Now enter valid @gmail.com
      await tester.enterText(find.byType(TextFormField).at(1), 'petani.sukses@gmail.com');
      await tester.tap(find.text('Daftar'));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      // Successfully registered and shows popup dialog
      expect(find.text('Pendaftaran Berhasil!'), findsOneWidget);
      await tester.tap(find.text('Lanjut ke Beranda'));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Validates password rules (min 8 chars, uppercase, lowercase, symbol)', (tester) async {
      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'Petani Sukses');
      await tester.enterText(find.byType(TextFormField).at(1), 'petani@gmail.com');

      // 1. Less than 8 chars
      await tester.enterText(find.byType(TextFormField).at(2), 'Ab1!');
      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle();
      expect(find.text('Kata sandi minimal 8 karakter'), findsOneWidget);

      // 2. No uppercase
      await tester.enterText(find.byType(TextFormField).at(2), 'password123!');
      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle();
      expect(find.text('Harus mengandung minimal 1 huruf besar (A-Z)'), findsOneWidget);

      // 3. No lowercase
      await tester.enterText(find.byType(TextFormField).at(2), 'PASSWORD123!');
      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle();
      expect(find.text('Harus mengandung minimal 1 huruf kecil (a-z)'), findsOneWidget);

      // 4. No symbol
      await tester.enterText(find.byType(TextFormField).at(2), 'Password123');
      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle();
      expect(find.text('Harus mengandung minimal 1 simbol (!@#\$%...)'), findsOneWidget);
    });

    testWidgets('Toggles password visibility on eye icon tap', (tester) async {
      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      final editableFinder = find.byType(EditableText).at(2);
      EditableText editableWidget = tester.widget<EditableText>(editableFinder);
      expect(editableWidget.obscureText, isTrue);

      // Tap eye icon
      final eyeIconFinder = find.byIcon(Icons.visibility_off_outlined);
      expect(eyeIconFinder, findsOneWidget);
      await tester.tap(eyeIconFinder);
      await tester.pumpAndSettle();

      // Now visible
      editableWidget = tester.widget<EditableText>(editableFinder);
      expect(editableWidget.obscureText, isFalse);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap again to hide
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      editableWidget = tester.widget<EditableText>(editableFinder);
      expect(editableWidget.obscureText, isTrue);
    });

    testWidgets('Navigates to LoginScreen when "Masuk" is tapped', (tester) async {
      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('Sudah punya akun', findRichText: true));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}
