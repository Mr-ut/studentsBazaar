import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:students_bazaar/pages/chat_screen.dart';
import 'package:students_bazaar/service/chat_service.dart';

class ChatListScreen extends StatelessWidget {
  final ChatService _chatService = ChatService();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _chatService.getUserChats(),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No chats found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final chat = snapshot.data![index];
              final List<dynamic> participants = chat['participants'];

              // Ensure there are more than one participant and the list contains the current user
              if (participants.length > 1 && participants.contains(userId)) {
                final otherUserId = participants.firstWhere((uid) => uid != userId, orElse: () => null);

                if (otherUserId != null) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text('Chat with $otherUserId', style: TextStyle(color: Color.fromARGB(255, 94, 86, 98), fontWeight: FontWeight.bold),), 
                        visualDensity: VisualDensity(vertical: 4),
                        subtitle: Text(chat['lastMessage']['text'] ?? ''),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(chatId: chat.id, receiverId: otherUserId),
                            ),
                          );
                        },
                      ),
                      Divider(),
                    ],
                  );
                }
              }
              
              // Return an empty container if conditions are not met to prevent issues in ListView
              return Container();
            },

          );
        },
      ),
    );
  }
}
