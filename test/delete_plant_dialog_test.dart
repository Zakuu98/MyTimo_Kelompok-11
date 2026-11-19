import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mytimo/widgets/delete_plant_dialog.dart';

void main() {
  Widget buildTestableDeleteDialog({
    String plantName = 'Tomat Cherry Blok A',
    Size screenSize = const Size(390, 844),
    VoidCallback? onConfirm,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () {
                DeletePlantDialog.show(
                  context: context,
                  plantName: plantName,
                  onConfirm: onConfirm,
                );
              },
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      ),
    );
  }

  group('DeletePlantDialog Figma plant_detail_Hapus Tests', () {
    testWidgets('Renders all Figma elements accurately on 390x844',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableDeleteDialog());
      await tester.pumpAndSettle();

      // Open dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // 1. Floating Trash Icon
      expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);

      // 2. Title & Message
      expect(find.text('Hapus Data Tanaman?'), findsOneWidget);
      expect(
        find.text('Apakah anda yakin ingin menghapus\ndata tanaman ini'),
        findsOneWidget,
      );

      // 3. Plant Name Pill
      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);

      // 4. Action Buttons
      expect(find.text('Batal'), findsOneWidget);
      expect(find.text('Hapus'), findsOneWidget);
    });

    testWidgets('No overflow on compact 360x640 mobile screen', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableDeleteDialog());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Hapus Data Tanaman?'), findsOneWidget);
      expect(find.text('Tomat Cherry Blok A'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Tapping Batal returns false and dismisses dialog',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableDeleteDialog());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Hapus Data Tanaman?'), findsOneWidget);

      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      expect(find.text('Hapus Data Tanaman?'), findsNothing);
    });

    testWidgets('Tapping Hapus returns true and invokes callback',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool confirmed = false;
      await tester.pumpWidget(buildTestableDeleteDialog(
        onConfirm: () => confirmed = true,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Hapus'));
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
      expect(find.text('Hapus Data Tanaman?'), findsNothing);
    });
  });
}
