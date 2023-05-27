import 'package:flutter/material.dart';
import 'HomePage.dart';

class SuccessfulRegistration extends StatelessWidget {
  const SuccessfulRegistration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/welcome.png',
              height: 200,
            ),
            const SizedBox(height: 30),
            const Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 45,
                fontFamily: 'Poppins',
              ),
            ),
            const Text(
              'Click next to enjoy our full features!',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomePage()
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Button text style
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Button border radius
                    ),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins'
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
