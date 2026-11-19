import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mytimo/screens/scan/scan_history_screen.dart';
import 'package:mytimo/widgets/delete_scan_history_dialog.dart';

void main() {
  Widget buildTestableDialog({
    ScanHistoryItem? item,
    String? diseaseName,
    double? confidence,
    String? plantName,
    String? dateTimeText,
    String? status,
    VoidCallback? onConfirm,
    Size screenSize = const Size(390, 844),
  }) {
    return MediaQuery(
      data: MediaQueryData(
        size: screenSize,
        padding: const EdgeInsets.only(top: 44, bottom: 34),
      ),
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () {
                  DeleteScanHistoryDialog.show(
                    context: context,
                    item: item,
                    diseaseName: diseaseName,
                    confidence: confidence,
                    plantName: plantName,
                    dateTimeText: dateTimeText,
                    status: status,
                    onConfirm: onConfirm,
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('DeleteScanHistoryDialog Figma Hapus_Riwayat Tests', () {
    testWidgets('Renders all Figma Hapus_Riwayat dialog elements on 390x844',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableDialog());
      await tester.pump();

      // Open dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // 1. Dialog Title & Subtitle
      expect(find.text('Hapus Riwayat Scan?'), findsOneWidget);
      expect(
        find.text('Apakah anda yakin ingin menghapus data riwayat pemindaian ini'),
        findsOneWidget,
      );

      // 2. Floating Trash Icon
      expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);

      // 3. Scan Preview Card
      expect(find.text('Early Blight (94.2%)'), findsOneWidget);
      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
      expect(find.text('06 Okt 2026, 14:20'), findsOneWidget);
      expect(find.text('Sedang'), findsOneWidget);

      // 4. Warning Section
      expect(find.text('Peringatan!'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      expect(
        find.text('Foto daun, hasil AI, dan catatan tidak dapat dipulihkan.'),
        findsOneWidget,
      );

      // 5. Action Buttons (Batal & Hapus)
      expect(find.text('Batal'), findsOneWidget);
      expect(find.text('Hapus'), findsOneWidget);
    });

    testWidgets(
        'Renders cleanly without overflow on compact 360x640 mobile screen',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableDialog(
        screenSize: const Size(360, 640),
      ));
      await tester.pump();

      // Open dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Hapus Riwayat Scan?'), findsOneWidget);
      expect(find.text('Early Blight (94.2%)'), findsOneWidget);
      expect(find.text('Hapus'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Tapping Batal dismisses dialog and does not trigger onConfirm',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool confirmed = false;
      await tester.pumpWidget(buildTestableDialog(
        onConfirm: () => confirmed = true,
      ));
      await tester.pump();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Hapus Riwayat Scan?'), findsOneWidget);

      // Tap Batal
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      expect(find.text('Hapus Riwayat Scan?'), findsNothing);
      expect(confirmed, isFalse);
    });

    testWidgets('Tapping Hapus triggers onConfirm and dismisses dialog',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool confirmed = false;
      await tester.pumpWidget(buildTestableDialog(
        onConfirm: () => confirmed = true,
      ));
      await tester.pump();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Hapus Riwayat Scan?'), findsOneWidget);

      // Tap Hapus
      await tester.tap(find.text('Hapus'));
      await tester.pumpAndSettle();

      expect(find.text('Hapus Riwayat Scan?'), findsNothing);
      expect(confirmed, isTrue);
    });

    testWidgets('Custom scan data renders with proper badge (Parah / Sehat)',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableDialog(
        diseaseName: 'Late Blight',
        confidence: 89.5,
        plantName: 'Tomat Mawar Bedeng 4',
        dateTimeText: '01 Okt 2026, 16:30',
        status: 'Parah',
      ));
      await tester.pump();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Late Blight (89.5%)'), findsOneWidget);
      expect(find.text('Tomat Mawar Bedeng 4'), findsOneWidget);
      expect(find.text('01 Okt 2026, 16:30'), findsOneWidget);
      expect(find.text('Parah'), findsOneWidget);
    });
  });
}
