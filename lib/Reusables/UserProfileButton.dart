import 'package:flutter/material.dart';

class UserProfileButton extends StatelessWidget {
  const UserProfileButton({
    super.key, required this.title, required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {

      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red[100]!),
        elevation: MaterialStateProperty.all<double>(0.0),
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(200, 50),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: SizedBox(
        width: 200,
        height: 50,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.red[300],
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: Colors.black,
              ),
            ),

            //The expanded widget occupies the remaining space to push the
            //arrow icon to the end of the button.
            const Expanded(child: SizedBox()),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
