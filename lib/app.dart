import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/chat/chat_page.dart';

class CustomerServiceApp extends StatelessWidget {
  const CustomerServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easemob Customer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3B6CFF)),
        useMaterial3: true,
      ),
      home: const ProviderScope(child: ChatPage()),
    );
  }
}
