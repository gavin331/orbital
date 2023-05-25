import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbital_appllergy/screens/SignIn.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    /* ! means that we are sure that the currentUser, which is nullable, is not
    null at this point of time. Since we are in the home page, the user
    is definitely not null hence its safe to use !.
     */

    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Temporary home page'),
            Text('Signed in as: ${user.email!}'),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignIn()
                    ),
                  );
                },
                child: const Text('Log Out'),
            ),
          ],
        ),
      )
    );
  }
}
