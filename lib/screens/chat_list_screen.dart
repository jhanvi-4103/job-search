// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_search_app/screens/job_seeker_chat_screen.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends StatelessWidget {
  final String jobSeekerId;

  ChatListScreen({super.key, required this.jobSeekerId});
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<DocumentSnapshot>> _fetchChats() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('chat_rooms')
              .where('participants', arrayContains: currentUserId)
              .orderBy('timestamp', descending: true)
              .get();
      return snapshot.docs;
    } catch (e) {
      print("❌ Error fetching chats: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chats",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _fetchChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading chats"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No chats available"));
          }

          final chatDocs = snapshot.data!;

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              var chat = chatDocs[index].data() as Map<String, dynamic>;
              String chatId = chatDocs[index].id;
              String companyName = chat['companyName'] ?? 'Unknown Company';
              String lastMessage = chat['lastMessage'] ?? 'No messages yet';
              Timestamp? timestamp = chat['timestamp'];
              String formattedTime =
                  timestamp != null
                      ? DateFormat('MMM d, hh:mm a').format(timestamp.toDate())
                      : 'No time available';
              int unreadMessages = chat['unreadMessages'] ?? 0;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.business, color: Colors.white),
                  ),
                  title: Text(
                    companyName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Text(
                        formattedTime,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                  trailing:
                      unreadMessages > 0
                          ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Text(
                              '$unreadMessages',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          : const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                  onTap: () {
                    String receiverId = chat['participants'].firstWhere(
                      (id) => id != currentUserId,
                      orElse: () => "Unknown",
                    );
                    FirebaseFirestore.instance
                        .collection('chat_rooms')
                        .doc(chatId)
                        .update({'unreadMessages': 0}); // Reset unread messages

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ChatScreen(
                              chatId: chatId,
                              receiverId: receiverId,
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
