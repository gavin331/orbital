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
                            // Do the check for context.mounted to remove
                            //'Don't use BuildContext across async gaps' warning.
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Friend Request Sent')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('You have already sent a friend request')),
                              );
                            }
                          }

                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Username does not exist')),
                            );
                          }
                        }
                        // Pop the alertdialog from the screen.
                        if (context.mounted) {
                          Navigator.of(context).pop();
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

  //Builds the friend list in the LinkedAccounts screen
  Widget _buildFriendList() {
    return Center(
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _fireStoreService.getUserDocSnapshot(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userDoc = snapshot.data!;
            final friendList = userDoc.data()?['friendlist'] as List<dynamic>;
            return ListView.builder(
              key: const Key('friendList'),
              itemCount: friendList.length,
              itemBuilder: (context, index) {
                final friendName = friendList[index].toString();
                return FutureBuilder<String?>(
                  future: _fireStoreService.getFriendImageUrl(friendName),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While waiting for the image to load, you can show a placeholder or loading indicator
                      return const ListTile(
                        title: Text('Loading...'),
                        leading: SizedBox(
                          width: 24, // Set the desired width
                          height: 24, // Set the desired height
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else {
                      /*
                      This body runs if the returned value of the future is not null. ie. snapshot.hasData == true
                      However, if the user has no profile pic (future method returns a null),
                      then we can check for it by using snapshot.connectionState == connectionState.done
                       */
                      final imageUrl = snapshot.data;
                      return Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red[200],
                        ),
                        child: ExpansionTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(friendName),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await _fireStoreService.removeFriend(userDoc, friendName);
                                  await _fireStoreService.deleteFriendRequest(friendName);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Removed from friend list')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: SizedBox(
                              //Set a fixed width and height for the friend's profile picture.
                              width: 40,
                              height: 40,
                              child: imageUrl != null
                                  ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              )
                                  : const CircleAvatar(
                                child: Icon(Icons.person, size: 30),
                              ),
                            ),
                          ),
                          trailing: const Icon(Icons.expand_more),
                          children: [
                            DefaultTabController(
                              length: 3,
                              child: Column(
                                children: [
                                  const TabBar(
                                    tabs: [
                                      Tab(text: 'Allergens'),
                                      Tab(text: 'Allergic Foods'),
                                      Tab(text: 'Symptoms'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 150, // Adjust the height as per your requirement
                                    child: TabBarView(
                                      children: [
                                        //Allergens content
                                        StreamBuilder(
                                          stream: _fireStoreService.getFriendDocStream(friendName),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final friendDoc = snapshot.data!;
                                              final friendAllergenList = friendDoc.data()?['allergens'] as List<dynamic>;
                                              return ListView.builder(
                                                itemCount: friendAllergenList.length,
                                                itemBuilder: (context, index) {
                                                  final allergenName = friendAllergenList[index].toString();
                                                  return ListTile(
                                                    title: Text(allergenName),
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

                                        // Allergenic Foods content
                                        StreamBuilder(
                                          stream: _fireStoreService.getFriendDocStream(friendName),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final friendDoc = snapshot.data!;
                                              final friendAllergenicFoods = friendDoc.data()?['allergenicfoods'] as List<dynamic>;
                                              return ListView.builder(
                                                itemCount: friendAllergenicFoods.length,
                                                itemBuilder: (context, index) {
                                                  final foodName = friendAllergenicFoods[index].toString();
                                                  return ListTile(
                                                    title: Text(foodName),
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

                                        // Symptoms content
                                        StreamBuilder(
                                          stream: _fireStoreService.getFriendDocStream(friendName),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final friendDoc = snapshot.data!;
                                              final friendSymptomsList = friendDoc.data()?['symptoms'] as List<dynamic>;
                                              return ListView.builder(
                                                itemCount: friendSymptomsList.length,
                                                itemBuilder: (context, index) {
                                                  final log = friendSymptomsList[index] as Map<String, dynamic>;
                                                  final logTitle = log['title'] as String;
                                                  final symptoms = log['mySymptoms'] as String;
                                                  final occurrenceDate = log['occurrenceDate'] as String;
                                                  final precautions = log['precautions'] as String;
                                                  return ExpansionTile(
                                                    title: logTitle != '' ? Text(logTitle) : const Text('No title'),
                                                    children: [
                                                      Text(
                                                        'Date: $occurrenceDate',
                                                        style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                      Text(
                                                        'Description: $symptoms',
                                                        style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                      Text(
                                                        'Precaution: $precautions',
                                                        style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                    ],
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
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

  //Builds the friend request list in the LinkedAccounts screen
  Widget _buildFriendRequestList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStoreService.getFriendRequests(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final friendRequestDocs = snapshot.data!.docs;
          return ListView.builder(
            key: const Key('friendRequestList'),
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
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('You have already sent a friend request')),
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
                          _fireStoreService.rejectFriendRequest(friendRequestDoc);
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

//CustomTabsUI to be used in the bottom properties in the AppBar widget.
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
