import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mytimo/providers/navigation_provider.dart';
import 'package:mytimo/providers/plant_provider.dart';
import 'package:mytimo/screens/scan/photo_preview_screen.dart';

void main() {
  Widget buildTestablePhotoPreviewScreen({
    String? imagePath,
    String? plantName,
    String? leafConditionNotes,
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
          home: PhotoPreviewScreen(
            imagePath: imagePath,
            plantName: plantName,
            leafConditionNotes: leafConditionNotes,
          ),
        ),
      ),
    );
  }

  group('PhotoPreviewScreen Figma Pratinjau_Foto Tests', () {
    testWidgets('Renders all Figma Pratinjau_Foto UI elements on 390x844',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestablePhotoPreviewScreen());
      await tester.pump();

      // 1. Header Gradient & Title
      expect(find.text('Pratinjau Foto Daun'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      // 2. Leaf Photo Card Image
      expect(find.byType(Image), findsWidgets);

      // 3. Status Banner: Kualitas Citra Memenuhi Syarat
      expect(find.text('Kualitas Citra Memenuhi Syarat'), findsOneWidget);
      expect(
        find.text('Resolusi 1080×1080 • Format JPEG • Fokus Daun Baik'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);

      // 4. Form Input: Hubungkan ke Tanaman *
      expect(find.text('Hubungkan ke Tanaman *'), findsOneWidget);
      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);

      // 5. Form Input: Catatan Kondisi Daun
      expect(find.text('Catatan Kondisi Daun'), findsOneWidget);
      expect(
        find.text('Bercak cincin kecokelatan di daun bawah ke-3'),
        findsOneWidget,
      );

      // 6. Action Buttons
      expect(find.text('Foto Ulang'), findsOneWidget);
      expect(find.text('Lanjut Diagnosis AI'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);

      // 7. BottomNavBar Tabs
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

      await tester.pumpWidget(buildTestablePhotoPreviewScreen(
        screenSize: const Size(360, 640),
      ));
      await tester.pump();

      expect(find.text('Pratinjau Foto Daun'), findsOneWidget);
      expect(find.text('Kualitas Citra Memenuhi Syarat'), findsOneWidget);
      expect(find.text('Hubungkan ke Tanaman *'), findsOneWidget);
      expect(find.text('Catatan Kondisi Daun'), findsOneWidget);
      expect(find.text('Foto Ulang'), findsOneWidget);
      expect(find.text('Lanjut Diagnosis AI'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Tapping Foto Ulang pops screen', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => NavigationProvider()),
            ChangeNotifierProvider(create: (_) => PlantProvider()),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => const PhotoPreviewScreen(),
                    ),
                  );
                },
                child: const Text('Open Preview'),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Tap Open Preview
      await tester.tap(find.text('Open Preview'));
      await tester.pumpAndSettle();

      expect(find.text('Pratinjau Foto Daun'), findsOneWidget);

      // Tap Foto Ulang
      await tester.tap(find.text('Foto Ulang'));
      await tester.pumpAndSettle();

      expect(find.text('Pratinjau Foto Daun'), findsNothing);
      expect(find.text('Open Preview'), findsOneWidget);
    });

    testWidgets(
        'Tapping Hubungkan ke Tanaman opens modal and selecting plant updates name',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestablePhotoPreviewScreen());
      await tester.pump();

      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);

      // Tap plant selector
      await tester.tap(find.text('Tomat Cherry Blok A'));
      await tester.pumpAndSettle();

      expect(find.text('Pilih Tanaman Terhubung'), findsOneWidget);

      // Select another plant: 'Tomat Servo Bedeng 1'
      expect(find.text('Tomat Servo Bedeng 1'), findsOneWidget);
      await tester.tap(find.text('Tomat Servo Bedeng 1'));
      await tester.pumpAndSettle();

      // Modal closed, value updated
      expect(find.text('Pilih Tanaman Terhubung'), findsNothing);
      expect(find.text('Tomat Servo Bedeng 1'), findsOneWidget);
    });

    testWidgets('Editing Catatan Kondisi Daun updates text field',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestablePhotoPreviewScreen());
      await tester.pump();

      final notesFinder = find.byType(TextField);
      expect(notesFinder, findsOneWidget);

      await tester.enterText(
          notesFinder, 'Daun mulai menguning di bagian tepi bawah');
      await tester.pump();

      expect(
        find.text('Daun mulai menguning di bagian tepi bawah'),
        findsOneWidget,
      );
    });

    testWidgets(
        'Tapping Lanjut Diagnosis AI processes and displays Diagnosis Result modal',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestablePhotoPreviewScreen(
        plantName: 'Tomat Cherry Blok A',
      ));
      await tester.pump();

      // Tap Lanjut Diagnosis AI
      await tester.tap(find.text('Lanjut Diagnosis AI'));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Diagnosis Result Modal appears
      expect(find.text('Hasil Diagnosis Tomat Cherry Blok A'), findsOneWidget);
      expect(find.text('Penyakit Terdeteksi: Early Blight'), findsOneWidget);
      expect(find.text('Simpan Hasil'), findsOneWidget);
      expect(find.text('Tutup'), findsOneWidget);

      // Tap Tutup
      await tester.tap(find.text('Tutup'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Penyakit Terdeteksi: Early Blight'), findsNothing);
    });
  });
}
