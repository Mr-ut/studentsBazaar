import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .where('userId', isEqualTo: user?.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No transactions found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var transaction = snapshot.data!.docs[index];
              String type = transaction['type'];
              double price = transaction['price'];
              String formattedPrice = type == 'sale' ? '+₹$price' : '-₹$price';
              Color priceColor = type == 'sale' ? Colors.green : Colors.red;

              return ListTile(
                title: Text(
                  type == 'sale' ? 'Sold Item' : 'Bought Item',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Transaction ID: ${transaction.id}\nTimestamp: ${transaction['timestamp'].toDate()}',
                ),
                trailing: Text(
                  formattedPrice,
                  style: TextStyle(color: priceColor, fontSize: 16),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
