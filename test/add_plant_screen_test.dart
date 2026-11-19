import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mytimo/providers/auth_provider.dart';
import 'package:mytimo/providers/dashboard_provider.dart';
import 'package:mytimo/providers/navigation_provider.dart';
import 'package:mytimo/providers/plant_provider.dart';
import 'package:mytimo/screens/plant_list/add_plant_screen.dart';
import 'package:mytimo/screens/plant_list/plant_list_screen.dart';

void main() {
  Widget buildTestableAddPlantScreen({
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
        child: const MaterialApp(
          home: AddPlantScreen(),
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

  group('AddPlantScreen Figma Compliance & Validation Tests', () {
    testWidgets('Renders all Figma Tambah_Tanaman elements on 390x844',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableAddPlantScreen());
      await tester.pumpAndSettle();

      // 1. Header elements
      expect(find.text('Tambah Tanaman'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      // 2. Field Labels
      expect(find.text('Nama Tanaman / Blok *'), findsOneWidget);
      expect(find.text('Varietas / Jenis (Opsional)'), findsOneWidget);
      expect(find.text('Tanggal Tanam *'), findsOneWidget);
      expect(find.text('Lokasi / Keterangan *'), findsOneWidget);
      expect(find.text('Catatan Awal'), findsOneWidget);

      // 3. Save Button
      expect(find.text('Simpan Data Tanaman'), findsOneWidget);

      // 4. Bottom Navigation Bar elements
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
        buildTestableAddPlantScreen(screenSize: const Size(360, 640)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tambah Tanaman'), findsOneWidget);
      expect(find.text('Simpan Data Tanaman'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Validation triggers short message when required starred (*) fields are empty',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final plantProvider = PlantProvider();
      final initialCount = plantProvider.plants.length;

      await tester.pumpWidget(
        buildTestableAddPlantScreen(customPlantProvider: plantProvider),
      );
      await tester.pumpAndSettle();

      // Tap Simpan Data Tanaman without filling required fields
      await tester.ensureVisible(find.text('Simpan Data Tanaman'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Simpan Data Tanaman'));
      await tester.pumpAndSettle();

      // Expect short error SnackBar
      expect(
        find.text('Semua kolom bertanda bintang (*) wajib diisi!'),
        findsOneWidget,
      );

      // Expect no new plant was added
      expect(plantProvider.plants.length, equals(initialCount));
    });

    testWidgets(
        'Successfully adds plant to top of list with NEW label and shows success popup',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestablePlantListFlow());
      await tester.pumpAndSettle();

      // 1. In PlantListScreen, tap the FAB (+) to go to AddPlantScreen
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();

      // Verify we are now on AddPlantScreen
      expect(find.text('Tambah Tanaman'), findsOneWidget);
      expect(find.text('Simpan Data Tanaman'), findsOneWidget);

      // 2. Fill in the fields
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Tomat Sayur Blok C (Unggulan)',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'Gustavi F1',
      );
      await tester.enterText(
        find.byType(TextFormField).at(2),
        '15 September 2026',
      );
      await tester.enterText(
        find.byType(TextFormField).at(3),
        'Lahan Timur - Bedeng 02',
      );
      await tester.enterText(
        find.byType(TextFormField).at(4),
        'Bibit semai 25 hari, media tanah kompos organik.',
      );

      // 3. Tap Simpan Data Tanaman
      await tester.ensureVisible(find.text('Simpan Data Tanaman'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Simpan Data Tanaman'));
      await tester.pumpAndSettle();

      // 4. Verify pop-up success dialog appears
      expect(find.text('Data Tanaman Ditambahkan!'), findsOneWidget);
      expect(
        find.textContaining('Tomat Sayur Blok C (Unggulan)'),
        findsWidgets,
      );

      // Dismiss popup dialog
      await tester.tap(find.text('Lihat Daftar Tanaman'));
      await tester.pumpAndSettle();

      // 5. Verify back on PlantListScreen with NEW tag on the newly added plant
      expect(find.text('Daftar Tanaman'), findsOneWidget);
      expect(find.text('NEW'), findsOneWidget);
      expect(find.text('Tomat Sayur Blok C (Unggulan)'), findsOneWidget);
      expect(find.text('Lahan Timur - Bedeng 02'), findsOneWidget);
    });
  });
}
