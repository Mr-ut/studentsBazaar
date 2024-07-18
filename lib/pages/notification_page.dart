import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('buy_requests')
            .where('sellerId', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notifications found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var request = snapshot.data!.docs[index];
              return ListTile(
                title: Text('Request from ${request['buyerId']}'),
                subtitle: Text('Status: ${request['status']}'),
                trailing: request['status'] == 'pending'
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              approveRequest(request.id, request['buyerId'],
                                  request['price'], request['productId']);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              rejectRequest(request.id);
                            },
                          ),
                        ],
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }

  void approveRequest(
      String requestId, String buyerId, double price, String productId) async {
    final sellerId = _auth.currentUser!.uid;

    // Update the request status to approved
    await FirebaseFirestore.instance
        .collection('buy_requests')
        .doc(requestId)
        .update({'status': 'approved'});

    // Optionally, update the product status to sold
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({'status': 'sold'});

    // Add transaction entry for the buyer
    await FirebaseFirestore.instance.collection('transactions').add({
      'userId': buyerId,
      'type': 'purchase',
      'price': price,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Add transaction entry for the seller
    await FirebaseFirestore.instance.collection('transactions').add({
      'userId': sellerId,
      'type': 'sale',
      'price': price,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void rejectRequest(String requestId) async {
    await FirebaseFirestore.instance
        .collection('buy_requests')
        .doc(requestId)
        .update({'status': 'rejected'});
  }
}
