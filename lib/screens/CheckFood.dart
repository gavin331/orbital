import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:orbital_appllergy/Reusables/EmergencyCallButton.dart';
import 'package:orbital_appllergy/service/FirestoreService.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

//TODO: If have time, we can list all the allergens out and apply the tick/cross.

class CheckFood extends StatefulWidget {
  const CheckFood({super.key});

  @override
  State<CheckFood> createState() => _CheckFoodState();
}

class _CheckFoodState extends State<CheckFood> {

  final FireStoreService _fireStoreService = FireStoreService();
  final TextEditingController _foodName = TextEditingController();

  @override
  void dispose() {
    _foodName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          "Check Food",
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
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Input food name to find out whether it contains your allergens!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 50),
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
                      controller: _foodName,
                      decoration: const InputDecoration(
                        hintText: 'Enter food name here',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      bool result = await _fireStoreService.checkUserAllergenicFoods(_foodName.text);
                      List<String> commonAllergens = await _fireStoreService
                          .findCommonAllergensForCheckFood(_foodName.text);
                      if (context.mounted) {
                        if (result) {
                          _buildAlertDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            title: 'Warning',
                            desc: '${_foodName.text} is probably a food you are allergic to, beware!'
                                ' The allergens you have that are present in ${_foodName.text} are: ',
                            allergens: commonAllergens,
                          ).show();
                        } else {
                          _buildAlertDialog(
                            context: context,
                            dialogType: DialogType.success,
                            title: 'Not Found!',
                            desc: 'Good news! ${_foodName.text} is probably not a food you are allergic to,'
                                ' but proceed with caution just in case!',
                            // allergens: commonAllergens,
                          ).show();
                        }
                      }
                    },
                    child: const Text('Find out'),
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

AwesomeDialog _buildAlertDialog({
  required BuildContext context,
  required DialogType dialogType,
  required String? title,
  required String? desc,
  List<String>? allergens,
}) {
  return AwesomeDialog(
    context: context,
    dialogType: dialogType,
    borderSide: const BorderSide(
      color: Colors.green,
      width: 2,
    ),
    width: 280,
    buttonsBorderRadius: const BorderRadius.all(
      Radius.circular(2),
    ),
    animType: AnimType.bottomSlide,
    body: Column(
      children: [
        if (title != null) Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 10),
        if (desc != null) Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            desc,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const SizedBox(height: 10),
        /*
        Everything below will be shown only when the allergen parameter is not null.
        The spread operator ... is used before the square brackets [] to flatten
        the list of widgets and include them as children of the parent widget.
        This allows the conditional widgets to be added to the parent widget's children list.
         */
        if (allergens != null) ...[
          SizedBox(
            height: 200,
            child: ListView.builder(
                padding: const EdgeInsets.only(top: 0), // Add top padding
                itemCount: allergens.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      contentPadding: const EdgeInsets.only(left: 16),
                      title: Text(
                        '${index + 1}. ${allergens[index]}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                        ),
                      )
                  );
                }
            ),
          ),
        ]
      ],
    ),
    showCloseIcon: true,
  );
}

