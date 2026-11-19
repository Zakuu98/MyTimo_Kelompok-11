import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mytimo/providers/navigation_provider.dart';
import 'package:mytimo/providers/plant_provider.dart';
import 'package:mytimo/screens/scan/scan_history_detail_screen.dart';
import 'package:mytimo/screens/scan/scan_history_screen.dart';

void main() {
  Widget buildTestableDetailScreen({
    ScanHistoryItem? item,
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
          home: ScanHistoryDetailScreen(item: item),
        ),
      ),
    );
  }

  group('ScanHistoryDetailScreen Figma Detail_Riwayat_Scan Tests', () {
    testWidgets('Renders all Figma Detail_Riwayat_Scan UI elements on 390x844',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableDetailScreen());
      await tester.pump();

      // 1. Header Gradient & Title
      expect(find.text('Detail Riwayat Pemindaian'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      // 2. Scan Photo Box & Corner Brackets
      expect(find.byType(Image), findsWidgets);

      // 3. Plant, Time & Diagnosis Card
      expect(find.text('Tanaman & Waktu'), findsOneWidget);
      expect(find.text('Tomat Cherry Blok A • 06 Okt 2026, 14:20'), findsOneWidget);
      expect(find.text('Diagnosis: Early Blight (94.2% Akurat)'), findsOneWidget);

      // 4. Catatan Riwayat Section
      expect(find.text('Catatan Riwayat'), findsOneWidget);
      expect(
        find.text(
          'Bercak baru muncul di 2 daun bagian bawah, segera pangkas dan semprot fungisida tembaga.',
        ),
        findsOneWidget,
      );

      // 5. Action Buttons & Header Trash Icon
      expect(find.text('Simpan Perubahan Catatan'), findsOneWidget);
      expect(find.text('Hapus Riwayat Scan Ini'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline_rounded), findsNWidgets(2));

      // 6. BottomNavigationBar Tabs
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
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableDetailScreen(
        screenSize: const Size(360, 640),
      ));
      await tester.pump();

      expect(find.text('Detail Riwayat Pemindaian'), findsOneWidget);
      expect(find.text('Tomat Cherry Blok A • 06 Okt 2026, 14:20'), findsOneWidget);
      expect(find.text('Simpan Perubahan Catatan'), findsOneWidget);
      expect(find.text('Hapus Riwayat Scan Ini'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Editing note and tapping "Simpan Perubahan Catatan" shows success SnackBar',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableDetailScreen());
      await tester.pump();

      final notesField = find.byType(TextField);
      expect(notesField, findsOneWidget);

      await tester.enterText(notesField, 'Catatan baru telah diperbarui');
      await tester.pump();

      // Tap Simpan
      await tester.tap(find.text('Simpan Perubahan Catatan'));
      await tester.pump();

      expect(
        find.text('Perubahan catatan riwayat berhasil disimpan!'),
        findsOneWidget,
      );
    });

    testWidgets(
        'Tapping "Hapus Riwayat Scan Ini" displays confirmation dialog with Batal and Hapus buttons',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableDetailScreen());
      await tester.pump();

      // Tap Hapus button
      await tester.tap(find.text('Hapus Riwayat Scan Ini'));
      await tester.pumpAndSettle();

      expect(find.text('Hapus Riwayat Scan?'), findsOneWidget);
      expect(
        find.text('Apakah anda yakin ingin menghapus data riwayat pemindaian ini'),
        findsOneWidget,
      );
      expect(find.text('Peringatan!'), findsOneWidget);
      expect(
        find.text('Foto daun, hasil AI, dan catatan tidak dapat dipulihkan.'),
        findsOneWidget,
      );
      expect(find.text('Batal'), findsOneWidget);
      expect(find.text('Hapus'), findsOneWidget);

      // Tap Batal closes dialog
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      expect(find.text('Hapus Riwayat Scan?'), findsNothing);
    });

    testWidgets('Custom ScanHistoryItem parameters render correctly',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final customItem = ScanHistoryItem(
        id: 'scan-99',
        title: 'Daun Sehat (99.5%)',
        plantName: 'Tomat Beef Blok C',
        dateTimeText: '10 Okt 2026, 09:00',
        status: 'Sehat',
        diseaseName: 'Daun Sehat',
        confidence: 99.5,
        imageAsset: 'assets/custom_assets/images/jamur_septoria.png',
        date: DateTime(2026, 10, 10, 9, 0),
      );

      await tester.pumpWidget(buildTestableDetailScreen(item: customItem));
      await tester.pump();

      expect(find.text('Tomat Beef Blok C • 10 Okt 2026, 09:00'), findsOneWidget);
      expect(find.text('Diagnosis: Daun Sehat (99.5% Akurat)'), findsOneWidget);
    });
  });
}
