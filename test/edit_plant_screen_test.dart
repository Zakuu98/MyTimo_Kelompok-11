import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mytimo/models/plant_model.dart';
import 'package:mytimo/providers/auth_provider.dart';
import 'package:mytimo/providers/dashboard_provider.dart';
import 'package:mytimo/providers/navigation_provider.dart';
import 'package:mytimo/providers/plant_provider.dart';
import 'package:mytimo/screens/plant_list/edit_plant_screen.dart';
import 'package:mytimo/screens/plant_list/plant_list_screen.dart';

void main() {
  const samplePlant = PlantModel(
    id: 'plt_01',
    name: 'Tomat Cherry Blok A',
    variety: 'Cherry Tropis',
    hst: 63,
    location: 'Greenhouse 1 • Rak B3',
    status: 'Perlu Rawat',
    badgeText: 'Early Blight',
    imagePath: 'assets/custom_assets/images/jamur_septoria.png',
    plantingDate: '05 Agustus 2026',
    notes: 'Daun bawah mulai membaik pasca pemangkasan.',
  );

  Widget buildTestableEditPlantScreen({
    PlantModel plant = samplePlant,
    Size screenSize = const Size(390, 844),
    PlantProvider? customPlantProvider,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(
          create: (_) => customPlantProvider ?? PlantProvider(),
        ),
      ],
      child: MediaQuery(
        data: MediaQueryData(
          size: screenSize,
          padding: const EdgeInsets.only(top: 44, bottom: 34),
        ),
        child: MaterialApp(
          home: EditPlantScreen(plant: plant),
        ),
      ),
    );
  }

  Widget buildTestablePlantListFlow({
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
          home: PlantListScreen(),
        ),
      ),
    );
  }

  group('EditPlantScreen Figma Compliance & Functionality Tests', () {
    testWidgets('Renders all Figma Edit_Tanaman elements on 390x844',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableEditPlantScreen());
      await tester.pumpAndSettle();

      // 1. Header elements
      expect(find.text('Edit Tanaman'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      // 2. Field Labels
      expect(find.text('Nama Tanaman / Blok *'), findsOneWidget);
      expect(find.text('Varietas'), findsOneWidget);
      expect(find.text('Tanggal Tanam *'), findsOneWidget);
      expect(find.text('Lokasi / Keterangan *'), findsOneWidget);
      expect(find.text('Catatan Pemulihan'), findsOneWidget);

      // 3. Pre-filled field values matching Figma mockup
      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
      expect(find.text('Cherry Tropis'), findsOneWidget);
      expect(find.text('05 Agustus 2026'), findsOneWidget);
      expect(find.text('Greenhouse 1 • Rak B3'), findsOneWidget);
      expect(
        find.text('Daun bawah mulai membaik pasca pemangkasan.'),
        findsOneWidget,
      );

      // 4. Save Button
      expect(find.text('Perbarui Data Tanaman'), findsOneWidget);

      // 5. Bottom Navigation Bar elements
      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Tanaman'), findsOneWidget);
      expect(find.text('Pindai'), findsOneWidget);
      expect(find.text('Riwayat'), findsOneWidget);
      expect(find.text('Monitor'), findsOneWidget);
    });

    testWidgets('Renders without overflow on compact 360x640 screen',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestableEditPlantScreen(screenSize: const Size(360, 640)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Edit Tanaman'), findsOneWidget);
      expect(find.text('Perbarui Data Tanaman'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Validation triggers short message when required starred (*) fields are empty',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableEditPlantScreen());
      await tester.pumpAndSettle();

      // Clear the required name field
      await tester.enterText(find.byType(TextFormField).at(0), '');
      await tester.pumpAndSettle();

      // Tap Perbarui Data Tanaman
      await tester.ensureVisible(find.text('Perbarui Data Tanaman'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Perbarui Data Tanaman'));
      await tester.pumpAndSettle();

      // Expect error SnackBar
      expect(
        find.text('Semua kolom bertanda bintang (*) wajib diisi!'),
        findsOneWidget,
      );
    });

    testWidgets(
        'Successfully navigates from PlantListScreen, edits plant data, and shows success popup dialog',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestablePlantListFlow());
      await tester.pumpAndSettle();

      // 1. In PlantListScreen, tap the first card (Tomat Cherry Blok A) to go to PlantDetailScreen
      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
      await tester.tap(find.text('Tomat Cherry Blok A'));
      await tester.pumpAndSettle();

      // Verify on PlantDetailScreen, then tap Edit icon button
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      // Verify navigated to EditPlantScreen
      expect(find.text('Edit Tanaman'), findsOneWidget);
      expect(find.text('Perbarui Data Tanaman'), findsOneWidget);

      // 2. Modify plant name and location
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Tomat Cherry Blok A (Revisi)',
      );
      await tester.enterText(
        find.byType(TextFormField).at(3),
        'Greenhouse 1 • Rak C1',
      );
      await tester.pumpAndSettle();

      // 3. Tap Perbarui Data Tanaman
      await tester.ensureVisible(find.text('Perbarui Data Tanaman'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Perbarui Data Tanaman'));
      await tester.pumpAndSettle();

      // 4. Verify pop-up success dialog appears
      expect(find.text('Data Tanaman Berhasil Diperbarui!'), findsOneWidget);
      expect(
        find.textContaining('Tomat Cherry Blok A (Revisi)'),
        findsWidgets,
      );

      // Dismiss popup dialog
      await tester.tap(find.text('Lihat Daftar Tanaman'));
      await tester.pumpAndSettle();

      // 5. Back on PlantDetailScreen, verify updated title
      expect(find.text('Tomat Cherry Blok A (Revisi)'), findsOneWidget);

      // Return to PlantListScreen
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      // Verify back on PlantListScreen with updated data
      expect(find.text('Daftar Tanaman'), findsOneWidget);
      expect(find.text('Tomat Cherry Blok A (Revisi)'), findsOneWidget);
      expect(find.text('Greenhouse 1 • Rak C1'), findsOneWidget);
    });
  });
}
