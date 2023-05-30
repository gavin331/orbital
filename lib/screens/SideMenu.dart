import 'package:flutter/material.dart';
import 'package:orbital_appllergy/service/AuthService.dart';

class SideMenu extends StatelessWidget {
  SideMenu({Key? key}) : super(key: key);

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Drawer(
        backgroundColor: Colors.red[100],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
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
                  // TODO: Navigate to the User Profile screen
                },
              ),
              const Divider(
                  color: Colors.black
              ),
              ListTile(
                trailing: const Icon(Icons.settings),
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the side menu
                  // TODO: Navigate to the Settings screen
                },
              ),
              const Divider(
                  color: Colors.black
              ),
              ListTile(
                trailing: const Icon(Icons.link),
                title: const Text(
                  'Linked Accounts',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the side menu
                  // TODO: Navigate to the Linked Accounts screen
                },
              ),
              const Divider(
                color: Colors.black
              ),
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
                  await _authService.signOut(context);
                },
              ),
              const Divider(
                  color: Colors.black
              ),
            ],
          ),
        ),
      ),
    );
  }
}
