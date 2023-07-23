import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orbital_appllergy/Reusables/EmergencyCallButton.dart';
import 'package:orbital_appllergy/service/FirestoreService.dart';
import 'package:orbital_appllergy/service/ProfileImageService.dart';
import '../Reusables/CustomAwesomeDialog.dart';
import '../service/AuthService.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final FireStoreService _fireStoreService = FireStoreService();
  final ProfileImageService _profileImageService = ProfileImageService();
  String? imageUrl;

  Future<void> fetchUserImageUrl() async {
    String? userImageUrl = await _fireStoreService.getUserImageUrl();
    setState(() {
      imageUrl = userImageUrl;
    });
  }

  @override
  void initState()  {
    super.initState();
    /*
    Call this method whenever the widget is reinitialised so that the String?
    imageUrl will not be reset
     */
    fetchUserImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: const Text('User Profile'),
        centerTitle: true,
        elevation: 0,
        actions: const [
          EmergencyCallButton(),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Stack(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: imageUrl != null
                        ? Image.network(imageUrl!, fit: BoxFit.cover)
                        : const CircleAvatar(child: Icon(Icons.person, size: 50))
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.red[100],
                    ),
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                'Pick image from: ',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              content: SizedBox(
                                height: 120,
                                child: Column(
                                  children: [
                                    ListTile(
                                      //Select image from camera
                                      onTap: () async {
                                        //Pop the alertdialog
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                        String imageUrl = await _profileImageService.uploadImageToStorage(ImageSource.camera);
                                        await _profileImageService.linkImageToFirestoreUser(imageUrl);
                                        await fetchUserImageUrl();
                                      },
                                      leading: const Icon(Icons.camera_alt),
                                      title: const Text(
                                        'Camera',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      //Select image from gallery
                                      onTap: () async {
                                        //Pop the alert dialog
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                        String imageUrl = await _profileImageService.uploadImageToStorage(ImageSource.gallery);
                                        await _profileImageService.linkImageToFirestoreUser(imageUrl);
                                        await fetchUserImageUrl();
                                      },
                                      leading: const Icon(Icons.image),
                                      title: const Text(
                                        'Gallery',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${_authService.user?.displayName}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            Text(
              '${_authService.user?.email}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            //Menu
            Container(
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  indicator: BoxDecoration(
                    color: Colors.red[300], //Color when the tab is pressed.
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  tabs: const [
                    Tab(text: 'Your Allergens'),
                    Tab(text: 'Allergenic Foods'),
                    Tab(text: 'Your Symptoms'),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Container(
                color: Colors.red[100],
                child: TabBarView(
                  controller: tabController,
                  children: [
                    // Your Allergens Screen
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: _fireStoreService.getUserDocSnapshot(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final userDoc = snapshot.data!;
                          final allergenList = userDoc.data()?['allergens'] as List<dynamic>;
                          return ListView.builder(
                            key: const Key('yourAllergensListView'),
                            itemCount: allergenList.length,
                            itemBuilder: (context, index) {
                              final allergenName = allergenList[index].toString();
                              return ListTile(
                                title: Text(allergenName),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await _fireStoreService.removeFromUserAllergen(userDoc, allergenName);
                                    if (context.mounted) {
                                      CustomAwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.success,
                                        title: 'Success!',
                                        desc: 'Removed from allergen list!',
                                      ).buildAlertDialog().show();
                                    }
                                  },
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),

                    // Allergenic Foods Screen
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: _fireStoreService.getUserDocSnapshot(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final userDoc = snapshot.data!;
                          final allergenicFoodsList = userDoc.data()?['allergenicfoods'] as List<dynamic>;
                          return ListView.builder(
                            key: const Key('allergenicFoodsListView'),
                            itemCount: allergenicFoodsList.length,
                            itemBuilder: (context, index) {
                              final foodName = allergenicFoodsList[index].toString();
                              return ListTile(
                                title: Text(foodName),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await _fireStoreService.removeFromUserAllergenicFoods(userDoc, foodName);
                                    if (context.mounted) {
                                      CustomAwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.success,
                                        title: 'Success!',
                                        desc: 'Removed from allergenic foods list!',
                                      ).buildAlertDialog().show();
                                    }
                                  },
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),

                    // Your Symptoms Screen
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: _fireStoreService.getUserDocSnapshot(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final userDoc = snapshot.data!;
                          final symptomsList = userDoc.data()?['symptoms'] as List<dynamic>;
                          return ListView.builder(
                            key: const Key('yourSymptomsListView'),
                            itemCount: symptomsList.length,
                            itemBuilder: (context, index) {
                              final log = symptomsList[index] as Map<String, dynamic>;
                              final logTitle = log['title'] as String;
                              final symptoms = log['mySymptoms'] as String;
                              final occurrenceDate = log['occurrenceDate'] as String;
                              final precautions = log['precautions'] as String;

                              return ExpansionTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: logTitle.trim().isNotEmpty
                                          ? Text(logTitle.replaceAll(RegExp(r'\s+'), ' '))
                                          : const Text('No title'),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        await _fireStoreService.removeFromUserSymptoms(userDoc, logTitle,
                                            occurrenceDate, precautions, symptoms);
                                        if (context.mounted) {
                                          CustomAwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.success,
                                            title: 'Success!',
                                            desc: 'Removed from symptoms list!',
                                          ).buildAlertDialog().show();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                trailing: const Icon(Icons.expand_more),
                                children: [
                                  Text(
                                    'Date: $occurrenceDate',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    'Description: $symptoms',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    'Precaution: $precautions',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}