import 'package:flutter/material.dart';
import '../../../store/message_provider.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.senderType == 'USER';
    final isSystem = message.senderType == 'SYSTEM';

    if (isSystem) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message.content,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF3B6CFF) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.senderId,
              style: TextStyle(fontSize: 12, color: isUser ? Colors.white70 : Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              message.content,
              style: TextStyle(color: isUser ? Colors.white : Colors.black87),
            ),
            if (message.status == 'sending')
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            if (message.status == 'failed')
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Icon(Icons.error_outline, size: 14, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
