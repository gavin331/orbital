import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbital_appllergy/service/AuthService.dart';
import 'SuccessfulRegistration.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Text controllers
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  String error = '';

  //Dispose the controller when its no longer needed to avoid memory leak.
  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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

                  //Username
                  _CustomTextField(controller: _username, hintText: 'Username',
                      prefixIcon: Icons.person, obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      }),
                  const SizedBox(height:20),

                  //Email
                  _CustomTextField(controller: _email, hintText: 'Email',
                      prefixIcon: Icons.email, obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$',)
                            .hasMatch(value)){
                          return 'Please enter a valid email';
                        }
                        return null;
                      }),
                  const SizedBox(height:20),

                  //Password
                  _CustomTextField(controller: _password, hintText: 'Password',
                      prefixIcon: Icons.lock, obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 6) {
                          return 'Password length must be at least 6 characters';
                        } else {
                          return null;
                        }
                      }),
                  const SizedBox(height:20),

                  //Confirm Password
                  _CustomTextField(controller: _confirmPassword,
                      hintText: 'Confirm Password',
                      prefixIcon: Icons.lock, obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != _password.text){
                          return 'Password do not match!';
                        } else {
                          return null;
                        }
                      }),
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await authService.register(_email.text,
                                _password.text, _username.text);
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const SuccessfulRegistration()),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'username-already-taken') {
                              error = 'This username has already been taken';
                            } else if (e.code == "email-already-in-use") {
                              error = 'This email is already in use';
                            } else {
                              error = 'An error occurred. Please try again later.';
                            }
                          } catch (e) {
                            error = 'An error occurred. Please try again later.';
                          }
                        } else {
                          error = "";
                        }
                        setState(() {
                        });
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

class _CustomTextField extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;

  const _CustomTextField({Key? key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.obscureText,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 12),
                child: Icon(prefixIcon),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
            obscureText: obscureText,
            validator: validator,
          ),
        ),
      ),
    );
  }
}
