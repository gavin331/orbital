import 'package:flutter/material.dart';
// import 'package:orbital_appllergy/service/AuthService.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     AuthService authService = AuthService();

//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Temporary home page'),
//             Text('Signed in as: ${authService.user?.email}'),
//             ElevatedButton(
//                 onPressed: () async {
//                   await authService.signOut(context);
//                 },
//                 child: const Text('Log Out'),
//             ),
//           ],
//         ),
//       )
//     );
//   }
// }

// import 'package:flutter/material.dart';

// void main() => runApp(MaterialApp(
//   home: HomeScreen(),
// ));

// class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBar(
          title: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.menu, size: 40.0),
                  onPressed: () {}, // menu card pops up from the left
                ),
                SizedBox(width: 40.0),
                Image.asset('windows/assets/images/apple.png', height: 40.0),
                SizedBox(width: 15.0),
                Text('Appllergy',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontFamily: 'Poppins')
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.red[100],
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  SizedBox(
                    height: 100.0, width: 100.0,
                    child: TextButton(
                    onPressed: () {}, // go to Find Allergen screen
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.red[400]!;
                        }
                        return Colors.red[300]!;
                      }),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.all(16.0),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
              child: Column(
                children: [
                    Icon(Icons.search, color: Colors.white),
                    SizedBox(height: 10.0),
                    Text('    Find\nallergen',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 11.0
                        ),
                    ),
                ]
              ),
            ),
                  ),
      SizedBox(width: 15.0),
      SizedBox(
            height: 100.0, width: 100.0,
            child: TextButton(
            onPressed: () {}, // go to Find foods screen
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.pressed)) {
                return Colors.red[600]!;
                }
                return Colors.red[500]!;
                }),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.all(16.0),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              ),
            ),
    ),
    child: Column(
            children: [
              Icon(Icons.no_food, color: Colors.white),
              SizedBox(height: 12.0),
              Text(' Find\nfoods',
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
      ]
      ),
    SizedBox(height: 15.0),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget> [
    SizedBox(
      height: 100.0, width: 100.0,
      child: TextButton(
      onPressed: () {}, // go to Check Food screen
      style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.pressed)) {
      return Colors.red[500]!;
      }
      return Colors.red[400]!;
      }),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.all(16.0),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
      ),
            child: Column(
                children: [
                  Icon(Icons.food_bank_rounded, color: Colors.white),
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
      SizedBox(width: 15.0),
      SizedBox(
            height: 100.0, width: 100.0,
            child: TextButton(
              onPressed: () {}, // go to Check symptoms screen
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.red[300]!;
                  }
                  return Colors.red[200]!;
                }),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.all(16.0),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              child: Column(
                  children: [
                    Icon(Icons.sick, color: Colors.white),
                    SizedBox(height: 12.0),
                    Text('    Check\nsymptoms',
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
            ],
          ),
      SizedBox(height: 65.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          SizedBox(
            height: 100.0, width: 100.0,
            child: TextButton(
              onPressed: () {}, // trigger call to 995 and message sent to emergency contacts
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.red[600]!;
                  }
                  return Colors.red;
                }),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.all(16.0),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                ),
              ),
              child: Column(
                  children: [
                    SizedBox(height: 6.0),
                    Icon(Icons.call, color: Colors.white),
                    SizedBox(height: 8.0),
                    Text('Emergency\n   contact',
                        style: TextStyle(
                            color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 10.0
                        )
                    ),
                  ]
              )
              ),
              ),
      ]
            ),
      ]
          ),
    );
  }
}