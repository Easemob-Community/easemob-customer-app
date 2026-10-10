import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSend;
  final VoidCallback onTransfer;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onTransfer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: onTransfer,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF3B6CFF),
            ),
            child: const Text('转人工'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '请输入...',
                border: InputBorder.none,
              ),
              onSubmitted: onSend,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF3B6CFF)),
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) onSend(text);
            },
          ),
        ],
      ),
    );
  }
}
