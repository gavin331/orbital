import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:orbital_appllergy/screens/CheckFood.dart';
import 'package:orbital_appllergy/screens/LogSymptoms.dart';

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

  group('Log symptoms feature test', () {
    setUpAll(() async {
      await Firebase.initializeApp();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'yc@gmail.com',
        password: 'password',
      );
    });

    //Note: This data will appear in FireStore whenever this test runs.
    testWidgets('Log Symptoms feature Test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: LogSymptoms(),
      ));

      // Verify that the initial date on the screen displays the current date.
      DateTime currentDate = DateTime.now();
      String expectedDateText =
          'Date of occurrence: ${currentDate.day}/${currentDate.month}/${currentDate.year}';
      expect(find.text('Log Symptoms'), findsOneWidget);
      expect(find.text(expectedDateText), findsOneWidget);

      final Finder titleTextField = find.byType(TextFormField).at(0);
      final Finder symptomsTextField = find.byType(TextFormField).at(1);
      final Finder precautionsTextField = find.byType(TextFormField).at(2);

      //Ensure that all the text fields are present
      expect(titleTextField, findsOneWidget);
      expect(symptomsTextField, findsOneWidget);
      expect(precautionsTextField, findsOneWidget);


      // Enter data into the text fields.
      await tester.enterText(titleTextField, 'Headache');
      await tester.enterText(symptomsTextField, 'Sneezing and watery eyes');
      await tester.enterText(precautionsTextField, 'Avoid allergens');


      // Ensure that the select date button works
      tester.ensureVisible(find.text('Select Date'));
      expect(find.text('Select Date'), findsOneWidget);
      await tester.tap(find.text('Select Date'));
      await tester.pumpAndSettle();

      // Tap the OK button on the date picker dialog to close it
      expect(find.text('OK'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();


      // Tap the Submit button.
      tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(seconds: 1));
      }

      // Verify that the success dialog is shown.
      expect(find.text('Good news!'), findsOneWidget);
      expect(find.text('Successfully logged symptoms!'), findsOneWidget);

    });

  });
}