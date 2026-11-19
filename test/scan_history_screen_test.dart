import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mytimo/providers/navigation_provider.dart';
import 'package:mytimo/providers/plant_provider.dart';
import 'package:mytimo/screens/scan/scan_history_screen.dart';

void main() {
  Widget buildTestableScanHistoryScreen({
    bool isEmbeddedInNav = false,
    Size screenSize = const Size(390, 844),
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => PlantProvider()),
      ],
      child: MediaQuery(
        data: MediaQueryData(
          size: screenSize,
          padding: const EdgeInsets.only(top: 44, bottom: 34),
        ),
        child: MaterialApp(
          home: ScanHistoryScreen(isEmbeddedInNav: isEmbeddedInNav),
        ),
      ),
    );
  }

  group('ScanHistoryScreen Figma Riwayat_Scan Tests', () {
    testWidgets('Renders all Figma Riwayat_Scan UI elements in Default Mode (390x844)',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableScanHistoryScreen());
      await tester.pump();

      // 1. Header Gradient, Title, Back & Filter Icons
      expect(find.text('Riwayat Pemindaian'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.filter_alt_outlined), findsOneWidget);

      // 2. Floating Search Bar
      expect(
        find.text('Cari tanggal, tanaman, atau penyakit...'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);

      // 3. Category Filter Chips
      expect(find.text('Semua (24)'), findsOneWidget);
      expect(find.text('Early Blight (8)'), findsOneWidget);
      expect(find.text('Late Blight (5)'), findsOneWidget);
      expect(find.text('Daun Sehat (11)'), findsOneWidget);

      // 4. Featured Scan Cards from Figma CSS
      expect(find.text('Early Blight (94.2%)'), findsOneWidget);
      expect(find.text('Daun Sehat (98.0%)'), findsOneWidget);
      expect(find.text('Late Blight (89.5%)'), findsOneWidget);
      expect(find.text('Daun Sehat (99.1%)'), findsOneWidget);

      // Plant Names in Cards
      expect(find.text('Tomat Cherry Blok A'), findsWidgets);
      expect(find.text('Tomat Servo Bedeng 1'), findsWidgets);
      expect(find.text('Tomat Mawar Bedeng 4'), findsWidgets);

      // Badges
      expect(find.text('Sedang'), findsWidgets);
      expect(find.text('Sehat'), findsWidgets);
      expect(find.text('Parah'), findsWidgets);

      // 5. BottomNavBar Tabs
      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Tanaman'), findsOneWidget);
      expect(find.text('Pindai'), findsOneWidget);
      expect(find.text('Riwayat'), findsOneWidget);
      expect(find.text('Monitor'), findsOneWidget);
    });

    testWidgets(
        'Renders cleanly without overflow on compact 360x640 mobile screen',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableScanHistoryScreen(
        screenSize: const Size(360, 640),
      ));
      await tester.pump();

      expect(find.text('Riwayat Pemindaian'), findsOneWidget);
      expect(find.text('Semua (24)'), findsOneWidget);
      expect(find.text('Early Blight (94.2%)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Tapping filter chip filters list (e.g. Early Blight shows only Early Blight items)',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableScanHistoryScreen());
      await tester.pump();

      // Tap 'Early Blight (8)'
      await tester.tap(find.text('Early Blight (8)'));
      await tester.pumpAndSettle();

      // Early Blight is visible
      expect(find.text('Early Blight (94.2%)'), findsOneWidget);

      // Daun Sehat & Late Blight should not be present in the filtered list
      expect(find.text('Daun Sehat (98.0%)'), findsNothing);
      expect(find.text('Late Blight (89.5%)'), findsNothing);

      // Tap 'Semua (24)' to restore
      await tester.tap(find.text('Semua (24)'));
      await tester.pumpAndSettle();

      expect(find.text('Daun Sehat (98.0%)'), findsOneWidget);
      expect(find.text('Late Blight (89.5%)'), findsOneWidget);
    });

    testWidgets(
        'Searching "Tomat Roma" activates Mode 2: Empty State ("Riwayat Tidak Ditemukan")',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableScanHistoryScreen());
      await tester.pump();

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      // Search "Tomat Roma" as in Figma right screenshot
      await tester.enterText(searchField, 'Tomat Roma');
      await tester.pump();

      // 1. Tag Filter Pill: “Tomat Roma”
      expect(find.text('“Tomat Roma”'), findsOneWidget);

      // 2. Dropdown Pills: Semua Status & Bulan Ini
      expect(find.text('Semua Status'), findsOneWidget);
      expect(find.text('Bulan Ini'), findsOneWidget);

      // 3. Counter Text
      expect(find.text('Menampilkan 0 riwayat pemindaian'), findsOneWidget);

      // 4. Empty State Card
      expect(find.text('Riwayat Tidak Ditemukan'), findsOneWidget);
      expect(
        find.text(
          'Tidak ada hasil scan dengan kata kunci "Tomat Roma".\nCoba periksa ejaan atau ubah filter pencarian Anda.',
        ),
        findsOneWidget,
      );
      expect(find.text('Reset Filter'), findsOneWidget);

      // 5. Tips Card
      expect(find.text('💡 Tips Pencarian Riwayat:'), findsOneWidget);
      expect(
        find.text(
          'Coba gunakan nama blok kebun seperti "Blok A" atau "Bedeng 01".',
        ),
        findsOneWidget,
      );

      // 6. Tapping "Reset Filter" clears search and restores list
      await tester.tap(find.text('Reset Filter'));
      await tester.pumpAndSettle();

      expect(find.text('Riwayat Tidak Ditemukan'), findsNothing);
      expect(find.text('Early Blight (94.2%)'), findsOneWidget);
      expect(find.text('Semua (24)'), findsOneWidget);
    });

    testWidgets(
        'Searching query with matches filters results correctly',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableScanHistoryScreen());
      await tester.pump();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Servo');
      await tester.pump();

      // Only items with 'Servo' are shown
      expect(find.text('Daun Sehat (98.0%)'), findsOneWidget);
      expect(find.text('Tomat Servo Bedeng 1'), findsWidgets);

      // Clear search button '✕' in search bar
      final clearIcon = find.byIcon(Icons.close_rounded);
      expect(clearIcon, findsOneWidget);
      await tester.tap(clearIcon);
      await tester.pump();

      expect(find.text('Early Blight (94.2%)'), findsOneWidget);
    });

    testWidgets(
        'Tapping a Scan History Card opens detail dialog',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableScanHistoryScreen());
      await tester.pump();

      // Tap first card
      await tester.tap(find.text('Early Blight (94.2%)'));
      await tester.pumpAndSettle();

      expect(find.text('Status: Sedang'), findsOneWidget);
      expect(find.text('Lihat Data Tanaman Ini'), findsOneWidget);

      // Tap outside or close
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      expect(find.text('Status: Sedang'), findsNothing);
    });

    testWidgets(
        'Tapping Header Filter icon opens filter bottom sheet and resets',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableScanHistoryScreen());
      await tester.pump();

      // Tap filter icon
      await tester.tap(find.byIcon(Icons.filter_alt_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Filter Riwayat Pemindaian'), findsOneWidget);
      expect(find.text('Tingkat Keparahan / Status:'), findsOneWidget);
      expect(find.text('Terapkan'), findsOneWidget);

      // Tap Terapkan closes sheet
      await tester.tap(find.text('Terapkan'));
      await tester.pumpAndSettle();

      expect(find.text('Filter Riwayat Pemindaian'), findsNothing);
    });
  });
}
