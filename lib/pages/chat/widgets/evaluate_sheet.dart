import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../api/session_api.dart';

class EvaluateSheet extends ConsumerStatefulWidget {
  final String sessionId;

  const EvaluateSheet({super.key, required this.sessionId});

  @override
  ConsumerState<EvaluateSheet> createState() => _EvaluateSheetState();
}

class _EvaluateSheetState extends ConsumerState<EvaluateSheet> {
  int _score = 5;
  final TextEditingController _comment = TextEditingController();
  final List<String> _tags = ['解决问题', '响应快', '态度好'];
  final List<String> _selected = [];
  bool _submitting = false;

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await SessionApi.evaluate({
        'sessionId': widget.sessionId,
        'score': _score,
        'tags': _selected,
        'comment': _comment.text,
      });
      if (mounted) Navigator.pop(context);
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('服务评价', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) => IconButton(
              icon: Icon(i < _score ? Icons.star : Icons.star_border, color: Colors.orange),
              onPressed: () => setState(() => _score = i + 1),
            )),
          ),
          Wrap(
            spacing: 8,
            children: _tags.map((t) => ChoiceChip(
              label: Text(t),
              selected: _selected.contains(t),
              onSelected: (v) => setState(() => v ? _selected.add(t) : _selected.remove(t)),
            )).toList(),
          ),
          TextField(controller: _comment, decoration: const InputDecoration(hintText: '请输入建议'), maxLines: 3),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting ? const CircularProgressIndicator() : const Text('提交'),
            ),
          ),
        ],
      ),
    );
  }
}
