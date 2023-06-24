import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbital_appllergy/service/AuthService.dart';
import 'package:orbital_appllergy/service/FirestoreService.dart';

class LinkedAccounts extends StatefulWidget {
  const LinkedAccounts({Key? key}) : super(key: key);

  @override
  State<LinkedAccounts> createState() => _LinkedAccountsState();
}

class _LinkedAccountsState extends State<LinkedAccounts> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String? userDisplayName = AuthService().user?.displayName;
  final FireStoreService _fireStoreService = FireStoreService();

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
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final formKey = GlobalKey<FormState>();
              final TextEditingController username = TextEditingController();
              return AlertDialog(
                title: const Text('Send Friend Request'),
                content: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: username,
                    decoration: const InputDecoration(
                      hintText: 'Enter Username',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      } else if (value == userDisplayName) {
                        return 'Do not enter your own username';
                      }
                      return null;
                    },
                  ),
                ),
                actions: [
                  //Send Button
                  TextButton(
                    onPressed: () async {
                      if (formKey.currentState?.validate() == true) {
                        String name = username.text;
                        bool usernameExists = await _fireStoreService.findUsernameInDatabase(name);
                        // Manually sending the friend request using the add icon.
                        if (usernameExists) {
                          try {
                            await _fireStoreService.sendFriendRequest(userDisplayName,
                                username.text, 'Pending');
                            // do the check for context.mounted to remove
                            //'Don't use BuildContext across async gaps' warning.
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Friend Request Sent')),
                              );
                            }
                          } catch (e) {
                            String error = 'You have already sent a friend request';
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error)),
                              );
                            }
                          }
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Username does not exist')),
                            );
                            Navigator.of(context).pop(); // Close the dialog
                          }
                        }
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
    return Center(
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _fireStoreService.getUserDocSnapshot(),
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
                        await _fireStoreService.removeFriend(userDoc, friendName);
                        await _fireStoreService.deleteFriendRequest(friendName);
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Removed from friend list')),
                          );
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
      ),
    );
  }


  Widget _buildFriendRequestList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStoreService.getFriendRequests(),
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
                            await _fireStoreService.acceptFriendRequest(friendRequestDoc, friendRequestSenderName);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Accepted friend request')),
                              );
                            }
                            if (await _fireStoreService
                                .validateFriendRequestHistory(userDisplayName, friendRequestSenderName)) {
                              if (context.mounted) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Friend request accepted'),
                                        content: const Text('Send friend request back?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              try {
                                                await _fireStoreService.sendFriendRequest(userDisplayName,
                                                    friendRequestSenderName, 'Pending');
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Friend request sent')),
                                                  );
                                                }
                                              } catch (e) {
                                                String error = 'You have already sent a friend request';
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text(error)),
                                                );
                                              }
                                              if (context.mounted) {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: const Text('OK'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      );
                                    }
                                );
                              }
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('An error occurred')),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          // Reject friend request
                          setState(() {
                            _fireStoreService.rejectFriendRequest(friendRequestDoc);
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
