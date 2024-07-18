// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';

// class ChatPage extends StatefulWidget {
//   final String sellerId;

//   ChatPage(this.sellerId);

//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   late types.User _user;
//   List<types.Message> _messages = [];

//   @override
//   void initState() {
//     super.initState();
//     _user = types.User(id: _auth.currentUser!.uid);
//     _loadMessages();
//   }

//   void _loadMessages() async {
//     final chatId = _getChatId();
//     _firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('timestamp')
//         .snapshots()
//         .listen((snapshot) {
//       final messages = snapshot.docs.map((doc) {
//         final data = doc.data();
//         return types.TextMessage(
//           author: types.User(id: data['userId']),
//           createdAt: (data['timestamp'] as Timestamp).millisecondsSinceEpoch,
//           id: doc.id,
//           text: data['text'],
//         );
//       }).toList();

//       setState(() {
//         _messages = messages;
//       });
//     });
//   }

//   String _getChatId() {
//     return _auth.currentUser!.uid.compareTo(widget.sellerId) < 0
//         ? '${_auth.currentUser!.uid}_${widget.sellerId}'
//         : '${widget.sellerId}_${_auth.currentUser!.uid}';
//   }

//   void _handleSendPressed(types.PartialText message) async {
//     final chatId = _getChatId();
//     final messageId = _firestore.collection('chats').doc(chatId).collection('messages').doc().id;
//     final messageData = {
//       'userId': _user.id,
//       'text': message.text,
//       'timestamp': FieldValue.serverTimestamp(),
//     };
//     await _firestore.collection('chats').doc(chatId).collection('messages').doc(messageId).set(messageData);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with Seller'),
//       ),
//       body: Chat(
//         messages: _messages,
//         onSendPressed: _handleSendPressed,
//         user: _user,
//       ),
//     );
//   }
// }
