import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Future<List<DocumentSnapshot>> getUserChats() async {
  //   final userId = _auth.currentUser!.uid;
  //   QuerySnapshot chatSnapshot = await _firestore
  //       .collection('users')
  //       .doc(userId)
  //       .collection('chats')
  //       .orderBy('lastMessage.timestamp', descending: true)
  //       .get();

  //   return chatSnapshot.docs;
  // }
  Future<List<DocumentSnapshot>> getUserChats() async {
    final userId = _auth.currentUser!.uid;
    QuerySnapshot chatQuery = await _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .get();
    return chatQuery.docs;
  }

  Future<DocumentSnapshot> getUserById(String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }

  Future<String> getChatId(String userId1, String userId2) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId1)
        .collection('chats')
        .where('participants', arrayContains: userId2)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      // Create a new chat document if none exists
      final newChatRef =
          _firestore.collection('users').doc(userId1).collection('chats').doc();
      await newChatRef.set({
        'participants': [userId1, userId2],
        // Optionally initialize with an initial message if needed
        'lastMessage': {
          'senderId': '',
          'text': '',
          'timestamp': FieldValue.serverTimestamp(),
        },
      });
      return newChatRef.id;
    }
  }
}
