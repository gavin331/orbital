import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:orbital_appllergy/screens/CheckFood.dart';

Future<void> waitFor(WidgetTester tester, Finder finder) async {
  bool isFinished = false;

  Timer(const Duration(seconds: 10), () {
    isFinished = true;
  });

  while (!isFinished && finder.evaluate().isEmpty) {
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Check Food feature test', () {
    setUpAll(() async {
      await Firebase.initializeApp();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'yc@gmail.com',
        password: 'password',
      );
    });

    //Cannot use tester.pumpandsettle here because it doesn't work with awesome dialog package since
    //awesome dialog is an animated dialog.

    testWidgets('User presses find out without typing anything into the text field', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CheckFood()));
      await tester.pumpAndSettle();

      // Also tests for case insensitivity.
      await tester.tap(find.text('Find out'));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text('Oops!'), findsOneWidget);
    });

    testWidgets('The food is present in the user profile', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CheckFood()));
      await tester.pumpAndSettle();

      // Also tests for case insensitivity.
      await tester.enterText(find.byType(TextFormField), 'OLIVE'); // Replace the text with your test food name.
      await tester.tap(find.text('Find out'));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text('Warning'), findsOneWidget);
    });

    testWidgets('The food is not present in the user profile', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(home: CheckFood())); // Replace MyApp with the widget holding CheckFood widget.

      // Also tests for case insensitivity.
      await tester.enterText(find.byType(TextFormField), 'OLIVEssss'); // Replace the text with your test food name.
      await tester.tap(find.text('Find out'));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text('Not Found!'), findsOneWidget);
    });
  });
}