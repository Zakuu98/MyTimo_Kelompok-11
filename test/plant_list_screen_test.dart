import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mytimo/providers/auth_provider.dart';
import 'package:mytimo/providers/dashboard_provider.dart';
import 'package:mytimo/providers/navigation_provider.dart';
import 'package:mytimo/providers/plant_provider.dart';
import 'package:mytimo/screens/main_navigation_screen.dart';
import 'package:mytimo/screens/plant_list/plant_list_screen.dart';
import 'package:mytimo/screens/plant_list/widgets/plant_card_item.dart';
import 'package:mytimo/screens/plant_list/widgets/plant_empty_state.dart';

void main() {
  Widget buildTestablePlantListScreen({
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
          home: PlantListScreen(),
        ),
      ),
    );
  }

  Widget buildTestableApp({
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

  group('PlantListScreen Figma Compliance & Functionality Tests', () {
    testWidgets('Renders all Figma dummy data list elements on 390x844',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestablePlantListScreen());
      await tester.pumpAndSettle();

      // 1. Header elements
      expect(find.text('Daftar Tanaman'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Cari nama tanaman atau blok…'), findsOneWidget);

      // 2. Filter Chips
      expect(find.text('Semua (4)'), findsOneWidget);
      expect(find.text('Sehat'), findsAtLeastNWidgets(1));
      expect(find.text('Perlu Rawat'), findsOneWidget);
      expect(find.text('Parah'), findsOneWidget);

      // 3. Plant Cards (Dummy Data)
      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
      expect(find.text('Cherry Tropis • 63 HST'), findsOneWidget);
      expect(find.text('Greenhouse 1 • Rak B3'), findsOneWidget);
      expect(find.text('Early Blight'), findsOneWidget);

      expect(find.text('Tomat Servo Bedeng 1'), findsOneWidget);
      expect(find.text('Servo F1 • 25 HST'), findsOneWidget);
      expect(find.text('Lahan Terbuka • Bedeng 01'), findsOneWidget);

      expect(find.text('Tomat Mawar Bedeng 4'), findsOneWidget);
      expect(find.text('Mawar Lokal • 50 HST'), findsOneWidget);
      expect(find.text('Late Blight'), findsOneWidget);

      expect(find.text('Tomat Sayur Blok C'), findsOneWidget);
      expect(find.text('Gustavi F1 • 22 HST'), findsOneWidget);

      // 4. Floating Action Button (+)
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    });

    testWidgets('Renders without overflow on compact 360x640 screen',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestablePlantListScreen(screenSize: const Size(360, 640)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Daftar Tanaman'), findsOneWidget);
      expect(find.byType(PlantCardItem), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Filter chips accurately filter plant items', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestablePlantListScreen());
      await tester.pumpAndSettle();

      // Tap 'Sehat'
      await tester.tap(find.text('Sehat').first);
      await tester.pumpAndSettle();

      expect(find.text('Tomat Servo Bedeng 1'), findsOneWidget);
      expect(find.text('Tomat Sayur Blok C'), findsOneWidget);
      expect(find.text('Tomat Cherry Blok A'), findsNothing);
      expect(find.text('Tomat Mawar Bedeng 4'), findsNothing);

      // Tap 'Perlu Rawat'
      await tester.tap(find.text('Perlu Rawat'));
      await tester.pumpAndSettle();

      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
      expect(find.text('Tomat Servo Bedeng 1'), findsNothing);

      // Tap 'Parah'
      await tester.ensureVisible(find.text('Parah'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Parah'));
      await tester.pumpAndSettle();

      expect(find.text('Tomat Mawar Bedeng 4'), findsOneWidget);
      expect(find.text('Tomat Cherry Blok A'), findsNothing);

      // Tap 'Semua (4)' to reset
      await tester.ensureVisible(find.text('Semua (4)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Semua (4)'));
      await tester.pumpAndSettle();

      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
      expect(find.text('Tomat Servo Bedeng 1'), findsOneWidget);
    });

    testWidgets('Search input filters plant list by name and location',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestablePlantListScreen());
      await tester.pumpAndSettle();

      // Search "Servo"
      await tester.enterText(find.byType(TextField), 'Servo');
      await tester.pumpAndSettle();

      expect(find.text('Tomat Servo Bedeng 1'), findsOneWidget);
      expect(find.text('Tomat Cherry Blok A'), findsNothing);

      // Clear search
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
      expect(find.text('Tomat Servo Bedeng 1'), findsOneWidget);
    });

    testWidgets(
        'Empty State is displayed correctly when plants are empty (user baru / data dihapus)',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final emptyPlantProvider = PlantProvider()..clearAllPlants();

      await tester.pumpWidget(
        buildTestablePlantListScreen(customPlantProvider: emptyPlantProvider),
      );
      await tester.pumpAndSettle();

      // Verify Empty State elements
      expect(find.byType(PlantEmptyState), findsOneWidget);
      expect(find.text('Belum Ada Data Tanaman'), findsOneWidget);
      expect(
        find.textContaining('Tambahkan tanaman tomat pertama Anda'),
        findsOneWidget,
      );
      expect(find.text('+ Tambah Tanaman Baru'), findsOneWidget);
      expect(find.text('Semua (0)'), findsOneWidget);

      // FAB is hidden when list is empty
      expect(find.byIcon(Icons.add_rounded), findsNothing);
    });

    testWidgets('Adding a plant from Empty State transitions back to List State',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final emptyPlantProvider = PlantProvider()..clearAllPlants();

      await tester.pumpWidget(
        buildTestablePlantListScreen(customPlantProvider: emptyPlantProvider),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PlantEmptyState), findsOneWidget);

      // Tap "+ Tambah Tanaman Baru"
      await tester.tap(find.text('+ Tambah Tanaman Baru'));
      await tester.pumpAndSettle();

      // Verify AddPlantScreen appears
      expect(find.text('Tambah Tanaman'), findsOneWidget);

      // Fill in plant details
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Tomat Ranti Bedeng 5',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'Ranti Lokal',
      );
      await tester.enterText(
        find.byType(TextFormField).at(2),
        '15 September 2026',
      );
      await tester.enterText(
        find.byType(TextFormField).at(3),
        'Lahan Barat • Bedeng 05',
      );

      // Submit Form
      await tester.ensureVisible(find.text('Simpan Data Tanaman'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Simpan Data Tanaman'));
      await tester.pumpAndSettle();

      // Dismiss popup dialog
      expect(find.text('Data Tanaman Ditambahkan!'), findsOneWidget);
      await tester.tap(find.text('Lihat Daftar Tanaman'));
      await tester.pumpAndSettle();

      // Verify Empty State is gone and new plant card is rendered with NEW badge!
      expect(find.byType(PlantEmptyState), findsNothing);
      expect(find.text('Tomat Ranti Bedeng 5'), findsOneWidget);
      expect(find.text('Lahan Barat • Bedeng 05'), findsOneWidget);
      expect(find.text('Semua (1)'), findsOneWidget);
      expect(find.text('NEW'), findsOneWidget);
    });

    testWidgets('Navigation bar Tab "Tanaman" switches to PlantListScreen',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableApp());
      await tester.pumpAndSettle();

      // Tap 'Tanaman' on BottomNavigationBar
      await tester.tap(find.text('Tanaman'));
      await tester.pumpAndSettle();

      expect(find.byType(PlantListScreen), findsOneWidget);
      expect(find.text('Daftar Tanaman'), findsOneWidget);
      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
    });
  });
}
