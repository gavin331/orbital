// Unit test for widgets used in the Sign In screen.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbital_appllergy/screens/SignIn.dart';

void main() {
  testWidgets('SignIn screen widget test', (WidgetTester tester) async {
    // Build the SignIn screen widget
    await tester.pumpWidget(const MaterialApp(home: SignIn()));

    // Perform widget interactions and assertions
    // Example: Entering text in the email field
    await tester.enterText(find.byKey(const Key('emailTextField')), 'test@example.com');

    // Example: Entering text in the password field
    await tester.enterText(find.byKey(const Key('passwordTextField')), '');

    // Example: Tapping the Sign In button
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    // Example: Verifying the state of a widget after a button tap
    expect(find.text('Please fill in your details'), findsOneWidget);
  });
}
