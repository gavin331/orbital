import 'package:flutter/material.dart';
import '../Reusables/UserProfileButton.dart';
import '../service/AuthService.dart';

class UserProfile extends StatelessWidget {
  UserProfile({Key? key}) : super(key: key);

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: const Text('User Profile'),
        centerTitle: true,
        elevation: 0,
        actions: [
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
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // User Profile Pic with username(to be implemented)
            // and password below
            Stack(
              children: [
                const SizedBox(
                  width: 120,
                  height: 120,
                  child: CircleAvatar(
                      child: Icon(Icons.person, size: 50),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width:35,
                    height:35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.red[100],
                    ),
                    child: const Icon(
                      Icons.edit,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Mom',
              style: TextStyle(
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
            const Divider(color: Colors.black),
            const SizedBox(height: 20),

            //Menu
            const UserProfileButton(title: 'My Allergens', icon: Icons.warning),
            const SizedBox(height: 20),
            const UserProfileButton(title: 'Allergenic foods', icon: Icons.fastfood_sharp),
            const SizedBox(height: 20),
            const UserProfileButton(title: 'My Symptoms', icon: Icons.sick),
          ],
        ),
      ),
    );
  }
}