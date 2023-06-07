import 'package:flutter/material.dart';
import '../service/AuthService.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {

    TabController _tabController = TabController(length: 3, vsync: this);

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

            //Menu
            Container(
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  indicator: BoxDecoration(
                    color: Colors.red[300], //Color when the tab is pressed.
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  tabs: const [
                    Tab(text: 'Your Allergens'),
                    Tab(text: 'Allergenic Foods'),
                    Tab(text: 'Your Symptoms'),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Container(
                color: Colors.red[100],
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    //TODO: Replace all these with their respective screens,
                    //TODO: maybe a list view? Example given below.
                    Text('Your Allergens Screen'),
                    Text('Allergenic Foods Screen'),
                    Text('Your Symptoms Screen'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
Flexible(
  child: Container(
    color: Colors.red[100],
    child: TabBarView(
      controller: _tabController,
      children: [
        ListView(
          children: const [
            // Content for Your Allergens tab
            ListTile(title: Text('Allergen 1')),
            ListTile(title: Text('Allergen 2')),
            ListTile(title: Text('Allergen 3')),
            // ...
          ],
        ),
        ListView(
          children: const [
            // Content for Allergenic Foods tab
            ListTile(title: Text('Food 1')),
            ListTile(title: Text('Food 2')),
            ListTile(title: Text('Food 3')),
            // ...
          ],
        ),
        ListView(
          children: const [
            // Content for Your Symptoms tab
            ListTile(title: Text('Symptom 1')),
            ListTile(title: Text('Symptom 2')),
            ListTile(title: Text('Symptom 3')),
            // ...
          ],
        ),
      ],
    ),
 */