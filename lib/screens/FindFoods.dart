import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbital_appllergy/Reusables/EmergencyCallButton.dart';
import 'package:orbital_appllergy/service/FirestoreService.dart';

class FindFoods extends StatefulWidget {
  const FindFoods({Key? key}) : super(key: key);

  @override
  State<FindFoods> createState() => _FindFoodsState();
}

class _FindFoodsState extends State<FindFoods> {
  List<TextEditingController> listController = [TextEditingController()];
  final FireStoreService _fireStoreService = FireStoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        toolbarHeight: 70, // Increase the toolbar height
        title: const Text(
          "Find Food(s)",
          style: TextStyle(
            fontSize: 32.0,
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[100],
        actions: const [
          EmergencyCallButton(),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverStickyHeader(
            header: Container(
              color: Colors.red[200],
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Find out which food(s) you have a chance of being allergic to!',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 300,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.red,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextFormField(
                              controller: listController[index],
                              decoration: InputDecoration(
                                hintText: 'Enter allergen',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 14,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    //Deletes the text field.
                                    setState(() {
                                      listController[index].clear();
                                      listController[index].dispose();
                                      listController.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                childCount: listController.length,
              ),
            ),
          ),

          //Add button and Find Food Button
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  //Add Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        listController.add(TextEditingController());
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[300],
                    ),
                    child: const Icon(Icons.add),
                  ),

                  const SizedBox(height: 20),

                  // Find Food Button
                  ElevatedButton(
                    onPressed: () async {
                      // Get the entered descriptions from the text controllers
                      List<String> descriptions = [];
                      for (var controller in listController) {
                        descriptions.add(controller.text.trim());
                      }

                      // Find the common elements among the descriptions
                      List<String> commonElements =
                      await _findCommonElements(descriptions);

                      // Remove duplicates from the common elements list
                      commonElements = commonElements.toSet().toList();

                      // Display the common elements in a text box
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Possible Foods'),
                              content: Text(commonElements.isNotEmpty
                                  ? commonElements.join(', ')
                                  : 'No possible food found in the database!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Add every string in the commonElements array
                                    // to the allergen list for the corresponding user doc in firebase.
                                    await _fireStoreService
                                        .saveToUserAllergenicFoods(commonElements);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Saved to User Profile Successfully'),
                                        ),
                                      );
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Find Food(s)'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> _findCommonElements(List<String> descriptions) async {
    // TODO: Separate backend methods from the frontend UI.
    // If the user doesn't input anything and presses find food,
    // descriptions will store an empty string for each empty text field. So if
    // descriptions only contain empty strings, then we just return an empty list.
    descriptions.removeWhere((element) => element.isEmpty);
    if (descriptions.isEmpty) {
      return [];
    }

    // Query the Firestore collection for the matching common names
    List<QuerySnapshot<Map<String, dynamic>>> snapshots = [];
    for (String description in descriptions) {
      snapshots.add(await FirebaseFirestore.instance
          .collection('food_allergen')
          .where('Description', isGreaterThanOrEqualTo: description.toLowerCase())
          .where('Description', isLessThanOrEqualTo: description.toLowerCase() + '\uf8ff')
          .get());
    }

    // Combine the common names from the query snapshots
    List<List<String>> commonNamesList = [];
    for (var snapshot in snapshots) {
      List<String> commonNames = [];
      for (var doc in snapshot.docs) {
        commonNames.add(doc['Common Name'] as String);
      }
      commonNamesList.add(commonNames);
    }

    // Combine the common names from the descriptions
    List<String> commonElements = [];
    for (var names in commonNamesList) {
      commonElements.addAll(names);
    }

    return commonElements;
  }
}