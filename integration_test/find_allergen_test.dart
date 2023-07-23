import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:orbital_appllergy/screens/FindAllergen.dart';

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
    Future<void> tapFindAllergenButton(WidgetTester tester) async {
      final findAllergenButtonFinder = find.byKey(const Key('findAllergenButton'));
      await tester.tap(findAllergenButtonFinder);
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
      await tester.pumpWidget(const MaterialApp(home: FindAllergen()));
      await tapFindAllergenButton(tester); // Tap the Find Allergen button
      await waitFor(tester, find.text('Possible Allergens'));
      await waitFor(tester, find.text('No common allergen found!'));


      expect(find.text('Possible Allergens'), findsOneWidget); // Check if the dialog is shown
      // Check if the dialog content contains the expected allergens or no common allergen found
      expect(find.text('No common allergen found!'), findsOneWidget);
    });

    testWidgets('Searching with filled text fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: FindAllergen()));
      //This also tests for case insensitive search feature.
      await enterText(tester, 0, 'apple');
      await tapAddButton(tester);
      await enterText(tester, 1, 'BaNaNa');
      await tapAddButton(tester);
      await enterText(tester, 2, 'OLIVE');
      await tapFindAllergenButton(tester); // Tap the Find Allergen button
      await waitFor(tester, find.text('Possible Allergens'));
      await waitFor(tester, find.text('thaumatin-like, profilin'));


      expect(find.text('Possible Allergens'), findsOneWidget); // Check if the dialog is shown
      // Check if the dialog content contains the expected allergens or no common allergen found
      expect(find.text('thaumatin-like, profilin'), findsOneWidget);
    });

    testWidgets('Searching with a mix of empty and filled TextFields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: FindAllergen()));
      await enterText(tester, 0, 'apple');
      await tapAddButton(tester);
      await enterText(tester, 1, 'BaNaNa');
      await tapAddButton(tester);
      await tapFindAllergenButton(tester); // Tap the Find Allergen button
      await waitFor(tester, find.text('Possible Allergens'));
      await waitFor(tester, find.text('thaumatin-like, profilin'));
      expect(find.text('Possible Allergens'), findsOneWidget);
      expect(find.text('thaumatin-like, profilin'), findsOneWidget);
    });

    testWidgets('Searching with food that has no common allergens', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: FindAllergen()));
      await enterText(tester, 0, 'brown garden snail');
      await tapAddButton(tester);
      await enterText(tester, 1, 'apple');
      await tapAddButton(tester);
      await tapFindAllergenButton(tester); // Tap the Find Allergen button
      await waitFor(tester, find.text('Possible Allergens'));
      await waitFor(tester, find.text('No common allergen found!'));
      expect(find.text('Possible Allergens'), findsOneWidget);
      expect(find.text('No common allergen found!'), findsOneWidget);
    });

    testWidgets('Searching with only 1 food', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: FindAllergen()));
      await enterText(tester, 0, 'apple');
      await tapFindAllergenButton(tester); // Tap the Find Allergen button
      await waitFor(tester, find.text('Possible Allergens'));
      await waitFor(tester, find.text('pathogenesis related protein, PR-10, Bet v 1-like, lipid transfer protein, thaumatin-like, profilin, gibberellin-regulated protein, partial from A0A498HTE5'));
      expect(find.text('Possible Allergens'), findsOneWidget);
      expect(find.text('pathogenesis related protein, PR-10, Bet v 1-like, lipid transfer protein, thaumatin-like, profilin, gibberellin-regulated protein, partial from A0A498HTE5'), findsOneWidget);
    });

    testWidgets('Testing save button in alertdialog', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: FindAllergen()));
      await enterText(tester, 0, 'apple');
      await tapAddButton(tester);
      await enterText(tester, 1, 'BaNaNa');
      await tapAddButton(tester);
      await enterText(tester, 2, 'OLIVE');
      await tapFindAllergenButton(tester);
      await waitFor(tester, find.text('Possible Allergens'));
      await waitFor(tester, find.text('thaumatin-like, profilin'));
      await tapSaveButton(tester);
      await waitFor(tester, find.text('Saved to User Profile Successfully'));

      // Verify that the data is saved to FireStore.
      // The user profile will then get the data from FireStore.
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final savedAllergens = userDoc['allergens'] as List<dynamic>;
      expect(savedAllergens, containsAll(['thaumatin-like', 'profilin']));
      // Verify that the SnackBar is shown
      expect(find.text('Saved to User Profile Successfully'), findsOneWidget);
    });

  });
}
