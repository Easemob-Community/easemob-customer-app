import 'package:flutter/material.dart';

class TransferBanner extends StatelessWidget {
  final int queuePosition;
  final String handlerType;
  final VoidCallback onTransfer;

  const TransferBanner({
    super.key,
    required this.queuePosition,
    required this.handlerType,
    required this.onTransfer,
  });

  @override
  Widget build(BuildContext context) {
    if (handlerType == 'HUMAN') return const SizedBox.shrink();
    if (queuePosition > 0) {
      return Container(
        padding: const EdgeInsets.all(8),
        color: Colors.orange[50],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 16, color: Colors.orange[800]),
            const SizedBox(width: 6),
            Text('正在排队，当前第 $queuePosition 位', style: TextStyle(color: Colors.orange[800])),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.support_agent, size: 16, color: Color(0xFF3B6CFF)),
          const SizedBox(width: 6),
          Text('AI 服务中', style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}
