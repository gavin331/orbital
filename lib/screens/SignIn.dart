import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Logo
                const Icon(Icons.apple, size: 100),
                const SizedBox(height:10),

                //Name of the app
                const Text(
                  'Appllergy',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontFamily: 'Poppins'
                  ),
                ),
                const SizedBox(height:30),

                //Username
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(10,0,0,0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height:20),

                //Password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(10,0,0,0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height:20),

                //Sign In
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      //Go to Home screen
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
                        'Sign In',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins'
                      ),
                    ),
                  ),
                ),
                const SizedBox(height:10),

                //Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                        'Not a member?',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Register now!',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
