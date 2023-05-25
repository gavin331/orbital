import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbital_appllergy/screens/HomePage.dart';
import '../screens/SignIn.dart';
import '../screens/SuccessfulRegistration.dart';

/// AuthService class handles all the authentication services in the mobile app.

class AuthService {

  String error = "";
  final FirebaseAuth _fireBaseInstance = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;

  //Sign in with email and password
  Future signIn(String email, String password, BuildContext context) async {
    try {
      await _fireBaseInstance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = 'Cannot find user';
      } else if (e.code == 'wrong-password') {
        error = 'The password is invalid.';
      } else {
        error = 'An error occurred. Please try again later.';
      }
    } catch (e) {
      error = 'An error occurred. Please try again later.';
    }
  }

  //Sign out
  Future signOut(BuildContext context) async {
    await _fireBaseInstance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const SignIn()
      ),
    );
  }

  //Register with email and password
  Future register(String email, String password, BuildContext context) async {
    try {
      await _fireBaseInstance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SuccessfulRegistration()),
      );
    } on FirebaseAuthException catch(e) {
      if (e.code == "email-already-in-use") {
        error = 'This email is already in use';
      } else {
        error = 'An error occurred. Please try again later.';
      }
    } catch (e) {
      error = 'An error occurred. Please try again later.';
    }
  }
}
