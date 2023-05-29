import 'package:flutter/material.dart';
import 'package:orbital_appllergy/service/AuthService.dart';
import 'Register.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  //text controllers
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();

  @override
  void dispose() {
    //Dispose the controller when its no longer needed to avoid memory leak.
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.red[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Logo
                  Image.asset(
                    'assets/apple.png',
                    height: 200,
                  ),
                  const SizedBox(height:10),

                  //Name of the app
                  const Text(
                    'Appllergy',
                    style: TextStyle(
                      fontSize: 40.0,
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
                    authService.error,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height:10),

                  //Sign In
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await authService.signIn(_email.text.trim(), _password.text.trim(), context);
                        } else {
                          authService.error = 'Please fill in your details';
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
                    children: [
                      const Text(
                        'Not a member?',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder: (context) => const Register()
                             )
                           );
                        },
                        child: const Text(
                          'Register now!',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
