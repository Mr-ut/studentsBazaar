import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:students_bazaar/service/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context); // Close the loading dialog
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Navigator.pop(context);
        print('Wrong password provided for that user.');
      }
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void googleSignIn() {
    AuthServices().signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              // logo
              // const Icon(
              //   Icons.circle,
              //   size: 130,
              //   color: Colors.white,
              // ),
              Image.asset('images/FaugetShop.png'),

              // const SizedBox(height: 25),

              // welcome back
              // Text(
              //   'Welcome back!',
              //   style: TextStyle(
              //     color: Colors.grey[700],
              //     fontSize: 16,
              //   ),
              // ),

              // const SizedBox(height: 25),

              // username textfield
              // MyTextfield(
              //   controller: emailController,
              //   hintText: 'Email',
              //   obscureText: false,
              // ),

              // const SizedBox(height: 20),

              // password textfield
              // MyTextfield(
              //   controller: passwordController,
              //   hintText: 'Password',
              //   obscureText: true,
              // ),
              // const SizedBox(height: 20),

              // forgot password
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       GestureDetector(
              //         onTap: () => {},
              //         child: Text(
              //           'Forgot Password?',
              //           style: TextStyle(color: Colors.grey[600]),
              //         ),
              //       ),
              //       GestureDetector(
              //         onTap: () => {},
              //         child: Text(
              //           'Sign up',
              //           style: TextStyle(color: Colors.grey[600]),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 25),

              //sign in button
              // MyButton(
              //   text: 'Sign In',
              //   onTap: signUserIn,
              // ),

              // const SizedBox(height: 30),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[700],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // google sign in button
              // MyGoogleButton(
              //   onTap: googleSignIn,
              // ),
              // GestureDetector(
              //     onTap: googleSignIn, child: Text('Google sign in')),
              GestureDetector(
                onTap: googleSignIn,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.symmetric(horizontal: 34.0),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Row(
                      children: [
                        // Icon(Icons.goo)
                        Image.asset(
                          'images/google.png',
                          width: 30,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Google Sign In',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
