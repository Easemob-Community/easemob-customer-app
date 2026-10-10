import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessage {
  final String id;
  final String senderType;
  final String senderId;
  final String msgType;
  final String content;
  final String status;
  final DateTime createTime;
  final String? bizType;

  ChatMessage({
    required this.id,
    required this.senderType,
    required this.senderId,
    required this.msgType,
    required this.content,
    this.status = 'sent',
    required this.createTime,
    this.bizType,
  });
}

class MessageNotifier extends StateNotifier<List<ChatMessage>> {
  MessageNotifier() : super([]);

  void append(ChatMessage m) {
    state = [...state, m];
  }

  void prepend(List<ChatMessage> list) {
    state = [...list, ...state];
  }

  String appendLocal(String text, {String senderType = 'USER', String senderId = ''}) {
    final id = 'local-${DateTime.now().millisecondsSinceEpoch}';
    append(ChatMessage(
      id: id,
      senderType: senderType,
      senderId: senderId,
      msgType: 'TXT',
      content: text,
      status: 'sending',
      createTime: DateTime.now(),
    ));
    return id;
  }

  void markSent(String id) {
    state = state.map((m) => m.id == id ? ChatMessage(
      id: m.id,
      senderType: m.senderType,
      senderId: m.senderId,
      msgType: m.msgType,
      content: m.content,
      status: 'sent',
      createTime: m.createTime,
    ) : m).toList();
  }

  void markFailed(String id) {
    state = state.map((m) => m.id == id ? ChatMessage(
      id: m.id,
      senderType: m.senderType,
      senderId: m.senderId,
      msgType: m.msgType,
      content: m.content,
      status: 'failed',
      createTime: m.createTime,
    ) : m).toList();
  }
}

final messageProvider = StateNotifierProvider<MessageNotifier, List<ChatMessage>>((ref) {
  return MessageNotifier();
});
