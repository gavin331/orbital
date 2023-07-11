import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'AuthService.dart';

class FireStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  //If friend request was sent before, return false else return true.
  Future<bool> validateFriendRequestHistory(String? sender, String? receiver) async {
    final querySnapshot = await _firestore
        .collection('friend_requests')
        .where('senderName', isEqualTo: sender)
        .where('receiverName', isEqualTo: receiver)
        .get();

    if (querySnapshot.size > 0) {
      // Friend request was already sent before.
      return false;
    } else {
      return true;
    }
  }

  Future<bool> findUsernameInDatabase(String? receiver) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: receiver)
        .get();
    return querySnapshot.size > 0;
  }


  Future<void> sendFriendRequest(String? sender, String? receiver, String status) async {
    if (await validateFriendRequestHistory(sender, receiver)) {
      await _firestore.collection('friend_requests').add({
        'receiverName': receiver,
        'senderName': sender,
        'status': status,
      });
    } else {
      throw Exception();
    }
  }

  Future<void> rejectFriendRequest(QueryDocumentSnapshot<Object?> friendRequestDoc) async {
    friendRequestDoc.reference.delete();
  }

  //Sender's friendlist will get updated.
  Future<void> acceptFriendRequest(QueryDocumentSnapshot<Object?> friendRequestDoc,
      dynamic friendRequestSenderName) async{
    // Accept friend request
    await friendRequestDoc.reference.update({'status' : 'Accepted'});
    //Update the friendlist in the sender document.
    final userDocSnapshot = await _firestore.collection('users')
        .where('username', isEqualTo: friendRequestSenderName)
        .get();
    final userDocs = userDocSnapshot.docs;
    if (userDocs.isNotEmpty) {
      final userDoc = userDocs.first;
      await userDoc.reference.update({
        'friendlist': FieldValue.arrayUnion(
            [_authService.user?.displayName]),
      });
    }
  }

  Future<void> deleteFriendRequest(String friendName) async {
    final friendRequestSnapshot = await _firestore.collection('friend_requests')
        .where('senderName', isEqualTo: _authService.user?.displayName)
        .where('receiverName', isEqualTo: friendName)
        .get();
    //Gets a list of all the documents included in this snapshot.
    final friendRequestDocs = friendRequestSnapshot.docs;
    if (friendRequestDocs.isNotEmpty) {
      final friendRequestDoc = friendRequestDocs.first;
      await friendRequestDoc.reference.delete();
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDocSnapshot() {
    return _firestore.collection('users').doc(_authService.user?.uid).snapshots();
  }

  Future<void> removeFriend(DocumentSnapshot<Map<String, dynamic>> userDoc,
      String friendName) async {
    await userDoc.reference.update({
      'friendlist': FieldValue.arrayRemove([friendName]),
    });
  }

  /*
    Filtering through the database where receiverName is equal to the
    name of the current user.
   */
  Stream<QuerySnapshot> getFriendRequests() {
    return _firestore.collection('friend_requests')
        .where('receiverName', isEqualTo: _authService.user?.displayName)
        .where('status', isEqualTo: 'Pending')
        .snapshots();
  }

  // User Profile Backend
  Future<void> saveToUserAllergen(List<String> commonElements) async {
    final userDocSnapshot = await _firestore.collection('users')
        .where('username', isEqualTo: _authService.user?.displayName)
        .get();
    final userDocs = userDocSnapshot.docs;
    if (userDocs.isNotEmpty) {
      final userDoc = userDocs.first;
      for (String str in commonElements) {
        await userDoc.reference.update({
          'allergens': FieldValue.arrayUnion(
              [str]),
        });
      }
    }
  }

  Future<void> removeFromUserAllergen(DocumentSnapshot<Map<String, dynamic>> userDoc,
      String allergen) async {
    await userDoc.reference.update({
      'allergens': FieldValue.arrayRemove([allergen]),
    });
  }
  
  Future<void> saveToUserAllergenicFoods(List<String> commonElements) async {
    final userDocSnapshot = await _firestore.collection('users')
        .where('username', isEqualTo: _authService.user?.displayName)
        .get();
    final userDocs = userDocSnapshot.docs;
    if (userDocs.isNotEmpty) {
      final userDoc = userDocs.first;
      for (String str in commonElements) {
        await userDoc.reference.update({
          'allergenicfoods': FieldValue.arrayUnion(
              [str]),
        });
      }
    }
  }

  Future<void> removeFromUserAllergenicFoods(DocumentSnapshot<Map<String, dynamic>> userDoc,
      String allergen) async {
    await userDoc.reference.update({
      'allergenicfoods': FieldValue.arrayRemove([allergen]),
    });
  }
  
  //Linked Accounts Friends Expansion Tile Backend
  Stream<DocumentSnapshot<Map<String, dynamic>>?> getFriendDocSnapshot(String friendName) {
    return _firestore.collection('users')
        .where('username', isEqualTo: friendName)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return snapshot.docs.first;
          } else {
            return null;
          }
        });
  }

  // The 3 methods below are for Check Food backend
  Future<bool> checkUserAllergenicFoods(String foodName) async {
    final userDocSnapshot = await _firestore.collection('users')
        .where('username', isEqualTo: _authService.user?.displayName)
        .get();
    final userDocs = userDocSnapshot.docs;
    if (userDocs.isNotEmpty) {
      final userDoc = userDocs.first;
      final allergenicFoods = (userDoc.data()['allergenicfoods'] as List<dynamic>)
        .map((food) => food.toLowerCase())
        .toList();
      final foodNameToLowerCase = foodName.toLowerCase();
      return allergenicFoods.contains(foodNameToLowerCase);
    } else {
      return false;
    }
  }

  Future<List<String>> getAllAllergensFromThisFood(String foodName) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('food_allergen')
        .where('LowerCaseName', isEqualTo: foodName.toLowerCase())
        .get();
    List<String> listOfAllergens = [];
    for (var doc in snapshot.docs) {
      String description = doc['Description'] as String;
      if (!description.contains('unknown function')) {
        listOfAllergens.add(description);
      }
    }
    return listOfAllergens;
  }

  Future<List<String>> findCommonAllergensForCheckFood(String foodName) async {
    final userDocSnapshot = await _firestore.collection('users')
        .where('username', isEqualTo: _authService.user?.displayName)
        .get();
    final userDocs = userDocSnapshot.docs;
    List<String> commonAllergens = [];
    List<String> allergensFromDatabase = await getAllAllergensFromThisFood(foodName);
    if (userDocs.isNotEmpty) {
      final userDoc = userDocs.first;
      final allergens = (userDoc.data()['allergens'] as List<dynamic>).toList();
      for (dynamic allergen in allergens) {
        if (allergensFromDatabase.contains(allergen)) {
          commonAllergens.add(allergen);
        }
      }
    }
    return commonAllergens;
  }

  //The methods below are for Log Symptoms backend

  void logAllergySymptoms(String userId, String title, String symptoms,
      DateTime occurrenceDate, String precautions) {

    DocumentReference userRef = _firestore.collection('users').doc(userId);

    /*
    DateTime returns 'YYYY-MM-DD HH:MM:SS.mmm' so if we only want 'YYYY-MM-DD'
    we can use substring(0,10). Then, if we want DD-MM-YYYY we can extract out
    the corresponding values and concatenate them.
     */
    String formattedDate = '${occurrenceDate.toString().substring(8, 10)}'
        '-${occurrenceDate.toString().substring(5, 7)}'
        '-${occurrenceDate.toString().substring(0, 4)}';

    // Update the symptoms array field with the new log entry
    userRef.update({
      'symptoms': FieldValue.arrayUnion([
        {
          'title' : title,
          'mySymptoms': symptoms,
          'occurrenceDate': formattedDate,
          'precautions': precautions,
        },
      ]),
    })
    .then((value) => print('Log entry added successfully'))
    .catchError((error) => print('Failed to add log entry: $error'));
  }

  Future<void> removeFromUserSymptoms(DocumentSnapshot<Map<String, dynamic>> userDoc,
      String logTitle, String occurrenceDate, String precautions, String mySymptoms) async {
    await userDoc.reference.update({
      'symptoms': FieldValue.arrayRemove([
        {
        'mySymptoms': mySymptoms,
        'occurrenceDate': occurrenceDate,
        'precautions': precautions,
        'title': logTitle,
        },
      ]),
    });
  }
}