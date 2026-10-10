import 'package:flutter/material.dart';

class WelcomeCard extends StatelessWidget {
  final String welcome;

  const WelcomeCard({super.key, required this.welcome});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(welcome, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['怎么退款？', '物流多久到？', '如何联系人工？']
                .map((q) => ActionChip(
                      label: Text(q),
                      onPressed: () {},
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
