import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:students_bazaar/home.dart';
import 'package:students_bazaar/home_page.dart';
import 'package:students_bazaar/login_page.dart';
import 'package:students_bazaar/pages/chat_list_screen.dart';
import 'package:students_bazaar/pages/chat_page.dart';
import 'package:students_bazaar/pages/profile_page.dart';
import 'package:students_bazaar/pages/sell_item_page.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
