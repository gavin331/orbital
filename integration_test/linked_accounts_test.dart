import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbital_appllergy/screens/LinkedAccounts.dart';

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
  group('Linked Accounts Feature test', () {
    setUpAll(() async {
      await Firebase.initializeApp();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'yc@gmail.com',
        password: 'password',
      );
    });

    testWidgets('Linked Accounts UI is displayed correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: LinkedAccounts(),
      ));
      await tester.pumpAndSettle();
      // Ensure that the initial tab is 'Friends'
      expect(find.text('Linked Accounts'), findsOneWidget);
      expect(find.text('Friends'), findsOneWidget);
      expect(find.text('Friend Requests'), findsOneWidget);
    });

    testWidgets('Test for functionality of Friends tab', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: LinkedAccounts(),
      ));
      await tester.pumpAndSettle();
      final Finder friendsTab = find.text('Friends');
      await tester.tap(friendsTab);
      await tester.pumpAndSettle();
      // After tapping the tab, verify that the correct tab is selected.
      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller?.index, 0);

      // Test whether the tab content is scrollable.
      final listView = find.byKey(const Key('friendList'));
      expect(tester.widget<ListView>(listView).physics, isA<AlwaysScrollableScrollPhysics>());
    });

    testWidgets('Test for functionality of Friend Requests tab', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: LinkedAccounts(),
      ));
      await tester.pumpAndSettle();
      final Finder friendRequestTab = find.text('Friend Requests');
      await tester.tap(friendRequestTab);
      await tester.pumpAndSettle();
      // After tapping the tab, verify that the correct tab is selected.
      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller?.index, 1);

      // Test whether the tab content is scrollable.
      final listView = find.byKey(const Key('friendRequestList'));
      expect(tester.widget<ListView>(listView).physics, isA<AlwaysScrollableScrollPhysics>());
    });

    testWidgets('Test for UI of alertdialog when add icon is pressed', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: LinkedAccounts(),
      ));
      await tester.pumpAndSettle();
      final Finder addIcon = find.byIcon(Icons.add);
      await tester.tap(addIcon);
      await tester.pumpAndSettle();
      //Check that alert dialog pops up
      expect(find.text('Send Friend Request'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      //Check that alert dialog closes
      await tester.pumpAndSettle();
      expect(find.text('Send Friend Request'), findsNothing);
    });
  });
}