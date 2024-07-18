import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:students_bazaar/pages/chat_page.dart';
import 'package:students_bazaar/pages/chat_screen.dart';
import 'package:students_bazaar/pages/notification_page.dart';
import 'package:students_bazaar/pages/profile_page.dart';
import 'package:students_bazaar/pages/sell_item_page.dart';
import 'package:students_bazaar/service/chat_service.dart';

class HomePage extends StatelessWidget {
  final ChatService _chatService = ChatService();
  final _auth = FirebaseAuth.instance;

  void sendBuyRequest(String buyerId, String sellerId,String productId, double price) async {
    await FirebaseFirestore.instance.collection('buy_requests').add({
      'buyerId': buyerId,
      'sellerId': sellerId,
      'productId': productId,
      'price':price,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      // backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Buy Items',
        ),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),
          IconButton(
            icon: Icon(
              Icons.notifications,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationPage()));
            },
          ),
        ],
      ),
      body: StreamBuilder(
        // stream: FirebaseFirestore.instance.collection('products').snapshots(),
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('sellerId', isNotEqualTo: user!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          var products = snapshot.data!.docs;

          return GridView.builder(
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.9, // Adjust as needed
            ),
            itemBuilder: (context, index) {
              var product = products[index];
              return GestureDetector(
                onTap: () async {
                  // Increment view count
                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(product.id)
                      .update({'views': FieldValue.increment(1)});

                  // Show product details dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(product['name']),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(
                              product['image'],
                              height: 120,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 10),
                            Text(product['description']),
                            SizedBox(height: 10),
                            Text('Views: ${product['views'] ?? 0}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Handle buy now action
                              sendBuyRequest(user!.uid,product['sellerId'], product.id, product['price']);
                              Navigator.of(context).pop();
                            },
                            iconAlignment: IconAlignment.start,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Buy Now',
                                style: TextStyle(color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              String sellerId = product['sellerId'];
                              String chatId = await _chatService.getChatId(
                                  user.uid, sellerId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                      chatId: chatId, receiverId: sellerId),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Chat',
                                style: TextStyle(color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5.0,
                      ),
                      // Adjust height and width as needed
                      Image.network(product['image'],
                          height: 120, width: 150, fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(product['name'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text('\₹${product['price']}',
                                    style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                            // IconButton(
                            //   onPressed: () async {
                            //     String sellerId = product['sellerId'];
                            //     String chatId = await _chatService.getChatId(
                            //         user!.uid, sellerId);
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) =>
                            //             ChatScreen(chatId: chatId, receiverId: sellerId),
                            //       ),
                            //     );
                            //   },
                            //   icon: Icon(Icons.chat),
                            // ),
                            Column(
                              children: [
                                Icon(Icons.remove_red_eye),
                                Text('${product['views']}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        var products = snapshot.data!.docs;

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            var product = products[index];
            return ListTile(
              leading: Image.network(product['image']),
              title: Text(product['name']),
              subtitle: Text('\$${product['price']}'),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        var products = snapshot.data!.docs;

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            var product = products[index];
            return ListTile(
              // leading: Image.network(product['image']),
              title: Text(product['name']),
              subtitle: Text('\$${product['price']}'),
            );
          },
        );
      },
    );
  }
}
