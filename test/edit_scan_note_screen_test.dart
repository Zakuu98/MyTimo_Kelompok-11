import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mytimo/providers/navigation_provider.dart';
import 'package:mytimo/providers/plant_provider.dart';
import 'package:mytimo/screens/scan/edit_scan_note_screen.dart';
import 'package:mytimo/screens/scan/scan_history_screen.dart';

void main() {
  Widget buildTestableEditScanNoteScreen({
    ScanHistoryItem? item,
    String? plantName,
    String? initialDate,
    String? initialRelatedInspection,
    String? initialLocation,
    String? initialNotes,
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
          home: EditScanNoteScreen(
            item: item,
            plantName: plantName,
            initialDate: initialDate,
            initialRelatedInspection: initialRelatedInspection,
            initialLocation: initialLocation,
            initialNotes: initialNotes,
          ),
        ),
      ),
    );
  }

  group('EditScanNoteScreen Figma edit_catatan_riwayat Tests', () {
    testWidgets('Renders all Figma edit_catatan_riwayat UI elements on 390x844',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableEditScanNoteScreen());
      await tester.pump();

      // 1. Header Gradient & Title
      expect(find.text('Ubah Catatan Riwayat'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      // 2. Field 1: Tanaman (Disabled/Read-only, tulisan "Terkunci" dihilangkan sesuai permintaan user)
      expect(find.text('Tanaman'), findsWidgets); // di label dan tab bottom nav
      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
      expect(find.text('Terkunci'), findsNothing); // Verifikasi kata "Terkunci" dihilangkan

      // 3. Field 2: Tanggal Pemeriksaan *
      expect(find.text('Tanggal Pemeriksaan *'), findsOneWidget);
      expect(find.text('11 November 2026'), findsOneWidget);

      // 4. Field 3: Pemeriksaan terkait (opsional)
      expect(find.text('Pemeriksaan terkait (opsional)'), findsOneWidget);
      expect(
        find.text('Pilih dari riwayat scan tanaman ini'),
        findsOneWidget,
      );

      // 5. Field 4: Lokasi / Keterangan *
      expect(find.text('Lokasi / Keterangan *'), findsOneWidget);
      expect(find.text('Lahan Timur - Bedeng 02'), findsOneWidget);

      // 6. Field 5: Catatan Awal
      expect(find.text('Catatan Awal'), findsOneWidget);
      expect(
        find.text('Bibit semai 25 hari, media tanah kompos organik.'),
        findsOneWidget,
      );

      // 7. Tombol: Simpan Data Tanaman
      expect(find.text('Simpan Data Tanaman'), findsOneWidget);

      // 8. BottomNavigationBar Tabs
      expect(find.text('Beranda'), findsOneWidget);
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

      await tester.pumpWidget(buildTestableEditScanNoteScreen(
        screenSize: const Size(360, 640),
      ));
      await tester.pump();

      expect(find.text('Ubah Catatan Riwayat'), findsOneWidget);
      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
      expect(find.text('Simpan Data Tanaman'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Tanaman field is read-only and cannot be edited by user',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableEditScanNoteScreen());
      await tester.pump();

      // Tap on the plant field
      await tester.tap(find.text('Tomat Cherry Blok A'));
      await tester.pump();

      // Text remains Tomat Cherry Blok A, no soft keyboard input field for plant name
      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
      expect(find.text('Terkunci'), findsNothing);
    });

    testWidgets(
        'Editing fields and tapping "Simpan Data Tanaman" saves data and shows feedback',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableEditScanNoteScreen());
      await tester.pump();

      // Find location field and change text
      final locationField = find.widgetWithText(TextField, 'Lahan Timur - Bedeng 02');
      expect(locationField, findsOneWidget);
      await tester.enterText(locationField, 'Lahan Barat - Bedeng 05');
      await tester.pump();

      // Tap Simpan Data Tanaman
      await tester.tap(find.text('Simpan Data Tanaman'));
      await tester.pump();

      expect(
        find.text('Data catatan riwayat berhasil disimpan!'),
        findsOneWidget,
      );
    });

    testWidgets(
        'Empty location field shows validation snackbar error',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableEditScanNoteScreen());
      await tester.pump();

      // Clear location field
      final locationField = find.widgetWithText(TextField, 'Lahan Timur - Bedeng 02');
      await tester.enterText(locationField, '');
      await tester.pump();

      // Tap Simpan Data Tanaman
      await tester.tap(find.text('Simpan Data Tanaman'));
      await tester.pump();

      expect(
        find.text('Lokasi / Keterangan tidak boleh kosong!'),
        findsWidgets, // snackbar & inline error text
      );
    });

    testWidgets('Empty date field shows validation error', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableEditScanNoteScreen(initialDate: ''));
      await tester.pump();

      // Tap Simpan Data Tanaman
      await tester.tap(find.text('Simpan Data Tanaman'));
      await tester.pump();

      expect(
        find.text('Tanggal pemeriksaan wajib diisi!'),
        findsWidgets,
      );
    });

    testWidgets('Empty notes field shows validation error', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableEditScanNoteScreen(initialNotes: ''));
      await tester.pump();

      // Tap Simpan Data Tanaman
      await tester.tap(find.text('Simpan Data Tanaman'));
      await tester.pump();

      expect(
        find.text('Catatan awal tidak boleh kosong!'),
        findsWidgets,
      );
    });
  });
}
