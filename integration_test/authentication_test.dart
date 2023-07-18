import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:orbital_appllergy/main.dart' as app;
import 'package:orbital_appllergy/screens/HomePage.dart';
import 'package:orbital_appllergy/screens/Register.dart';
import 'package:orbital_appllergy/screens/SuccessfulRegistration.dart';
import 'dart:async';
import 'package:faker/faker.dart';

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

  group('Sign in screen test', () {
    testWidgets(
      'sign in with empty username and password',
          (WidgetTester tester) async {
        await app.main();
        await tester.pumpAndSettle();
        final Finder button = find.byKey(const Key('signInButton'));

        await tester.ensureVisible(button); //Scrolls down until the sign in button is visible
        await tester.tap(button);
        await waitFor(tester, find.text('Please enter an email'));
        await waitFor(tester, find.text('Please enter a password'));
        await waitFor(tester, find.text('Please fill in your details'));
        expect(find.text('Please enter an email'), findsOneWidget);
        expect(find.text('Please enter a password'), findsOneWidget);
        expect(find.text('Please fill in your details'), findsOneWidget);
      },
    );

    testWidgets(
      'sign in with empty email but correct password',
          (WidgetTester tester) async {
        await app.main();
        await tester.pumpAndSettle();
        final Finder passwordField = find.byKey(const Key('passwordTextField'));
        final Finder button = find.byKey(const Key('signInButton'));

        await tester.enterText(passwordField, 'password');
        await tester.pumpAndSettle();
        await tester.ensureVisible(button); //Scrolls down until the sign in button is visible
        await tester.tap(button);
        await waitFor(tester, find.text('Please enter an email'));
        await waitFor(tester, find.text('Please fill in your details'));
        expect(find.text('Please enter an email'), findsOneWidget);
        expect(find.text('Please fill in your details'), findsOneWidget);
      },
    );

    testWidgets(
      'sign in with empty password but correct email',
          (WidgetTester tester) async {
        await app.main();
        await tester.pumpAndSettle();
        final Finder emailField = find.byKey(const Key('emailTextField'));
        final Finder button = find.byKey(const Key('signInButton'));

        await tester.enterText(emailField, 'yc@gmail.com');
        await tester.pumpAndSettle();
        await tester.ensureVisible(button); //Scrolls down until the sign in button is visible
        await tester.tap(button);
        await waitFor(tester, find.text('Please enter a password'));
        await waitFor(tester, find.text('Please fill in your details'));
        expect(find.text('Please enter a password'), findsOneWidget);
        expect(find.text('Please fill in your details'), findsOneWidget);
      },
    );

    testWidgets(
      'sign in with incorrect email format but correct password',
          (WidgetTester tester) async {
        await app.main();
        await tester.pumpAndSettle();
        final Finder emailField = find.byKey(const Key('emailTextField'));
        final Finder passwordField = find.byKey(const Key('passwordTextField'));
        final Finder button = find.byKey(const Key('signInButton'));

        await tester.enterText(emailField, 'yc2@gm');
        await tester.enterText(passwordField, 'password');
        await tester.pumpAndSettle();
        await tester.ensureVisible(button); //Scrolls down until the sign in button is visible
        await tester.tap(button);
        await waitFor(tester, find.text('Please enter a valid email'));
        await waitFor(tester, find.text('Please fill in your details'));
        expect(find.text('Please enter a valid email'), findsOneWidget);
        expect(find.text('Please fill in your details'), findsOneWidget);
      },
    );

    testWidgets(
        'sign in with incorrect username but correct password',
        (WidgetTester tester) async {
          await app.main();
          await tester.pumpAndSettle();
          final Finder emailField = find.byKey(const Key('emailTextField'));
          final Finder passwordField = find.byKey(const Key('passwordTextField'));
          final Finder button = find.byKey(const Key('signInButton'));

          await tester.enterText(emailField, 'yc2@gmail.com');
          await tester.enterText(passwordField, 'password');
          await tester.pumpAndSettle();
          await tester.ensureVisible(button); //Scrolls down until the sign in button is visible
          await tester.tap(button);
          await waitFor(tester, find.text('Cannot find user'));
          expect(find.text('Cannot find user'), findsOneWidget);
        },
    );

    testWidgets(
      'sign in with incorrect password but correct username',
          (widgetTester) async {
        await app.main();
        await widgetTester.pumpAndSettle();
        final Finder emailField = find.byKey(const Key('emailTextField'));
        final Finder passwordField = find.byKey(const Key('passwordTextField'));
        final Finder button = find.byKey(const Key('signInButton'));

        await widgetTester.enterText(emailField, 'yc@gmail.com');
        await widgetTester.enterText(passwordField, 'password123');
        await widgetTester.pumpAndSettle();
        await widgetTester.ensureVisible(button);
        await widgetTester.tap(button);
        await waitFor(widgetTester, find.text('The password is invalid.'));
        expect(find.text('The password is invalid.'), findsOneWidget);
      },
    );

    testWidgets(
      'sign in with correct password and username',
          (widgetTester) async {
        await app.main();
        await widgetTester.pumpAndSettle();
        final Finder emailField = find.byKey(const Key('emailTextField'));
        final Finder passwordField = find.byKey(const Key('passwordTextField'));
        final Finder button = find.byKey(const Key('signInButton'));

        await widgetTester.enterText(emailField, 'yc@gmail.com');
        await widgetTester.enterText(passwordField, 'password');
        await widgetTester.pumpAndSettle();
        await widgetTester.ensureVisible(button);
        await widgetTester.tap(button);
        await waitFor(widgetTester, find.byType(HomePage));
        expect(find.byType(HomePage), findsOneWidget);
      },
    );

    testWidgets(
      'Pressing the register now text gesture detector',
          (widgetTester) async {
        await app.main();
        await widgetTester.pumpAndSettle();
        final Finder textGestureDetector = find.text('Register now!');

        await widgetTester.ensureVisible(textGestureDetector);
        await widgetTester.pumpAndSettle();
        await widgetTester.tap(textGestureDetector);
        await waitFor(widgetTester, find.byType(Register));
        expect(find.byType(Register), findsOneWidget);
      },
    );
  });

  group('Register feature test', () {

    setUpAll(() async {
      await Firebase.initializeApp();
    });

    testWidgets(
      'Users cannot sign up with a username that already exists',
          (WidgetTester tester) async {

        await tester.pumpWidget(const MaterialApp(home: Register()));
        await tester.pumpAndSettle();
        final Finder usernameField = find.byType(TextFormField).at(0);
        final Finder emailField = find.byType(TextFormField).at(1);
        final Finder passwordField = find.byType(TextFormField).at(2);
        final Finder confirmPasswordField = find.byType(TextFormField).at(3);
        final Finder button = find.byType(ElevatedButton);

        await tester.enterText(usernameField, 'yc');
        await tester.enterText(emailField, 'newacc@gmail.com');
        await tester.enterText(passwordField, 'password');
        await tester.enterText(confirmPasswordField, 'password');
        await tester.pumpAndSettle();
        await tester.ensureVisible(button);
        await tester.tap(button);

        await waitFor(tester, find.text('This username has already been taken'));
        expect(find.text('This username has already been taken'), findsOneWidget);
      },
    );

    testWidgets(
      'Users cannot sign up with an email that already exists',
          (WidgetTester tester) async {

        await tester.pumpWidget(const MaterialApp(home: Register()));
        final Finder usernameField = find.byType(TextFormField).at(0);
        final Finder emailField = find.byType(TextFormField).at(1);
        final Finder passwordField = find.byType(TextFormField).at(2);
        final Finder confirmPasswordField = find.byType(TextFormField).at(3);
        final Finder button = find.byType(ElevatedButton);

        await tester.enterText(usernameField, 'emailalreadytakentest');
        await tester.enterText(emailField, 'yc@gmail.com');
        await tester.enterText(passwordField, 'password');
        await tester.enterText(confirmPasswordField, 'password');
        await tester.pumpAndSettle();
        await tester.ensureVisible(button);
        await tester.tap(button);

        await waitFor(tester, find.text('This email is already in use'));
        expect(find.text('This email is already in use'), findsOneWidget);
      },
    );

    testWidgets(
      'Username field cannot be left empty in registration',
          (WidgetTester tester) async {

        await tester.pumpWidget(const MaterialApp(home: Register()));
        final Finder emailField = find.byType(TextFormField).at(1);
        final Finder passwordField = find.byType(TextFormField).at(2);
        final Finder confirmPasswordField = find.byType(TextFormField).at(3);
        final Finder button = find.byType(ElevatedButton);

        await tester.enterText(emailField, 'newacc@gmail.com');
        await tester.enterText(passwordField, 'password');
        await tester.enterText(confirmPasswordField, 'password');
        await tester.pumpAndSettle();
        await tester.ensureVisible(button);
        await tester.tap(button);

        await waitFor(tester, find.text('Please enter a username'));
        expect(find.text('Please enter a username'), findsOneWidget);
      },
    );

    testWidgets(
      'Email field cannot be left empty in registration',
          (WidgetTester tester) async {

        await tester.pumpWidget(const MaterialApp(home: Register()));
        final Finder usernameField = find.byType(TextFormField).at(0);
        final Finder passwordField = find.byType(TextFormField).at(2);
        final Finder confirmPasswordField = find.byType(TextFormField).at(3);
        final Finder button = find.byType(ElevatedButton);

        await tester.enterText(usernameField, 'newacc');
        await tester.enterText(passwordField, 'password');
        await tester.enterText(confirmPasswordField, 'password');
        await tester.pumpAndSettle();
        await tester.ensureVisible(button);
        await tester.tap(button);

        await waitFor(tester, find.text('Please enter an email'));
        expect(find.text('Please enter an email'), findsOneWidget);
      },
    );

    testWidgets(
      'Users has to register with a valid email format',
          (WidgetTester tester) async {

        await tester.pumpWidget(const MaterialApp(home: Register()));
        final Finder usernameField = find.byType(TextFormField).at(0);
        final Finder emailField = find.byType(TextFormField).at(1);
        final Finder passwordField = find.byType(TextFormField).at(2);
        final Finder confirmPasswordField = find.byType(TextFormField).at(3);
        final Finder button = find.byType(ElevatedButton);

        await tester.enterText(usernameField, 'newacc');
        await tester.enterText(emailField, 'newacc@');
        await tester.enterText(passwordField, 'password');
        await tester.enterText(confirmPasswordField, 'password');
        await tester.pumpAndSettle();
        await tester.ensureVisible(button);
        await tester.tap(button);

        await waitFor(tester, find.text('Please enter a valid email'));
        expect(find.text('Please enter a valid email'), findsOneWidget);
      },
    );

    testWidgets(
      'Password field cannot be left empty in registration',
          (WidgetTester tester) async {

        await tester.pumpWidget(const MaterialApp(home: Register()));
        final Finder usernameField = find.byType(TextFormField).at(0);
        final Finder emailField = find.byType(TextFormField).at(1);
        final Finder confirmPasswordField = find.byType(TextFormField).at(3);
        final Finder button = find.byType(ElevatedButton);

        await tester.enterText(usernameField, 'newacc');
        await tester.enterText(emailField, 'newacc@gmail.com');
        await tester.enterText(confirmPasswordField, 'password');
        await tester.pumpAndSettle();
        await tester.ensureVisible(button);
        await tester.tap(button);

        await waitFor(tester, find.text('Please enter a password'));
        expect(find.text('Please enter a password'), findsOneWidget);
      },
    );

    testWidgets(
      'Password field must be at least 6 characters',
          (WidgetTester tester) async {

        await tester.pumpWidget(const MaterialApp(home: Register()));
        final Finder usernameField = find.byType(TextFormField).at(0);
        final Finder emailField = find.byType(TextFormField).at(1);
        final Finder passwordField = find.byType(TextFormField).at(2);
        final Finder confirmPasswordField = find.byType(TextFormField).at(3);
        final Finder button = find.byType(ElevatedButton);

        await tester.enterText(usernameField, 'newacc');
        await tester.enterText(emailField, 'newacc@gmail.com');
        await tester.enterText(passwordField, 'pass');
        await tester.enterText(confirmPasswordField, 'pass');
        await tester.pumpAndSettle();
        await tester.ensureVisible(button);
        await tester.tap(button);

        await waitFor(tester, find.text('Password length must be at least 6 characters'));
        expect(find.text('Password length must be at least 6 characters'), findsOneWidget);
      },
    );

    testWidgets(
      'Confirm Password field cannot be left empty',
          (WidgetTester tester) async {

        await tester.pumpWidget(const MaterialApp(home: Register()));
        final Finder usernameField = find.byType(TextFormField).at(0);
        final Finder emailField = find.byType(TextFormField).at(1);
        final Finder passwordField = find.byType(TextFormField).at(2);
        final Finder button = find.byType(ElevatedButton);

        await tester.enterText(usernameField, 'newacc');
        await tester.enterText(emailField, 'newacc@gmail.com');
        await tester.enterText(passwordField, 'password');
        await tester.pumpAndSettle();
        await tester.ensureVisible(button);
        await tester.tap(button);

        await waitFor(tester, find.text('Please confirm your password'));
        expect(find.text('Please confirm your password'), findsOneWidget);
      },
    );

    testWidgets(
      'Confirm Password field must match with the Password field',
          (WidgetTester tester) async {

        await tester.pumpWidget(const MaterialApp(home: Register()));
        final Finder usernameField = find.byType(TextFormField).at(0);
        final Finder emailField = find.byType(TextFormField).at(1);
        final Finder passwordField = find.byType(TextFormField).at(2);
        final Finder confirmPasswordField = find.byType(TextFormField).at(3);
        final Finder button = find.byType(ElevatedButton);

        await tester.enterText(usernameField, 'newacc');
        await tester.enterText(emailField, 'newacc@gmail.com');
        await tester.enterText(passwordField, 'password');
        await tester.enterText(confirmPasswordField, 'password123');
        await tester.pumpAndSettle();
        await tester.ensureVisible(button);
        await tester.tap(button);

        await waitFor(tester, find.text('Password do not match!'));
        expect(find.text('Password do not match!'), findsOneWidget);
      },
    );

    testWidgets(
      'Register when all fields are correct',
          (WidgetTester tester) async {

        //TODO: Every time this test is done, we have to change the username and email
            // because it is already authenticated in firebase.
        await tester.pumpWidget(const MaterialApp(home: Register()));
        final randomUsername = faker.person.name();
        final randomEmail = faker.internet.email();
        final Finder usernameField = find.byType(TextFormField).at(0);
        final Finder emailField = find.byType(TextFormField).at(1);
        final Finder passwordField = find.byType(TextFormField).at(2);
        final Finder confirmPasswordField = find.byType(TextFormField).at(3);
        final Finder button = find.byType(ElevatedButton);

        await tester.enterText(usernameField, randomUsername);
        await tester.enterText(emailField, randomEmail);
        await tester.enterText(passwordField, 'password');
        await tester.enterText(confirmPasswordField, 'password');
        await tester.pumpAndSettle();
        await tester.ensureVisible(button);
        await tester.tap(button);

        await waitFor(tester, find.byType(SuccessfulRegistration));
        expect(find.byType(SuccessfulRegistration), findsOneWidget);
      },
    );
  });
}
