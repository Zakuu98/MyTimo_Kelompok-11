import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mytimo/providers/auth_provider.dart';
import 'package:mytimo/providers/dashboard_provider.dart';
import 'package:mytimo/providers/navigation_provider.dart';
import 'package:mytimo/providers/plant_provider.dart';
import 'package:mytimo/screens/auth/forgot_password_screen.dart';

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
          home: home ?? const ForgotPasswordScreen(),
        ),
      ),
    );
  }

  group('ForgotPasswordScreen Figma Compliance & Validation Tests', () {
    testWidgets('Renders all Figma elements accurately on 390x844', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableApp(screenSize: const Size(390, 844)));
      await tester.pumpAndSettle();

      // Titles & Labels
      expect(find.text('Lupa Kata Sandi'), findsNWidgets(2)); // Header bar title & Body title
      expect(find.textContaining('Buat kata sandi baru untuk akun MyTimo kamu'), findsOneWidget);
      expect(find.text('Kata Sandi Baru'), findsOneWidget);
      expect(find.text('Konfirmasi Kata Sandi Baru'), findsOneWidget);
      expect(find.text('Atur Kata Sandi'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders without overflow on compact screen (360x640)', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableApp(screenSize: const Size(360, 640)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Atur Kata Sandi'), findsOneWidget);
    });

    testWidgets('Validates password rules (min 8 chars, uppercase, lowercase, symbol)', (tester) async {
      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      // 1. Weak password (less than 8 chars)
      await tester.enterText(find.byType(TextFormField).at(0), 'Ab1!');
      await tester.enterText(find.byType(TextFormField).at(1), 'Ab1!');
      await tester.tap(find.text('Atur Kata Sandi'));
      await tester.pumpAndSettle();

      expect(find.text('Kata sandi minimal 8 karakter'), findsOneWidget);

      // 2. No uppercase
      await tester.enterText(find.byType(TextFormField).at(0), 'kebun123!');
      await tester.enterText(find.byType(TextFormField).at(1), 'kebun123!');
      await tester.tap(find.text('Atur Kata Sandi'));
      await tester.pumpAndSettle();

      expect(find.text('Harus mengandung minimal 1 huruf besar (A-Z)'), findsOneWidget);

      // 3. No symbol
      await tester.enterText(find.byType(TextFormField).at(0), 'KebunTomat123');
      await tester.enterText(find.byType(TextFormField).at(1), 'KebunTomat123');
      await tester.tap(find.text('Atur Kata Sandi'));
      await tester.pumpAndSettle();

      expect(find.text('Harus mengandung minimal 1 simbol (!@#\$%...)'), findsOneWidget);
    });

    testWidgets('Validates password confirmation mismatch', (tester) async {
      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'KebunTomat123!');
      await tester.enterText(find.byType(TextFormField).at(1), 'BedaPassword123!');
      await tester.tap(find.text('Atur Kata Sandi'));
      await tester.pumpAndSettle();

      expect(find.text('Konfirmasi kata sandi tidak cocok'), findsOneWidget);
    });

    testWidgets('Successfully resets password and displays success SnackBar', (tester) async {
      final auth = AuthProvider();
      await tester.pumpWidget(buildTestableApp(customAuth: auth));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'SandiBaru2026!');
      await tester.enterText(find.byType(TextFormField).at(1), 'SandiBaru2026!');
      await tester.tap(find.text('Atur Kata Sandi'));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump();

      // Check success snackbar
      expect(find.text('Kata sandi berhasil diperbarui! Silakan masuk kembali.'), findsOneWidget);
    });

    testWidgets('Toggles password visibility on eye icons independently', (tester) async {
      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      final firstEditable = find.byType(EditableText).at(0);
      final secondEditable = find.byType(EditableText).at(1);

      expect(tester.widget<EditableText>(firstEditable).obscureText, isTrue);
      expect(tester.widget<EditableText>(secondEditable).obscureText, isTrue);

      // Tap first eye icon
      await tester.tap(find.byIcon(Icons.visibility_off_outlined).first);
      await tester.pumpAndSettle();

      expect(tester.widget<EditableText>(firstEditable).obscureText, isFalse);
      expect(tester.widget<EditableText>(secondEditable).obscureText, isTrue);
    });
  });
}
