import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbital_appllergy/screens/UserProfile.dart';

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
  group('User profile screen test', () {

    setUpAll(() async {
      await Firebase.initializeApp();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'yc@gmail.com',
        password: 'password',
      );
    });

    testWidgets('User Profile UI is displayed correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: UserProfile(),
      ));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.text('User Profile'), findsOneWidget);
      expect(find.text('Your Allergens'), findsOneWidget);
      expect(find.text('Allergenic Foods'), findsOneWidget);
      expect(find.text('Your Symptoms'), findsOneWidget);
    });

    testWidgets('Test for functionality of Your allergens tab', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: UserProfile(),
      ));
      await tester.pumpAndSettle();
      final Finder yourAllergensTab = find.text('Your Allergens');
      await tester.tap(yourAllergensTab);
      await tester.pumpAndSettle();
      // After tapping the tab, verify that the correct tab is selected.
      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller?.index, 0); // The index of the "Allergenic Foods" tab is 1.

      // Test whether the tab content is scrollable.
      final listView = find.byKey(const Key('yourAllergensListView'));
      expect(tester.widget<ListView>(listView).physics, isA<AlwaysScrollableScrollPhysics>());
    });

    testWidgets('Test for functionality of Allergenic Foods tab', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: UserProfile(),
      ));
      await tester.pumpAndSettle();
      final Finder allergenicFoodsTab = find.text('Allergenic Foods');
      await tester.tap(allergenicFoodsTab);
      await tester.pumpAndSettle();
      // After tapping the tab, verify that the correct tab is selected.
      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller?.index, 1); // The index of the "Allergenic Foods" tab is 1.

      // Test whether the tab content is scrollable.
      final listView = find.byKey(const Key('allergenicFoodsListView'));
      expect(tester.widget<ListView>(listView).physics, isA<AlwaysScrollableScrollPhysics>());
    });

    testWidgets('Test for functionality of Your Symptoms tab', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: UserProfile(),
      ));
      await tester.pumpAndSettle();
      final Finder yourSymptomsTab = find.text('Your Symptoms');
      await tester.ensureVisible(yourSymptomsTab);
      await tester.tap(yourSymptomsTab);
      await tester.pumpAndSettle();
      // After tapping the tab, verify that the correct tab is selected.
      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller?.index, 2); // The index of the "Allergenic Foods" tab is 1.

      // Test whether the tab content is scrollable.
      final listView = find.byKey(const Key('yourSymptomsListView'));
      expect(tester.widget<ListView>(listView).physics, isA<AlwaysScrollableScrollPhysics>());
    });

    testWidgets('Test for UI of alertdialog when edit icon is tapped', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: UserProfile(),
      ));
      await tester.pumpAndSettle();
      final Finder editIcon = find.byIcon(Icons.edit);
      await tester.tap(editIcon);
      await tester.pumpAndSettle();
      expect(find.text('Pick image from: '), findsOneWidget);
      expect(find.text('Camera'), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);
    });
  });
}