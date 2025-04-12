// import 'dart:io'; // For mobile platforms
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html; // For web view

import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // For mobile resume viewing

import '../services/chat_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ChatScreen extends StatefulWidget {
  final String jobId;
  final String employerId;
  final String jobSeekerId;

  const ChatScreen({
    super.key,
    required this.jobId,
    required this.employerId,
    required this.jobSeekerId,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          _buildApplicantDetails(), // Sticky top section
          const Divider(),
          Expanded(child: _buildMessageList()), // Chat messages
          MessageInput(
            jobId: widget.jobId,
            employerId: widget.employerId,
            jobSeekerId: widget.jobSeekerId,
            onMessageSent: _scrollToBottom,
          ),
        ],
      ),
    );
  }

  Future<void> _viewResume(String url) async {
    try {
      if (kIsWeb) {
        html.window.open(url, '_blank');
      } else {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch resume';
        }
      }
    } catch (e) {
      print("View resume error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to open resume")));
    }
  }

  // 👤 Applicant Details (Sticky Top Section)
  Widget _buildApplicantDetails() {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance
              .collection('job_seeker_profiles')
              .doc(widget.jobSeekerId)
              .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData ||
            !snapshot.data!.exists ||
            snapshot.data!.data() == null) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Applicant data not found."),
          );
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;
        String? resumeUrl = userData['resumeUrl'];

        return Container(
          width: double.infinity,
          color: Colors.blue.shade50,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name: ${userData['name'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                "Email: ${userData['email'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              if (userData['skills'] != null)
                Text(
                  "Skills: ${userData['skills']}",
                  style: const TextStyle(fontSize: 16),
                ),
              if (userData['experience'] != null)
                Text(
                  "Experience: ${userData['experience']} years",
                  style: const TextStyle(fontSize: 16),
                ),
              if (resumeUrl != null && resumeUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("View Resume"),
                    onPressed: () => _viewResume(resumeUrl),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // 💬 Chat Messages
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.jobId, widget.jobSeekerId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!;
        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var msg = messages[index];
            bool isMe = msg.senderId == widget.employerId;
            return MessageBubble(text: msg.message, isMe: isMe);
          },
        );
      },
    );
  }

  // 🔽 Scroll to Bottom on Message Sent
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}
