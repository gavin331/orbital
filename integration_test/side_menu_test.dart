import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:orbital_appllergy/screens/HomePage.dart';
import 'package:orbital_appllergy/screens/LinkedAccounts.dart';
import 'package:orbital_appllergy/screens/SideMenu.dart';
import 'package:orbital_appllergy/screens/SignIn.dart';
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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Side Menu test', () {

    setUpAll(() async {
      await Firebase.initializeApp();
      // Sign in with an existing Firebase account
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'yc@gmail.com',
        password: 'password',
      );
    });

    testWidgets('SideMenu displays menu items', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: SideMenu(),
        ),
      );
      final Finder userProfileButton = find.text('User Profile');
      final Finder emergencySettingsButton = find.text('Emergency Settings');
      final Finder linkedAccountsButton = find.text('Linked Accounts');
      final Finder logoutButton = find.text('Log Out');

      expect(userProfileButton, findsOneWidget);
      expect(emergencySettingsButton, findsOneWidget);
      expect(linkedAccountsButton, findsOneWidget);
      expect(logoutButton, findsOneWidget);
    });

    testWidgets('Navigate to user profile screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SideMenu(),
        ),
      );

      final Finder userProfileButton = find.text('User Profile');
      await tester.tap(userProfileButton);
      await waitFor(tester, find.byType(UserProfile));
      expect(find.byType(UserProfile), findsOneWidget);
    });

    testWidgets('Navigate to linked accounts screen',
            (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SideMenu(),
        ),
      );
      final Finder linkedAccountsButton = find.text('Linked Accounts');
      await tester.tap(linkedAccountsButton);
      await waitFor(tester, find.byType(LinkedAccounts));
      expect(find.byType(LinkedAccounts), findsOneWidget);
    });

    testWidgets('Log out button',
            (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomePage()));
      await tester.pumpAndSettle();
      final Finder sideMenuIcon = find.byIcon(Icons.menu);
      await tester.tap(sideMenuIcon);
      await tester.pumpAndSettle();
      final Finder logOutButton = find.text('Log Out');
      await tester.tap(logOutButton);
      await tester.pumpAndSettle();
      await waitFor(tester, find.byType(SignIn));
      expect(find.byType(SignIn), findsOneWidget);
    });

  });
}
