import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mytimo/providers/auth_provider.dart';
import 'package:mytimo/providers/dashboard_provider.dart';
import 'package:mytimo/providers/navigation_provider.dart';
import 'package:mytimo/providers/plant_provider.dart';
import 'package:mytimo/screens/home/home_screen.dart';
import 'package:mytimo/screens/main_navigation_screen.dart';
import 'package:mytimo/screens/plant_list/plant_list_screen.dart';

void main() {
  Widget buildTestableHomeScreen({
    Size screenSize = const Size(390, 844),
  }) {
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
        child: const MaterialApp(
          home: MainNavigationScreen(),
        ),
      ),
    );
  }

  group('HomeScreen Figma Compliance & Functionality Tests', () {
    testWidgets('Renders all Figma Home elements accurately on 390x844', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableHomeScreen(screenSize: const Size(390, 844)));
      await tester.pumpAndSettle();

      // 1. Header Card
      expect(find.text('Selamat Datang,'), findsOneWidget);
      expect(find.text('Pak Joko Santoso'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Cari tanaman, penyakit, atau catatan…'), findsOneWidget);

      // 2. Banner Scan Card
      expect(find.text('Pindai Daun Tomat'), findsOneWidget);
      expect(find.textContaining('Deteksi hama & jamur langsung di kebun dalam 2 detik'), findsOneWidget);
      expect(find.text('Buka Kamera'), findsOneWidget);

      // 3. Stats Row
      expect(find.text('Total Tanaman'), findsOneWidget);
      expect(find.text('Perlu Rawat'), findsOneWidget);
      expect(find.text('Daun Sehat'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('9'), findsOneWidget);

      // 4. Menu Utama
      expect(find.text('Menu Utama'), findsOneWidget);
      expect(find.text('Data Tanaman'), findsWidgets);
      expect(find.text('Riwayat Scan'), findsOneWidget);
      expect(find.text('Rencana Rawat'), findsOneWidget);
      expect(find.text('Monitoring'), findsOneWidget);

      // 5. Pemeriksaan Terbaru
      expect(find.text('Pemeriksaan Terbaru'), findsOneWidget);
      expect(find.text('Lihat Semua'), findsOneWidget);
      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
      expect(find.text('Early Blight'), findsOneWidget);
      expect(find.text('Tomat Servo Bedeng 1'), findsOneWidget);
      expect(find.text('Septoria'), findsOneWidget);

      // 6. Bottom Navigation Bar
      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Tanaman'), findsOneWidget);
      expect(find.text('Pindai'), findsOneWidget);
      expect(find.text('Riwayat'), findsOneWidget);
      expect(find.text('Monitor'), findsOneWidget);

      final err = tester.takeException();
      if (err is FlutterError) {
        // ignore: avoid_print
        print('DEBUG STACK: ${err.toStringDeep()}');
      }
      expect(err, isNull);
    });

    testWidgets('Renders without overflow on compact screen (360x640)', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableHomeScreen(screenSize: const Size(360, 640)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Selamat Datang,'), findsOneWidget);
      expect(find.text('Pindai Daun Tomat'), findsOneWidget);
    });

    testWidgets('Tapping Buka Kamera opens scan modal bottom sheet', (tester) async {
      await tester.pumpWidget(buildTestableHomeScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buka Kamera'));
      await tester.pumpAndSettle();

      expect(find.text('Pilih Sumber Foto Tomat'), findsOneWidget);
      expect(find.text('Ambil Foto dari Kamera'), findsOneWidget);
      expect(find.text('Unggah dari Galeri'), findsOneWidget);
    });

    testWidgets('Tapping center FAB Pindai opens scan bottom sheet', (tester) async {
      await tester.pumpWidget(buildTestableHomeScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pindai'));
      await tester.pumpAndSettle();

      expect(find.text('Pemindaian Daun Tomat'), findsOneWidget);
      expect(find.text('Buka Kamera dengan Framing Guide'), findsOneWidget);
    });

    testWidgets('Tapping Rencana Rawat opens treatment plan modal', (tester) async {
      await tester.pumpWidget(buildTestableHomeScreen());
      await tester.pumpAndSettle();

      // Scroll slightly to view Menu Utama
      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -100));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Rencana Rawat'));
      await tester.pumpAndSettle();

      expect(find.text('Rencana Rawat Tanaman'), findsOneWidget);
      expect(find.textContaining('Mankozeb'), findsOneWidget);
    });

    testWidgets('Tapping Pemeriksaan card opens disease details (FR-05)', (tester) async {
      await tester.pumpWidget(buildTestableHomeScreen());
      await tester.pumpAndSettle();

      // Scroll to bottom
      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -350));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tomat Cherry Blok A'));
      await tester.pumpAndSettle();

      expect(find.text('Langkah Penanganan (FR-05)'), findsOneWidget);
      expect(find.text('Langkah Pencegahan'), findsOneWidget);
      expect(find.text('Tutup Panduan'), findsOneWidget);
    });

    testWidgets('Tapping bottom navigation tabs switches tabs smoothly', (tester) async {
      await tester.pumpWidget(buildTestableHomeScreen());
      await tester.pumpAndSettle();

      // Tap Tanaman tab
      await tester.tap(find.text('Tanaman'));
      await tester.pumpAndSettle();
      expect(find.byType(PlantListScreen), findsOneWidget);

      // Tap Riwayat tab
      await tester.tap(find.text('Riwayat'));
      await tester.pumpAndSettle();
      expect(find.text('Riwayat Pemindaian'), findsWidgets);

      // Tap Monitor tab
      await tester.tap(find.text('Monitor'));
      await tester.pumpAndSettle();
      expect(find.text('Monitoring Kesehatan'), findsWidgets);

      // Return to Beranda tab
      await tester.tap(find.text('Beranda'));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
