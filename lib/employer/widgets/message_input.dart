// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../services/chat_service.dart';

class MessageInput extends StatefulWidget {
  final String jobId;
  final String employerId;
  final String jobSeekerId;
  final VoidCallback onMessageSent;

  const MessageInput({
    super.key,
    required this.jobId,
    required this.employerId,
    required this.jobSeekerId,
    required this.onMessageSent,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 25,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      await _chatService.sendMessage(
        widget.jobId,
        widget.employerId,
        widget.jobSeekerId,
        _messageController.text.trim(),
        DateTime.now().toString(),
      );

      _messageController.clear();
      widget.onMessageSent();
    }
  }
}
