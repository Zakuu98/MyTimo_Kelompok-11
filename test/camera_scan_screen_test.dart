import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mytimo/screens/scan/camera_scan_screen.dart';

void main() {
  Widget buildTestableCameraScanScreen({
    String? plantName,
    Size screenSize = const Size(390, 844),
  }) {
    return MediaQuery(
      data: MediaQueryData(
        size: screenSize,
        padding: const EdgeInsets.only(top: 44, bottom: 34),
      ),
      child: MaterialApp(
        home: CameraScanScreen(plantName: plantName),
      ),
    );
  }

  group('CameraScanScreen Figma Kamera_Scan Tests', () {
    testWidgets('Renders all Figma Kamera_Scan UI elements on 390x844',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableCameraScanScreen());
      await tester.pump();

      // 1. Top Bar Controls
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      expect(find.byIcon(Icons.flash_off_rounded), findsOneWidget);
      expect(find.byIcon(Icons.flip_camera_ios_rounded), findsOneWidget);

      // 2. Guide Chip
      expect(
        find.text('Arahkan pada 1 helai daun bergejala'),
        findsOneWidget,
      );

      // 3. Scanner Reticle CustomPaint
      expect(find.byType(CustomPaint), findsWidgets);

      // 4. Tips Chip
      expect(find.byIcon(Icons.lightbulb_outline_rounded), findsOneWidget);
      expect(
        find.text('Pastikan daun fokus & pencahayaan cukup'),
        findsOneWidget,
      );

      // 5. Bottom Controls
      expect(find.byIcon(Icons.photo_library_outlined), findsOneWidget);
      expect(find.text('?'), findsOneWidget);

      // Shutter Button exists
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('Renders cleanly without overflow on compact 360x640 mobile screen',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableCameraScanScreen(
        screenSize: const Size(360, 640),
      ));
      await tester.pump();

      expect(find.text('Arahkan pada 1 helai daun bergejala'), findsOneWidget);
      expect(find.text('Pastikan daun fokus & pencahayaan cukup'), findsOneWidget);
      expect(find.text('?'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Tapping Flash icon toggles flash state and shows feedback',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableCameraScanScreen());
      await tester.pump();

      expect(find.byIcon(Icons.flash_off_rounded), findsOneWidget);

      // Tap Flash
      await tester.tap(find.byIcon(Icons.flash_off_rounded));
      await tester.pump();

      expect(find.byIcon(Icons.flash_on_rounded), findsOneWidget);
      expect(find.text('Lampu kilat (Flash) aktif'), findsOneWidget);
    });

    testWidgets('Tapping Flip icon toggles camera and shows feedback',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableCameraScanScreen());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.flip_camera_ios_rounded));
      await tester.pump();

      expect(find.text('Beralih ke kamera depan'), findsOneWidget);
    });

    testWidgets('Tapping Bantuan (?) opens help dialog and closes on Mengerti',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableCameraScanScreen());
      await tester.pump();

      // Tap Help '?'
      await tester.tap(find.text('?'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Panduan Pemindaian AI'), findsOneWidget);
      expect(find.text('Mengerti'), findsOneWidget);

      // Tap Mengerti
      await tester.tap(find.text('Mengerti'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Panduan Pemindaian AI'), findsNothing);
    });

    testWidgets('Tapping Shutter button triggers scan and shows diagnosis modal',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableCameraScanScreen(
        plantName: 'Tomat Cherry Blok A',
      ));
      await tester.pump();

      // Tap center shutter button (Container with gradient/white circle)
      final shutterFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).shape == BoxShape.circle &&
            (widget.decoration as BoxDecoration).gradient != null,
      );
      expect(shutterFinder, findsOneWidget);

      await tester.tap(shutterFinder);
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Diagnosis Result Modal appears
      expect(find.text('Hasil Diagnosis Tomat Cherry Blok A'), findsOneWidget);
      expect(find.text('Penyakit Terdeteksi: Early Blight'), findsOneWidget);
      expect(find.text('Simpan Hasil'), findsOneWidget);
      expect(find.text('Pindai Lagi'), findsOneWidget);

      // Tap Pindai Lagi dismisses modal
      await tester.tap(find.text('Pindai Lagi'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Hasil Diagnosis Tomat Cherry Blok A'), findsNothing);
    });

    testWidgets('Tapping Galeri button shows gallery picker feedback',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableCameraScanScreen());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.photo_library_outlined));
      await tester.pump();

      expect(find.text('Membuka galeri foto perangkat...'), findsOneWidget);
    });
  });
}
