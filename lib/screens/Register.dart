import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbital_appllergy/screens/SuccessfulRegistration.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String error = "";
  FirebaseAuth fireBaseInstance = FirebaseAuth.instance;

  //Dispose the controller when its no longer needed to avoid memory leak.
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    /*
    register method is inside the build function because i need access to the
    context in order to switch screens.
     */
    Future register() async {
      try {
        await fireBaseInstance.createUserWithEmailAndPassword(
            email: _email.text.trim(),
            password: _password.text.trim()
        );
        //TODO: Bring user to home screen or a screen that welcomes them.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SuccessfulRegistration()),
        );
      } on FirebaseAuthException catch(e) {
        if (e.code == "email-already-in-use") {
          setState(() => error = 'This email is already in use');
        } else {
          print('hello1');
          setState(() => error = 'An error occurred. Please try again later.');
        }
      } catch (e) {
        print("hello2");
        setState(() => error = 'An error occurred. Please try again later.');
      }
    }

    //Register Screen UI
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        title: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Name of the app
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const Text(
                    'To join the Appllergy community!',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height:30),

                  //Email
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: TextFormField(
                          controller: _email,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$',)
                            .hasMatch(value)){
                              return 'Please enter a valid email';
                            }
                          },
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10,0,0,0),
                        child: TextFormField(
                          controller: _password,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            } else if (value.length < 6) {
                              return 'Password length must be at least 6 characters';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height:20),

                  //Confirm Password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10,0,0,0),
                        child: TextFormField(
                          controller: _confirmPassword,
                          decoration: const InputDecoration(
                            hintText: 'Confirm Password',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            } else if (value != _password.text.trim()){
                              return 'Password do not match!';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height:20),

                  Text(
                    error,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height:10),

                  //Register
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          register();
                        }
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
                        'Register',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins'
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height:10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
