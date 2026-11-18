import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import '../store/message_provider.dart';

/// 环信 IM 消息监听：把群内消息(AI / 人工坐席)转成 ChatMessage 追加到列表。
/// 全局只注册一次，注册后整个 App 生命周期有效。
class MessageListener {
  static const String _handlerKey = 'cs-message-listener';
  static bool _registered = false;
  static final Set<String> _seenMsgIds = {};

  static void register({
    required void Function(ChatMessage message) onMessage,
    required String? Function() currentGroupId,
    required String? Function() currentUserId,
    required String? Function() currentAiId,
  }) {
    if (_registered) return;
    _registered = true;

    EMClient.getInstance.chatManager.addEventHandler(
      _handlerKey,
      EMChatEventHandler(
        onMessagesReceived: (List<EMMessage> messages) {
          final groupId = currentGroupId();
          final userId = currentUserId();
          final aiId = currentAiId();
          for (final msg in messages) {
            if (msg.chatType != ChatType.GroupChat) continue;
            if (groupId != null && msg.to != groupId) continue;
            // 自己发送的消息本地已追加,避免重复
            if (userId != null && msg.from == userId) continue;
            final id = msg.msgId;
            if (!_seenMsgIds.add(id)) continue;
            final body = msg.body;
            if (body is! EMTextMessageBody) continue;
            onMessage(ChatMessage(
              id: id,
              senderType: msg.from == aiId ? 'AI' : 'AGENT',
              senderId: msg.from ?? '',
              msgType: 'TXT',
              content: body.content,
              status: 'sent',
              createTime: DateTime.fromMillisecondsSinceEpoch(msg.serverTime),
              bizType: msg.attributes?['bizType']?.toString(),
            ));
          }
        },
      ),
    );
  }
}
