import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class MessageSender {
  static Future<void> sendText(String groupId, String text, {Map<String, dynamic>? ext}) async {
    final msg = EMMessage.createTxtSendMessage(
      targetId: groupId,
      content: text,
      chatType: ChatType.GroupChat,
    );
    msg.attributes = {'bizType': 'USER'};
    if (ext != null) {
      msg.attributes!.addAll(ext);
    }
    await EMClient.getInstance.chatManager.sendMessage(msg);
  }
}
