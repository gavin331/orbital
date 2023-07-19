import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

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

  group('Check Food feature test', () {
    setUpAll(() async {
      await Firebase.initializeApp();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'yc@gmail.com',
        password: 'password',
      );
    });

    testWidgets('CheckFood widget test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(app.MyApp()); // Replace MyApp with the widget holding CheckFood widget.

      // Find and interact with the CheckFood widget.
      await tester.enterText(find.byType(TextFormField), 'Your test food name'); // Replace the text with your test food name.
      await tester.tap(find.text('Find out'));
      await tester.pumpAndSettle();

      // Now, you can make assertions based on the result of the CheckFood widget.
      // For example, you can check if the correct AlertDialog is displayed.
      expect(find.text('Warning'), findsOneWidget);
      expect(find.text('Not Found!'), findsNothing);
    });
  });
}