import 'package:flutter/material.dart';
// import 'package:orbital_appllergy/service/AuthService.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class FindAllergen extends StatefulWidget {
  const FindAllergen({Key? key}) : super(key: key);

  @override
  State<FindAllergen> createState() => _FindAllergenState();
}

class _FindAllergenState extends State<FindAllergen> {
  List<Widget> widgets = [
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
        decoration: InputDecoration(
          hintText: 'Enter food',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
      ),
    ),
  ];

  void toggle() {
    setState(() {
      widgets.add(
        const SizedBox(height: 10),
      );
      widgets.add(
        Container(
          width: 300,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red, // Border color
              width: 1.0, // Border width
            ),
            borderRadius: BorderRadius.circular(8.0), // Border radius
          ),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter food',
              border: InputBorder.none, // Remove the default border
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              alignLabelWithHint: true,
            ),
          ),
        ),
      );
    });
  }

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
      ),
      body: CustomScrollView(
        slivers: [
          SliverStickyHeader(
            header: Container(
              height: 65,
              decoration: BoxDecoration(
                color: Colors.red[200]!,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  'Find out the exact allergen causing your food allergy!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center, // Center the text
                ),
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Column(
                    children: [
                      SizedBox(height: 50.0),
                      Column(
                        children: widgets,
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          toggle();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[300],
                        ),
                        child: const Icon(Icons.add),
                      ),
                      SizedBox(height: 5.0),
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
                  );
                },
                childCount: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: FindAllergen(),
    ),
  );
}