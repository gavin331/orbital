import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orbital_appllergy/service/AuthService.dart';
import 'package:orbital_appllergy/service/FirestoreService.dart';

//TODO: the imageUrl doesn't get updated with the value so the userprofile class can't access it.
//ie. Only when I put ProfileImageService().imageUrl == "" then the result will appear.

class ProfileImageService {

  final AuthService _authService = AuthService();
  final FireStoreService _fireStoreService = FireStoreService();
  String imageUrl = "";

  /*
  This method can either take in a ImageSource.gallery or ImageSource.camera
  as parameter.
   */
  Future<String> uploadImageToStorage(ImageSource src) async {

    final image = await ImagePicker().pickImage(
      source: src,
      imageQuality: 100,
    );

    Reference ref = FirebaseStorage.instance.ref()
        .child('${_authService.user!.displayName}_profilepic.jpg');

    await ref.putFile(File(image!.path));
    String imageUrl = await ref.getDownloadURL();
    print(imageUrl);
    return imageUrl;
  }

  Future<void> linkImageToFirestoreUser(String imageUrl) async {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(AuthService().user!.uid);

    await userRef.update({
      'profilepic': imageUrl,
    });
  }
}