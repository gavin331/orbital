import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbital_appllergy/service/AuthService.dart';

class LinkedAccounts extends StatefulWidget {
  const LinkedAccounts({Key? key}) : super(key: key);

  @override
  State<LinkedAccounts> createState() => _LinkedAccountsState();
}

class _LinkedAccountsState extends State<LinkedAccounts> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: const Text(
          'Linked Accounts',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.red[200],
          ),
          tabs: const [
            CustomTabsUI(text: 'Friends', icon: Icons.people),
            CustomTabsUI(text: 'Friend Requests', icon: Icons.notifications),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendList(),
          _buildFriendRequestList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Send Friend Request'),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _username,
                    decoration: const InputDecoration(
                      hintText: 'Enter Username',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                ),
                actions: [
                  //Send Button
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == true) {
                        // Manually sending the friend request using the add icon.
                        _sendFriendRequest(_authService.user?.displayName,
                            _username.text, 'Pending');
                        Navigator.of(context).pop(); // Close the dialog
                        }
                      },
                    child: const Text('Send'),
                  ),

                  //Cancel Button
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFriendList() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _firestore.collection('users').doc(_authService.user?.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userDoc = snapshot.data!;
          final friendList = userDoc.data()?['friendlist'] as List<dynamic>;

          return ListView.builder(
            itemCount: friendList.length,
            itemBuilder: (context, index) {
              final friendName = friendList[index].toString();
              return Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red[200],
                ),
                child: ListTile(
                  title: Text(friendName),
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () async {
                      // Remove friend from the list
                      await userDoc.reference.update({
                        'friendlist': FieldValue.arrayRemove([friendName]),
                      });
                      final friendRequestSnapshot = await _firestore.collection('friend_requests')
                          .where('senderName', isEqualTo: _authService.user?.displayName)
                          .where('receiverName', isEqualTo: friendName)
                          .get();
                      //Gets a list of all the documents included in this snapshot.
                      final friendRequestDocs = friendRequestSnapshot.docs;
                      if (friendRequestDocs.isNotEmpty) {
                        final friendRequestDoc = friendRequestDocs.first;
                        await friendRequestDoc.reference.delete();
                      }
                      setState(() {
                      });
                    },
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }


  Widget _buildFriendRequestList() {
    return StreamBuilder<QuerySnapshot>(
      /*
      Filtering through the database where receiverName is equal to the
      name of the current user.
       */
      stream: _firestore.collection('friend_requests')
          .where('receiverName', isEqualTo: _authService.user?.displayName)
          .where('status', isEqualTo: 'Pending')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final friendRequestDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: friendRequestDocs.length,
            itemBuilder: (context, index) {
              // Getting the senderName out of every document.
              final friendRequestDoc = friendRequestDocs[index];
              final friendRequestData = friendRequestDoc.data() as Map<String, dynamic>;
              final friendRequestSenderName = friendRequestData['senderName'];
              return Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red[200],
                ),
                child: ListTile(
                  title: Text(friendRequestSenderName),
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () async {
                          try {
                            // Accept friend request
                            await friendRequestDoc.reference.update({'status' : 'Accepted'});
                            //Update the friendlist in the sender document.
                            final userDocSnapshot = await _firestore.collection('users')
                                .where('username', isEqualTo: friendRequestSenderName)
                                .get();
                            final userDocs = userDocSnapshot.docs;
                            if (userDocs.isNotEmpty) {
                              final userDoc = userDocs.first;
                              await userDoc.reference.update({
                                'friendlist': FieldValue.arrayUnion(
                                    [_authService.user?.displayName]),
                              });
                            }
                            await _sendFriendRequest(_authService.user?.displayName,
                                friendRequestSenderName, 'Pending');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Friend request sent')),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          // Reject friend request
                          setState(() {
                            friendRequestDoc.reference.delete();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<void> _sendFriendRequest(String? sender, String? receiver, String status) async {
    try {
      final querySnapshot = await _firestore
          .collection('friend_requests')
          .where('senderName', isEqualTo: sender)
          .where('receiverName', isEqualTo: receiver)
          .get();

      if (querySnapshot.size > 0) {
        //TODO: This print message is just to debug for now.
        // A matching document already exists
        print('Friend request already sent');
        return;
      } else {
        await _firestore.collection('friend_requests').add({
          'receiverName': receiver,
          'senderName': sender,
          'status': status,
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend request sent')),
      );
    } catch (e) {
      print('Error sending friend request: $e');
    }
  }
}

class CustomTabsUI extends StatelessWidget {
  final String text;
  final IconData icon;

  const CustomTabsUI({Key? key, required this.text, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tab(text: text),
        const SizedBox(width: 10),
        Icon(icon),
      ],
    );
  }
}
