import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mytimo/models/plant_model.dart';
import 'package:mytimo/providers/auth_provider.dart';
import 'package:mytimo/providers/dashboard_provider.dart';
import 'package:mytimo/providers/navigation_provider.dart';
import 'package:mytimo/providers/plant_provider.dart';
import 'package:mytimo/screens/plant_list/plant_detail_screen.dart';
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

  Widget buildTestablePlantDetailScreen({
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
          home: PlantDetailScreen(plant: plant),
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

  group('PlantDetailScreen Figma Compliance & Functionality Tests', () {
    testWidgets('Renders all Figma plant_detail elements on 390x844',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestablePlantDetailScreen());
      await tester.pumpAndSettle();

      // 1. Top action icons (Back, Edit, Favorit)
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);

      // 2. Plant title & subtitle
      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
      expect(find.text('Cherry Tropis • Umur 63 HST'), findsOneWidget);

      // 3. Status badge
      expect(find.text('Early Blight • Dalam Rawat'), findsOneWidget);

      // 4. Tabs
      expect(find.text('Ringkasan'), findsOneWidget);
      expect(find.text('Riwayat'), findsAtLeastNWidgets(1));
      expect(find.text('Rencana'), findsOneWidget);
      expect(find.text('Monitor'), findsAtLeastNWidgets(1));

      // 5. 4 Info cards
      expect(find.text('Lokasi'), findsOneWidget);
      expect(find.text('Greenhouse 1 • Rak B3'), findsOneWidget);

      expect(find.text('Ditanam'), findsOneWidget);
      expect(find.text('05 Agu 2026'), findsOneWidget);

      expect(find.text('Varietas'), findsOneWidget);
      expect(find.text('Cherry Tropis'), findsOneWidget);

      expect(find.text('Skor Sehat'), findsOneWidget);
      expect(find.text('88% • Membaik'), findsOneWidget);

      // 6. Scan Terakhir header and card
      expect(find.text('Scan Terakhir'), findsOneWidget);
      expect(find.text('Lihat Semua'), findsOneWidget);
      expect(find.text('06 Okt 2026, 14:20'), findsOneWidget);
      expect(find.text('Early Blight • 94.2% akurat'), findsOneWidget);

      // 7. Buttons
      expect(find.text('Pindai Daun Tanaman Ini'), findsOneWidget);
      expect(find.text('Hapus Riwayat Scan Ini'), findsOneWidget);

      // 8. Bottom Navigation Bar
      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Tanaman'), findsAtLeastNWidgets(1));
      expect(find.text('Pindai'), findsAtLeastNWidgets(1));
    });

    testWidgets('Renders without overflow on compact 360x640 screen',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestablePlantDetailScreen(screenSize: const Size(360, 640)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
      expect(find.text('Pindai Daun Tanaman Ini'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Tapping favorite icon toggles favorite state and shows feedback',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestablePlantDetailScreen());
      await tester.pumpAndSettle();

      // Initially not favorite
      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);

      // Tap favorite icon
      await tester.tap(find.byIcon(Icons.favorite_border_rounded));
      await tester.pumpAndSettle();

      // Now favorite
      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
      expect(find.text('Ditambahkan ke tanaman favorit'), findsOneWidget);
    });

    testWidgets('Tapping tabs switches active tab content', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestablePlantDetailScreen());
      await tester.pumpAndSettle();

      // Tap 'Rencana'
      await tester.tap(find.text('Rencana'));
      await tester.pumpAndSettle();

      expect(find.text('Modul Rencana'), findsOneWidget);

      // Tap 'Ringkasan' back
      await tester.tap(find.text('Ringkasan'));
      await tester.pumpAndSettle();

      expect(find.text('Scan Terakhir'), findsOneWidget);
    });

    testWidgets('Tapping Pindai Daun Tanaman Ini opens scan modal',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestablePlantDetailScreen());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Pindai Daun Tanaman Ini'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pindai Daun Tanaman Ini'));
      await tester.pumpAndSettle();

      expect(find.text('Pindai Daun Tomat Cherry Blok A'), findsOneWidget);
      expect(find.text('Buka Kamera'), findsOneWidget);
    });

    testWidgets(
        'Tapping Hapus Riwayat Scan Ini shows Figma DeletePlantDialog and confirms delete',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final plantProvider = PlantProvider();
      await tester.pumpWidget(buildTestablePlantDetailScreen(
        customPlantProvider: plantProvider,
      ));
      await tester.pumpAndSettle();

      // Verify plant exists in provider
      expect(plantProvider.plants.any((p) => p.id == 'plt_01'), isTrue);

      // Tap Hapus Riwayat Scan Ini
      await tester.ensureVisible(find.text('Hapus Riwayat Scan Ini'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hapus Riwayat Scan Ini'));
      await tester.pumpAndSettle();

      // Figma DeletePlantDialog appears
      expect(find.text('Hapus Data Tanaman?'), findsOneWidget);
      expect(
        find.text('Apakah anda yakin ingin menghapus\ndata tanaman ini'),
        findsOneWidget,
      );
      expect(find.text('Batal'), findsOneWidget);
      expect(find.text('Hapus'), findsOneWidget);

      // Tap Hapus
      await tester.tap(find.text('Hapus'));
      await tester.pumpAndSettle();

      // Plant deleted from provider
      expect(plantProvider.plants.any((p) => p.id == 'plt_01'), isFalse);
    });

    testWidgets(
        'Tapping Batal in DeletePlantDialog dismisses dialog without deleting',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final plantProvider = PlantProvider();
      await tester.pumpWidget(buildTestablePlantDetailScreen(
        customPlantProvider: plantProvider,
      ));
      await tester.pumpAndSettle();

      // Tap Hapus Riwayat Scan Ini
      await tester.ensureVisible(find.text('Hapus Riwayat Scan Ini'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hapus Riwayat Scan Ini'));
      await tester.pumpAndSettle();

      expect(find.text('Hapus Data Tanaman?'), findsOneWidget);

      // Tap Batal
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      // Dialog dismissed, plant still in provider
      expect(find.text('Hapus Data Tanaman?'), findsNothing);
      expect(plantProvider.plants.any((p) => p.id == 'plt_01'), isTrue);
    });

    testWidgets('Tapping plant card in PlantListScreen navigates to PlantDetailScreen',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestablePlantListFlow());
      await tester.pumpAndSettle();

      // Tap 'Tomat Cherry Blok A'
      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
      await tester.tap(find.text('Tomat Cherry Blok A'));
      await tester.pumpAndSettle();

      // Verify on PlantDetailScreen
      expect(find.text('Cherry Tropis • Umur 63 HST'), findsOneWidget);
      expect(find.text('Pindai Daun Tanaman Ini'), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      // Verify back on PlantListScreen
      expect(find.text('Daftar Tanaman'), findsOneWidget);
    });
  });
}
