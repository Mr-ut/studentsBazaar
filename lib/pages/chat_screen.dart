import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String receiverId;
// also get the product name to distinguish between chats of same user.
  ChatScreen({required this.chatId, required this.receiverId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.receiverId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages found.'));
                }

                return ListView(
                  padding: EdgeInsets.all(8.0),
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> message = document.data() as Map<String, dynamic>;

                    bool isSentByUser = message['senderId'] == userId;

                    return Align(
                      alignment: isSentByUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: isSentByUser ? Colors.blue[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isSentByUser ? 'You' : widget.receiverId,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              message['text'],
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              message['timestamp'] != null
                                  ? DateTime.fromMillisecondsSinceEpoch(
                                          message['timestamp'].millisecondsSinceEpoch)
                                      .toString()
                                  : '',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () async {
                    if (_controller.text.isNotEmpty) {
                      await _sendMessage(
                          userId, widget.receiverId, _controller.text);
                      _controller.clear();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.send, size: 35, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(
      String senderId, String receiverId, String text) async {
    try {
      final chatRef = _firestore.collection('chats').doc(widget.chatId);

      final messageData = {
        'senderId': senderId,
        'receiverId': receiverId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Update the last message for the chat
      await chatRef.set({
        'lastMessage': messageData,
        'participants': [senderId, receiverId],
      });

      // Add the message to the messages subcollection
      final messageRef = chatRef.collection('messages').doc();
      await messageRef.set(messageData);
    } catch (e) {
      print('Error sending message: $e');
      // Handle error
    }
  }
}
