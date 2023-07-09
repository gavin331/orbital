import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// AuthService class handles all the authentication services in the mobile app.

class AuthService {
  final FirebaseAuth _fireBaseInstance = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  //Sign in with email and password
  Future signIn(String email, String password) async {
    await _fireBaseInstance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //Sign out
  Future signOut() async {
    await _fireBaseInstance.signOut();
  }

  //Register with email and password
  Future register(String email, String password, String username) async {
    bool result = await checkIfUsernameExists(username);
    if (result) {
      throw FirebaseAuthException(code: 'username-already-taken');
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
  }

  Future<bool> checkIfUsernameExists(String username) async {
    //Check if username already exists by getting the documents from this query.
    final check = await _firestore.collection('users').where('username', isEqualTo: username).limit(1).get();
    return check.docs.isNotEmpty;
  }
}



