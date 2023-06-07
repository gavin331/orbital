import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';
import 'SignIn.dart';

/// This wrapper class considers whether the user is logged in or out. If the user
/// is logged in, it shows the home screen directly. If the user is logged out, it
/// shows the Sign In screen.

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //snapshot.hasData is true when the user is logged in and false otherwise
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return const SignIn();
          }
        },
      ),
    );
  }
}
