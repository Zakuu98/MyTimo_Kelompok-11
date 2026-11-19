import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mytimo/main.dart';
import 'package:mytimo/screens/history/scan_detail_screen.dart';
import 'package:mytimo/screens/history/scan_history_screen.dart';
import 'package:mytimo/screens/home/home_screen.dart';
import 'package:mytimo/screens/plants/add_plant_screen.dart';
import 'package:mytimo/screens/plants/edit_plant_screen.dart';
import 'package:mytimo/screens/plants/plant_detail_screen.dart';
import 'package:mytimo/screens/plants/plant_list_screen.dart';
import 'package:mytimo/screens/scan/camera_scan_screen.dart';
import 'package:mytimo/screens/scan/photo_preview_screen.dart';

void main() {
  testWidgets('Complete Plant and Scan Management Workflow Test', (WidgetTester tester) async {
    // 1. Pump App and verify landing
    await tester.pumpWidget(const MyTimoApp());
    await tester.pumpAndSettle();

    // 2. Login to Home Screen
    await tester.tap(find.text('Masuk ke Akun Anda'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Masuk'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);

    // 3. Switch to Tanaman tab
    await tester.tap(find.text('Tanaman'));
    await tester.pumpAndSettle();

    expect(find.byType(PlantListScreen), findsOneWidget);
    expect(find.text('Daftar Tanaman'), findsOneWidget);
    expect(find.text('Tomat Cherry Blok A'), findsOneWidget);

    // 4. Test Add Plant Screen
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(AddPlantScreen), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'misal: Tomat Sayur Blok C'),
      'Tomat Unggul Greenhouse 3',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'misal: Lahan Timur - Bedeng 01'),
      'Greenhouse 3 - Rak Barat',
    );

    // Submit new plant
    await tester.ensureVisible(find.text('Simpan Data Tanaman'));
    await tester.tap(find.text('Simpan Data Tanaman'));
    await tester.pumpAndSettle();

    // Clear active snackbar to prevent hitTest obscuring
    ScaffoldMessenger.of(tester.element(find.byType(PlantListScreen))).clearSnackBars();
    await tester.pumpAndSettle();

    // Verify back in list and new plant exists
    expect(find.byType(PlantListScreen), findsOneWidget);
    expect(find.text('Tomat Unggul Greenhouse 3'), findsOneWidget);

    // 5. Open Plant Detail Screen
    await tester.tap(find.text('Tomat Cherry Blok A'));
    await tester.pumpAndSettle();

    expect(find.byType(PlantDetailScreen), findsOneWidget);
    expect(find.text('Cherry Tropic'), findsWidgets);
    expect(find.text('Pindai Daun Tanaman Ini'), findsOneWidget);

    // Test Edit Plant
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(EditPlantScreen), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    // 6. Start Scan from Plant Detail
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pindai Daun Tanaman Ini'));
    await tester.pumpAndSettle();

    expect(find.byType(CameraScanScreen), findsOneWidget);
    expect(find.text('Arahkan pada 1 helai daun bergejala'), findsOneWidget);

    // 7. Trigger Shutter (Proceeds to PhotoPreviewScreen)
    await tester.tap(find.byKey(const Key('camera_shutter_button')));
    await tester.pumpAndSettle();

    expect(find.byType(PhotoPreviewScreen), findsOneWidget);
    expect(find.text('Kualitas Foto Memenuhi Syarat'), findsOneWidget);
    expect(find.text('Simpan Riwayat Scan'), findsOneWidget);

    // 8. Save Scan and go to ScanDetailScreen
    await tester.ensureVisible(find.text('Simpan Riwayat Scan'));
    await tester.tap(find.text('Simpan Riwayat Scan'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.byType(ScanDetailScreen), findsOneWidget);
    expect(find.text('Detail Riwayat Scan'), findsOneWidget);
    expect(find.text('Ubah Catatan Riwayat'), findsOneWidget);

    // 9. Back to Plant Detail
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    // Back to Plant List
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    // Clear any snackbars before switching tabs
    ScaffoldMessenger.of(tester.element(find.byType(PlantListScreen))).clearSnackBars();
    await tester.pumpAndSettle();

    // Switch to Riwayat tab
    await tester.tap(find.text('Riwayat'));
    await tester.pumpAndSettle();

    expect(find.byType(ScanHistoryScreen), findsOneWidget);
    expect(find.text('Riwayat Pemindaian'), findsOneWidget);
  });
}
