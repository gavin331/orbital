import 'package:flutter/material.dart';

class EmergencySettings extends StatefulWidget {
  const EmergencySettings({Key? key}) : super(key: key);

  @override
  State<EmergencySettings> createState() => _EmergencySettingsState();
}

class _EmergencySettingsState extends State<EmergencySettings> {
  /*
  TODO: If have time, we can import libphonenumber package to check for
  the correct phone number format for different regions.
  Right now, the listtiles data will disappear if i exit the screen and
  enter again. shared_preferences package may help to solve this but maybe
  its something to do with firebase also im not sure =].
  */

  List<String> contacts = [];
  final _formKey = GlobalKey<FormState>();

  void _addContact() {
    String contactName = '';
    String phoneNumber = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Contact'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a contact name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    contactName = value;
                  },
                  decoration: _CustomInputDecoration(
                    hintText: 'Contact Name',
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    } else if (!RegExp(r'^\+?[0-9\s]+$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                  decoration: _CustomInputDecoration(
                    hintText: 'Phone Number',
                    labelText: 'Number',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if(_formKey.currentState?.validate() == true) {
                  String contactData = '$contactName - $phoneNumber';
                  setState(() {
                    contacts.add(contactData);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
  }

  void _editContact(int index) {
    String contactData = contacts[index];
    List<String> splitData = contactData.split(" - ");
    String contactName = splitData[0];
    String phoneNumber = splitData[1];
    String editedContactName = contactName;
    String editedPhoneNumber = phoneNumber;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Contact'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: contactName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a contact name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    editedContactName = value;
                  },
                  decoration: _CustomInputDecoration(
                    hintText: 'Contact Name',
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: phoneNumber,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    } else if (!RegExp(r'^\+?[0-9\s]+$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    editedPhoneNumber = value;
                  },
                  decoration: _CustomInputDecoration(
                    hintText: 'Phone Number',
                    labelText: 'Number',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if(_formKey.currentState?.validate() == true) {
                  String editedContactData = '$editedContactName - $editedPhoneNumber';
                  setState(() {
                    contacts[index] = editedContactData;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  //gets the initials of the name. (Up to 2 initials).
  String _getInitials(String contactName) {
    List<String> splitName = contactName.split(" ");
    if (splitName.length > 1) {
      return splitName[0][0].toUpperCase() + splitName[1][0].toUpperCase();
    } else {
      return splitName[0][0].toUpperCase();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: const Text(
          'Emergency Contacts',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          //TODO: Cache this circleAvatar into the Reusables folder
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
            const SizedBox(height: 20),
            const Icon(
              Icons.contact_emergency,
              color: Colors.blue,
              size: 30,
            ),
            const SizedBox(height: 10),
            const Text(
              'These contacts will be notified in case of an emergency',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  String contactData = contacts[index];
                  List<String> splitData = contactData.split(" - ");
                  String contactName = splitData[0];
                  String contactNumber = splitData[1];
                  return Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue[200],
                    ),
                    child: ListTile(
                      title: Text(
                        contactName,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                      subtitle: Text(
                        contactNumber,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),

                      //Outer CircleAvatar is to create a border outline.
                      leading: CircleAvatar(
                        backgroundColor: Colors.red[300],
                        radius: 30,
                        child: CircleAvatar(
                          radius: 25,
                          child: Text(
                            _getInitials(contactName),
                          ),
                        ),
                      ),
                      trailing: Row(
                        //So that the icons are positioned correctly at the end of the row.
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              _editContact(index);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              _deleteContact(index);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );  
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addContact();
        },
        backgroundColor: Colors.red[300],
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CustomInputDecoration extends InputDecoration {
  _CustomInputDecoration({required String hintText, required String labelText}) :
        super(
        hintText: hintText,
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.red),
        ),
      );
}



