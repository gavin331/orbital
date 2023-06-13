import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class FindAllergen extends StatefulWidget {
  const FindAllergen({Key? key}) : super(key: key);

  @override
  State<FindAllergen> createState() => _FindAllergenState();
}

class _FindAllergenState extends State<FindAllergen> {
  List<TextEditingController> listController = [TextEditingController()];

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
        actions: [
          //TODO: Put this in the reusable folder to cache it.
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {
                // Calls the emergency contact
              },
              icon: const Icon(
                Icons.phone,
                color: Colors.red,
              ),
            ),
          )
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
                                    horizontal: 10, vertical: 14),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    //Deletes the text field.
                                    setState(() {
                                      listController[index].clear();
                                      listController[index].dispose();
                                      listController.removeAt(index);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red[300],
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
                  const SizedBox(height: 5.0),

                  //Find Allergen button
                  ElevatedButton(
                    onPressed: () {
                      // Finds allergen
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
}
