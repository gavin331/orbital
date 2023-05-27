import 'package:flutter/material.dart';
import 'package:orbital_appllergy/service/AuthService.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    AuthService authService = AuthService();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Temporary home page'),
            Text('Signed in as: ${authService.user?.email}'),
            ElevatedButton(
                onPressed: () async {
                  await authService.signOut(context);
                },
                child: const Text('Log Out'),
            ),
          ],
        ),
      )
    );
  }
}
