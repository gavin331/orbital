import 'package:cloud_firestore/cloud_firestore.dart';
import 'AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FireStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

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
}