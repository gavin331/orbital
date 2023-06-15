import 'package:flutter/material.dart';

class EmergencyCallButton extends StatelessWidget {
  const EmergencyCallButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Implement the call function.
    return CircleAvatar(
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
    );
  }
}
