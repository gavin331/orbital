import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:orbital_appllergy/screens/FindFoods.dart';

Future<void> waitFor(WidgetTester tester, Finder finder) async {
  bool isFinished = false;

  Timer(const Duration(seconds: 30), () {
    isFinished = true;
  });

  while (!isFinished && finder.evaluate().isEmpty) {
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Find Allergen screen test', () {

    setUpAll(() async {
      await Firebase.initializeApp();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'yc@gmail.com',
        password: 'password',
      );
    });

    Future<void> enterText(WidgetTester tester, int index, String text) async {
      final textFieldFinder = find.byType(TextFormField);
      await tester.enterText(textFieldFinder.at(index), text);
      await tester.pumpAndSettle();
    }

    // Tap the Find Allergen button
    Future<void> tapFindFoodsButton(WidgetTester tester) async {
      final findFoodsButtonFinder = find.byKey(const Key('findFoodsButton'));
      await tester.tap(findFoodsButtonFinder);
    }

    // Tap the Add button
    Future<void> tapAddButton(WidgetTester tester) async {
      final addButtonFinder = find.byIcon(Icons.add);
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();
    }

    // Tap the Save button in the dialog
    Future<void> tapSaveButton(WidgetTester tester) async {
      final saveButtonFinder = find.text('Save');
      await tester.tap(saveButtonFinder);
      await tester.pumpAndSettle();
    }

    testWidgets('No TextFields are filled', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: FindFoods()));
      await tapFindFoodsButton(tester); // Tap the Find Allergen button
      await waitFor(tester, find.text('Possible Foods'));
      await waitFor(tester, find.text('No possible food found in the database!'));


      expect(find.text('Possible Foods'), findsOneWidget); // Check if the dialog is shown
      // Check if the dialog content contains the expected allergens or no common allergen found
      expect(find.text('No possible food found in the database!'), findsOneWidget);
    });

    testWidgets('Searching with filled text fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: FindFoods()));
      //This also tests for case insensitive search feature.
      await enterText(tester, 0, 'profilin');
      await tapAddButton(tester);
      await enterText(tester, 1, 'thaumatin-like');
      await tapFindFoodsButton(tester);
      await waitFor(tester, find.text('Possible Foods'));
      // Get the long string from the dialog
      final dialogTextFinder = find.byType(AlertDialog).first;
      final longString = tester.widget<AlertDialog>(dialogTextFinder).content.toString();

      // Use regular expressions to find specific substrings
      final appleFound = RegExp(r'\bapple\b').hasMatch(longString);
      final bananaFound = RegExp(r'\bbanana\b').hasMatch(longString);
      final oliveFound = RegExp(r'\bolive\b').hasMatch(longString);

      // Verify that the substrings are found in the long string
      expect(find.text('Possible Foods'), findsOneWidget);
      expect(appleFound, isTrue);
      expect(bananaFound, isTrue);
      expect(oliveFound, isTrue);
    });

    testWidgets('Searching with a mix of empty and filled text fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: FindFoods()));
      //This also tests for case insensitive search feature.
      await enterText(tester, 0, 'profilin');
      await tapAddButton(tester);
      await enterText(tester, 1, 'thaumatin-like');
      await tapAddButton(tester);
      await tapFindFoodsButton(tester);
      await waitFor(tester, find.text('Possible Foods'));
      // Get the long string from the dialog
      final dialogTextFinder = find.byType(AlertDialog).first;
      final longString = tester.widget<AlertDialog>(dialogTextFinder).content.toString();

      // Use regular expressions to find specific substrings
      final appleFound = RegExp(r'\bapple\b').hasMatch(longString);
      final bananaFound = RegExp(r'\bbanana\b').hasMatch(longString);
      final oliveFound = RegExp(r'\bolive\b').hasMatch(longString);

      // Verify that the substrings are found in the long string
      expect(find.text('Possible Foods'), findsOneWidget);
      expect(appleFound, isTrue);
      expect(bananaFound, isTrue);
      expect(oliveFound, isTrue);
    });

    testWidgets('Testing save button in alertdialog', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: FindFoods()));
      await enterText(tester, 0, 'profilin');
      await tapAddButton(tester);
      await enterText(tester, 1, 'thaumatin-like');
      await tapFindFoodsButton(tester);
      await waitFor(tester, find.text('Possible Foods'));
      await tapSaveButton(tester);
      await waitFor(tester, find.text('Saved to User Profile Successfully'));
      //TODO: Verify that the data is saved to FireStore.

      // Verify that the SnackBar is shown
      expect(find.text('Saved to User Profile Successfully'), findsOneWidget);
    });

  });
}
