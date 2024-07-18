import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:students_bazaar/home.dart';
import 'package:students_bazaar/home_page.dart';
import 'package:students_bazaar/login_page.dart';
import 'package:students_bazaar/pages/notification_page.dart';
import 'package:students_bazaar/pages/product_list_page.dart';
import 'package:students_bazaar/pages/sell_item_page.dart';
import 'package:students_bazaar/pages/transaction_history_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      // backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Profile'),
        // backgroundColor: Color.fromARGB(255, 23, 143, 241),
        leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 140.0),
            child: CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(
                  user?.photoURL ?? 'https://via.placeholder.com/150'),
            ),
          ),
          SizedBox(height: 20),
          Text(
            user?.displayName ?? 'No Name',
            style: TextStyle(fontSize: 26),
          ),
          Text(user?.email ?? 'No Email'),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SellItemPage()));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sell Item',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(8),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductListPage()));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'See Your Products',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(8),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TransactionHistoryPage()));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transactions',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(8),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationPage()));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(8),
            ),
          ),
          GestureDetector(
            onTap: () async {
              print('Log Out');
              try {
                // Sign out from Firebase
                await FirebaseAuth.instance.signOut();

                // Sign out from Google
                await GoogleSignIn().signOut();

                // Optionally, navigate the user to the login screen or another appropriate screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              } catch (e) {
                print('Error signing out: $e');
                // Handle error gracefully, show a message to the user if needed
              }
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Log Out',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.red),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(8),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          Text('Developed By Utkarsh Raja'),
        ],
      ),
    );
  }
}
