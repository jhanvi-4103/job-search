// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  /// Generates a unique chat room ID based on job ID and job seeker ID
  String _generateChatRoomID(String jobId, String jobSeekerId) {
    return "$jobId-$jobSeekerId";
  }

  /// Fetch chat list for job seekers (conversations with employers)
  Stream<List<Map<String, dynamic>>> getChatList() {
    final firebase_auth.User? currentUser = _auth.currentUser;
    if (currentUser == null) return const Stream.empty();

    return _firestore
        .collection("chat_rooms")
        .where("participants", arrayContains: currentUser.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Send text message
  Future<void> sendMessage(
    String jobId,
    String employerId,
    String jobSeekerId,
    String message,
    String dateTime,
  ) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null || message.isEmpty) return;

    String senderID = currentUser.uid;
    String chatRoomID = _generateChatRoomID(jobId, jobSeekerId);
    Timestamp timestamp = Timestamp.now();

    DocumentSnapshot employerSnapshot =
        await _firestore.collection('employers').doc(employerId).get();

    String companyName = '';
    if (employerSnapshot.exists) {
      Map<String, dynamic> data =
          employerSnapshot.data() as Map<String, dynamic>;
      companyName = data['companyName'] ?? '';
    }

    ChatMessage newMessage = ChatMessage(
      senderId: senderID,
      message: message,
      timestamp: timestamp.toDate(),
      receiverId: jobSeekerId,
    );

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());

    await _firestore.collection('chat_rooms').doc(chatRoomID).set({
      'jobId': jobId,
      'employerId': employerId,
      'jobSeekerId': jobSeekerId,
      'participants': [employerId, jobSeekerId],
      'lastMessage': message,
      'timestamp': timestamp,
      'companyName': companyName,
    }, SetOptions(merge: true));
  }

  /// Fetch messages for a specific chat room
  Stream<List<ChatMessage>> getMessages(String jobId, String jobSeekerId) {
    String chatRoomID = _generateChatRoomID(jobId, jobSeekerId);
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ChatMessage.fromMap(doc.data()))
                  .toList(),
        );
  }

  /// Delete a message
  Future<void> deleteMessage(
    String messageID,
    String jobId,
    String jobSeekerId,
  ) async {
    try {
      String chatRoomID = _generateChatRoomID(jobId, jobSeekerId);
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .doc(messageID)
          .delete();
      print("Message deleted successfully.");
    } catch (e) {
      print("Failed to delete message: $e");
    }
  }

  /// Mark a message as deleted (instead of hard delete)
  Future<void> markMessageAsDeleted(
    String messageID,
    String jobId,
    String jobSeekerId,
  ) async {
    try {
      String chatRoomID = _generateChatRoomID(jobId, jobSeekerId);
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .doc(messageID)
          .update({'message': 'This message was deleted.', 'isDeleted': true});
      print("Message marked as deleted.");
    } catch (e) {
      print("Failed to mark message as deleted: $e");
    }
  }
}
