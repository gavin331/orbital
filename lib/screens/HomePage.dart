import 'package:flutter/material.dart';
import 'package:orbital_appllergy/screens/FindAllergen.dart';
import 'package:orbital_appllergy/screens/FindFoods.dart';
import 'package:orbital_appllergy/screens/LogSymptoms.dart';
import '../service/AuthService.dart';
import 'CheckFood.dart';
import 'SideMenu.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final AuthService authService = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      backgroundColor: Colors.red[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon menu
                IconButton(
                  icon: const Icon(
                      Icons.menu,
                      size: 40.0
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  }, // menu card pops up from the left
                ),
                const SizedBox(width: 40.0),
                Image.asset('assets/apple.png', height: 40.0),
                const SizedBox(width: 15.0),
                const Text('Appllergy',
                    style: TextStyle(
                        fontSize: 32.0,
                        fontFamily: 'Poppins'
                    )
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.red[200],
          elevation: 0,
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello ${authService.user?.displayName?? ""}!',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 25,
              ),
            ),
            const Text(
              'Welcome back!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 50),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FindAllergen()
                            )
                        );
                      }, // go to Find Allergen screen
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.red[400]!;
                          }
                          return Colors.red[300]!;
                        }),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(16.0),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: Column(children: const [
                        Icon(Icons.search, color: Colors.white),
                        SizedBox(height: 10.0),
                        Text(
                          '    Find\nallergen',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 11.0),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FindFoods()
                            )
                        );
                      }, // go to Find foods screen
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.red[600]!;
                          }
                          return Colors.red[500]!;
                        }),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(16.0),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: Column(children: const [
                        Icon(Icons.no_food, color: Colors.white),
                        SizedBox(height: 12.0),
                        Text(' Find\nfoods',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 11.0,
                            )),
                      ]),
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                  width: 100.0,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CheckFood()
                          )
                      );
                    }, // go to Check Food screen
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.red[500]!;
                        }
                        return Colors.red[400]!;
                      }),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(16.0),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Column(
                        children: const [
                          Icon(Icons.food_bank_rounded,
                            color: Colors.white
                          ),
                          SizedBox(height: 12.0),
                          Text('Check\n  food',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 11.0
                              )
                          ),
                        ]
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                SizedBox(
                  height: 100.0,
                  width: 100.0,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LogSymptoms()
                          )
                      );
                    }, // go to Check symptoms screen
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.red[300]!;
                        }
                        return Colors.red[200]!;
                      }),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(16.0),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Column(
                        children: const [
                          Icon(Icons.sick, color: Colors.white),
                          SizedBox(height: 12.0),
                          Text(
                            '       Log\nsymptoms',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 11.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ]
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 65.0),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: TextButton(
                        onPressed: () {}, // trigger call to 995 and message sent to emergency contacts
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.red[600]!;
                            }
                            return Colors.red;
                          }),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(16.0),
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60.0),
                            ),
                          ),
                        ),
                        child: Column(children: const [
                          SizedBox(height: 6.0),
                          Icon(Icons.call, color: Colors.white),
                          SizedBox(height: 8.0),
                          Text('Emergency\n   contact',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 10.0,
                              )
                          )]
                        )
                    ),
                  ),
              ]
            ),
        ]),
    );
  }
}
