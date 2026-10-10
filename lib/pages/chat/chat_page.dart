import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../store/session_provider.dart';
import '../../store/message_provider.dart';
import '../../sdk/message_sender.dart';
import '../../api/session_api.dart';
import 'widgets/message_bubble.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/transfer_banner.dart';
import 'widgets/welcome_card.dart';


class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  bool _started = false;

  Future<void> _start() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(sessionProvider.notifier).start(channel: 'app');
      setState(() => _started = true);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('启动失败：$e')),
      );
    }
  }

  Future<void> _send(String text) async {
    final session = ref.read(sessionProvider);
    if (session.groupId == null) return;
    final localId = ref.read(messageProvider.notifier).appendLocal(text, senderId: session.sessionId ?? '');
    _controller.clear();
    try {
      await MessageSender.sendText(session.groupId!, text);
      await SessionApi.recordMessage({
        'sessionId': session.sessionId,
        'content': text,
        'type': 'TXT',
      });
      ref.read(messageProvider.notifier).markSent(localId);
    } catch (e) {
      ref.read(messageProvider.notifier).markFailed(localId);
    }
  }

  Future<void> _transfer() async {
    final sessionNotifier = ref.read(sessionProvider.notifier);
    await sessionNotifier.transferToHuman();
    await _send('转人工');
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final messages = ref.watch(messageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(session.handlerType == 'HUMAN'
            ? '人工服务中${session.agent?['nickname'] != null ? ' · ${session.agent!['nickname']}' : ''}'
            : '智能客服'),
        backgroundColor: const Color(0xFF3B6CFF),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          if (_started) ...[
            WelcomeCard(welcome: session.aiAccount?['nickname'] ?? '您好，有什么可以帮您？'),
            TransferBanner(
              queuePosition: session.queuePosition,
              handlerType: session.handlerType,
              onTransfer: _transfer,
            ),
          ],
          Expanded(
            child: _started
                ? ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (ctx, idx) => MessageBubble(message: messages[idx]),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: ElevatedButton(
                        onPressed: _start,
                        child: const Text('开始咨询'),
                      ),
                    ),
                  ),
          ),
          if (_started)
            ChatInputBar(
              controller: _controller,
              onSend: _send,
              onTransfer: _transfer,
            ),
        ],
      ),
    );
  }
}
