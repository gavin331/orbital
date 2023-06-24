import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbital_appllergy/screens/HomePage.dart';
import '../screens/SignIn.dart';
import '../screens/SuccessfulRegistration.dart';

/// AuthService class handles all the authentication services in the mobile app.

class AuthService {

  String error = "";
  final FirebaseAuth _fireBaseInstance = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  //Sign in with email and password
  Future signIn(String email, String password, BuildContext context) async {
    try {
      await _fireBaseInstance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
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
  Future register(String email, String password, String username,  BuildContext context) async {
    try {

      //Check if username already exists by getting the documents from this query.
      final check = await _firestore.collection('users').where('username', isEqualTo: username).limit(1).get();
      if (check.docs.isNotEmpty) {
        error = 'This username is already taken';
        return;
      }

      //If username is unique, then proceed with authentication.
      await _fireBaseInstance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      // Refresh the user object to get the latest data
      await user?.reload();

      // Get the updated user object after the reload
      final updatedUser = _fireBaseInstance.currentUser;

      // Update the display name
      await updatedUser?.updateDisplayName(username);

      //Add the user to the users collection in firestore.
      final userCollection = _firestore.collection('users');
      await userCollection.doc(updatedUser?.uid).set({
        'username': username,
        'friendlist': [],
        'allergens': [],
        'allergenicfoods': [],
        'symptoms': [],//Empty friend list
      });

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
