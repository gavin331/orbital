import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbital_appllergy/Reusables/EmergencyCallButton.dart';
import 'package:orbital_appllergy/service/FirestoreService.dart';

class FindAllergen extends StatefulWidget {
  const FindAllergen({Key? key}) : super(key: key);

  @override
  State<FindAllergen> createState() => _FindAllergenState();
}

class _FindAllergenState extends State<FindAllergen> {
  List<TextEditingController> listController = [TextEditingController()];
  final FireStoreService _fireStoreService = FireStoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        toolbarHeight: 70, // Increase the toolbar height
        title: const Text(
          "Find Allergen",
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
                'Find out the exact allergen causing your food allergy!',
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
                                hintText: 'Enter food',
                                border: InputBorder.none,
                                contentPadding:
                                const EdgeInsets.symmetric(
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

          //Add button and Find Allergen Button
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

                  //Find Allergen button
                  ElevatedButton(
                    onPressed: () async {
                      // Get the entered food names from the text controllers
                      List<String> foodNames = [];
                      for (var controller in listController) {
                        foodNames.add(controller.text.trim());
                      }

                      // Find the common elements among the entered food names
                      List<String> commonElements =
                      await _findCommonElements(foodNames);

                      // Display the common elements in a text box
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Possible Allergens'),
                              content: Text(commonElements.isNotEmpty
                                  ? commonElements.join(', ')
                                  : 'No common allergen found!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // TODO: Implement the save feature.
                                    // Add every string in the commonElements array
                                    // to the allergen list for the corresponding user doc in firebase.
                                    await _fireStoreService.saveToUserAllergen(commonElements);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Saved to User Profile Successfully')),
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
                    child: const Text('Find Allergen'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> _findCommonElements(List<String> foodNames) async {
    // TODO: Separate backend methods from the frontend UI.
    // If the user doesnt input anything and presses find allergen,
    // foodNames will store an empty string for each empty text field. So if
    // foodNames only contain empty strings, then we just return an empty list.
    foodNames.removeWhere((element) => element == "");
    if (foodNames.isEmpty) {
      return [];
    }

    // Query the Firestore collection for the matching common names
    //TODO: There is a bug here because the Common Name field might not always be in lowercase.
    List<QuerySnapshot<Map<String, dynamic>>> snapshots = [];
    for (String foodName in foodNames) {
      snapshots.add(await FirebaseFirestore.instance
          .collection('food_allergen')
          .where('LowerCaseName', isGreaterThanOrEqualTo: foodName.toLowerCase())
          .where('LowerCaseName', isLessThanOrEqualTo: foodName.toLowerCase() + '\uf8ff')
          .get());
    }
    // Combine the descriptions from the query snapshots
    List<List<String>> descriptionsList = [];
    for (var snapshot in snapshots) {
      List<String> descriptions = [];
      for (var doc in snapshot.docs) {
        descriptions.add(doc['Description'] as String);
      }
      descriptionsList.add(descriptions);
    }
    // Find the common elements among the descriptions
    List<String> commonElements = [];
    if (descriptionsList.isNotEmpty) {
      commonElements = descriptionsList.first.toSet().toList();
      for (int i = 1; i < descriptionsList.length; i++) {
        commonElements = commonElements
            .where((element) => descriptionsList[i].contains(element))
            .toList();
      }
    }
    commonElements.removeWhere((element) => element.contains('unknown function'));
    return commonElements;
  }
}