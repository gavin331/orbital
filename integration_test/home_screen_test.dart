import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:orbital_appllergy/screens/CheckFood.dart';
import 'package:orbital_appllergy/screens/FindAllergen.dart';
import 'package:orbital_appllergy/screens/FindFoods.dart';
import 'package:orbital_appllergy/screens/HomePage.dart';
import 'package:orbital_appllergy/screens/LogSymptoms.dart';

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

  group('Home Screen UI test', () {

    setUpAll(() async {
      await Firebase.initializeApp();
    });

    testWidgets(
      'Home screen UI is displayed properly',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: HomePage()));
        await tester.pumpAndSettle();
        final Finder sideMenuIcon = find.byIcon(Icons.menu);
        final Finder findAllergenButton = find.text('    Find\nallergen');
        final Finder findFoodsButton = find.text(' Find\nfoods');
        final Finder checkFoodButton = find.text('Check\n  food');
        final Finder logSymptomsButton = find.text('       Log\nsymptoms');
        expect(sideMenuIcon, findsOneWidget);
        expect(findAllergenButton, findsOneWidget);
        expect(findFoodsButton, findsOneWidget);
        expect(checkFoodButton, findsOneWidget);
        expect(logSymptomsButton, findsOneWidget);
      },
    );

    testWidgets(
      'Test whether SideMenu can be properly opened',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: HomePage()));
        await tester.pumpAndSettle();
        final Finder sideMenuIcon = find.byIcon(Icons.menu);
        await tester.tap(sideMenuIcon);
        await tester.pumpAndSettle();
        await waitFor(tester, find.byType(Drawer));
        expect(find.byType(Drawer), findsOneWidget);
      },
    );
    
    testWidgets(
      'Navigate to the find allergens screen ',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: HomePage()));
        await tester.pumpAndSettle();
        final Finder findAllergenTextButton = find.text('    Find\nallergen');
        await tester.tap(findAllergenTextButton);
        await waitFor(tester, find.byType(FindAllergen));
        expect(find.byType(FindAllergen), findsOneWidget);
      },
    );

    testWidgets(
      'Navigate to the find foods screen ',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: HomePage()));
        await tester.pumpAndSettle();
        final Finder findFoodTextButton = find.text(' Find\nfoods');
        await tester.tap(findFoodTextButton);
        await waitFor(tester, find.byType(FindFoods));
        expect(find.byType(FindFoods), findsOneWidget);
      },
    );

    testWidgets(
      'Navigate to the check food screen ',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: HomePage()));
        await tester.pumpAndSettle();
        final Finder checkFoodTextButton = find.text('Check\n  food');
        await tester.tap(checkFoodTextButton);
        await waitFor(tester, find.byType(CheckFood));
        expect(find.byType(CheckFood), findsOneWidget);
      },
    );

    testWidgets(
      'Navigate to the log symptoms screen ',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: HomePage()));
        await tester.pumpAndSettle();
        final Finder logSymptomsTextButton = find.text('       Log\nsymptoms');
        await tester.tap(logSymptomsTextButton);
        await waitFor(tester, find.byType(LogSymptoms));
        expect(find.byType(LogSymptoms), findsOneWidget);
      },
    );

});
}