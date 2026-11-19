import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mytimo/main.dart';
import 'package:mytimo/screens/auth/login_screen.dart';
import 'package:mytimo/screens/auth/register_screen.dart';
import 'package:mytimo/screens/landing/landing_screen.dart';
import 'package:mytimo/screens/home/home_screen.dart';

void main() {
  testWidgets('MyTimo complete navigation and login flow test', (WidgetTester tester) async {
    // 1. Pump App
    await tester.pumpWidget(const MyTimoApp());
    await tester.pumpAndSettle();

    // Verify LandingScreen is shown
    expect(find.byType(LandingScreen), findsOneWidget);
    expect(find.text('Mulai Sekarang'), findsOneWidget);
    expect(find.text('Masuk ke Akun Anda'), findsOneWidget);

    // 2. Navigate to Login
    await tester.tap(find.text('Masuk ke Akun Anda'));
    await tester.pumpAndSettle();

    // Verify LoginScreen is displayed
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);

    // 3. Perform Login
    await tester.enterText(find.byType(TextFormField).at(0), 'budi.petani@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'KebunTomat123!');
    await tester.tap(find.text('Masuk'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    // Verify Success Popup Dialog
    expect(find.text('Login Berhasil!'), findsOneWidget);
    await tester.tap(find.text('Lanjut ke Beranda'));
    await tester.pumpAndSettle();

    // 4. Verify HomeScreen & Dashboard Figma elements
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Selamat Datang,'), findsOneWidget);
    expect(find.text('Pindai Daun Tomat'), findsOneWidget);
    expect(find.text('Total Tanaman'), findsOneWidget);
    expect(find.text('Menu Utama'), findsOneWidget);
    expect(find.text('Pemeriksaan Terbaru'), findsOneWidget);
    expect(find.text('Early Blight'), findsOneWidget);
    expect(find.text('Septoria'), findsOneWidget);
  });

  testWidgets('MyTimo registration flow test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyTimoApp());
    await tester.pumpAndSettle();

    // Tap Mulai Sekarang -> goes to Register
    await tester.tap(find.text('Mulai Sekarang'));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);

    // Enter details (valid @gmail.com and password with min 8 chars, upper, lower, symbol)
    await tester.enterText(find.byType(TextFormField).at(0), 'Pak Budi Santoso');
    await tester.enterText(find.byType(TextFormField).at(1), 'budi.santoso@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'KebunTomat123!');

    // Tap Daftar
    await tester.tap(find.text('Daftar'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    // Verify Success Popup Dialog
    expect(find.text('Pendaftaran Berhasil!'), findsOneWidget);
    await tester.tap(find.text('Lanjut ke Beranda'));
    await tester.pumpAndSettle();

    // Arrives at HomeScreen
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Selamat Datang,'), findsOneWidget);
  });

  testWidgets('MyTimo disease detail bottom sheet test (FR-05)', (WidgetTester tester) async {
    await tester.pumpWidget(const MyTimoApp());
    await tester.pumpAndSettle();

    // Go directly to home via login
    await tester.tap(find.text('Masuk ke Akun Anda'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'budi.petani@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'KebunTomat123!');
    await tester.tap(find.text('Masuk'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    // Tap Lanjut ke Beranda from popup if present
    if (find.text('Lanjut ke Beranda').evaluate().isNotEmpty) {
      await tester.tap(find.text('Lanjut ke Beranda'));
      await tester.pumpAndSettle();
    }

    // Scroll down to make disease cards visible
    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -300));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Early Blight').first);
    await tester.pumpAndSettle();

    // Verify detail sheet shows treatment and prevention steps
    expect(find.text('Langkah Penanganan (FR-05)'), findsOneWidget);
    expect(find.text('Langkah Pencegahan'), findsOneWidget);
    expect(find.textContaining('Alternaria solani'), findsOneWidget);
  });
}
