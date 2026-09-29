import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mytimo/main.dart';
import 'package:mytimo/screens/auth/login_screen.dart';
import 'package:mytimo/screens/catatan_form_screen.dart';
import 'package:mytimo/screens/not_found_screen.dart';
import 'package:mytimo/utils/validators.dart';

void main() {
  group('Validators Unit Tests (Langkah 3 & 4)', () {
    test('requiredField validator', () {
      expect(Validators.requiredField(''), 'Field ini wajib diisi');
      expect(Validators.requiredField(null), 'Field ini wajib diisi');
      expect(Validators.requiredField('ada'), isNull);
    });

    test('email validator', () {
      expect(Validators.email(''), 'Email wajib diisi');
      expect(Validators.email('abc'), 'Format email tidak valid');
      expect(Validators.email('user@mail.com'), isNull);
    });

    test('password validator', () {
      expect(Validators.password(''), 'Password wajib diisi');
      expect(Validators.password('123'), 'Password minimal 8 karakter');
      expect(Validators.password('12345678'), isNull);
    });

    test('minLength validator', () {
      expect(
        Validators.minLength('ab', 5, fieldName: 'Catatan'),
        'Catatan minimal 5 karakter',
      );
      expect(
        Validators.minLength('abcde', 5, fieldName: 'Catatan'),
        isNull,
      );
    });
  });

  group('Latihan 2 Flow & Navigation Tests (Langkah 4, 6, 8, 9)', () {
    testWidgets('1. Login dengan isian salah menampilkan pesan error', (tester) async {
      await tester.pumpWidget(const MyTimoApp());
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);

      // Tekan tombol Masuk tanpa mengisi apa pun
      await tester.tap(find.text('Masuk'));
      await tester.pumpAndSettle();

      expect(find.text('Email wajib diisi'), findsOneWidget);
      expect(find.text('Password wajib diisi'), findsOneWidget);
    });

    testWidgets('2. Format email salah & password < 8 karakter menampilkan error validator', (tester) async {
      await tester.pumpWidget(const MyTimoApp());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'abc');
      await tester.enterText(textFields.at(1), '123');

      await tester.tap(find.text('Masuk'));
      await tester.pumpAndSettle();

      expect(find.text('Format email tidak valid'), findsOneWidget);
      expect(find.text('Password minimal 8 karakter'), findsOneWidget);
    });

    testWidgets('3. Form Catatan screen can validate and return note', (tester) async {
      String? returnedNote;
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (ctx) => Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    returnedNote = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(builder: (_) => const CatatanFormScreen()),
                    );
                  },
                  child: const Text('Buka'),
                ),
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buka'));
      await tester.pumpAndSettle();

      expect(find.byType(CatatanFormScreen), findsOneWidget);

      // Tap Simpan tanpa isian
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();
      expect(find.text('Catatan wajib diisi'), findsOneWidget);

      // Isi < 5 karakter
      await tester.enterText(find.byType(TextFormField), 'tes');
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();
      expect(find.text('Catatan minimal 5 karakter'), findsOneWidget);

      // Isi valid
      await tester.enterText(find.byType(TextFormField), 'Catatan penting');
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();

      expect(returnedNote, 'Catatan penting');
    });

    testWidgets('4. 404 NotFoundScreen is displayed for unknown routes', (tester) async {
      await tester.pumpWidget(const MyTimoApp());
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(LoginScreen));
      Navigator.pushNamed(context, '/tidak-ada');
      await tester.pumpAndSettle();

      expect(find.byType(NotFoundScreen), findsOneWidget);
      expect(find.text('404'), findsOneWidget);
    });
  });
}
