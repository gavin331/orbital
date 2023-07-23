import 'package:flutter/material.dart';
import 'package:orbital_appllergy/screens/LinkedAccounts.dart';
import 'package:orbital_appllergy/screens/UserProfile.dart';
import 'package:orbital_appllergy/screens/EmergencySettings.dart';
import 'package:orbital_appllergy/service/AuthService.dart';
import '../service/FirestoreService.dart';
import 'SignIn.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final AuthService _authService = AuthService();
  final FireStoreService _fireStoreService = FireStoreService();
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
    return SizedBox(
      width: 230,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        child: Drawer(
          backgroundColor: Colors.red[100],
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    '${_authService.user?.displayName}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  accountEmail: Text(
                    '${_authService.user?.email}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  currentAccountPicture: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: imageUrl != null
                        ? Image.network(imageUrl!, fit: BoxFit.cover)
                        : const CircleAvatar(child: Icon(Icons.person, size: 50))
                  ),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      //TODO: Change to nicer one if possible
                      image: AssetImage('assets/UserProfileBackground.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                //User Profile
                ListTile(
                  trailing: const Icon(Icons.person),
                  title: const Text(
                    'User Profile',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close the side menu
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserProfile()),
                    );
                  },
                ),

                // removed emergency settings bar (no longer a feature)

                // const Divider(
                //     color: Colors.black
                // ),

                // //Settings
                // ListTile(
                //   trailing: const Icon(Icons.settings),
                //   title: const Text(
                //     'Emergency Settings',
                //     style: TextStyle(
                //       fontFamily: 'Poppins',
                //       fontSize: 15,
                //     ),
                //   ),
                //   onTap: () {
                //     Navigator.pop(context); // Close the side menu
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => const EmergencySettings()),
                //     );
                //   },
                // ),
                const Divider(
                    color: Colors.black
                ),

                //Linked Accounts
                ListTile(
                  trailing: const Icon(Icons.people),
                  title: const Text(
                    'Linked Accounts',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close the side menu
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LinkedAccounts()),
                    );
                  },
                ),
                const Divider(
                    color: Colors.black
                ),

                //Log out
                ListTile(
                  trailing: const Icon(Icons.logout),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context); // Close the side menu
                    await _authService.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignIn()
                        ),
                      );
                    }
                  },
                ),
                const Divider(
                    color: Colors.black
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
