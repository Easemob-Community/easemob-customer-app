import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../api/dio_client.dart';
import '../api/session_api.dart';
import '../sdk/easemob_client.dart';
import 'session_state.dart';

class SessionNotifier extends StateNotifier<SessionState> {
  SessionNotifier() : super(const SessionState());

  final Box<String> _box = Hive.box<String>('cs_cache');
  String? _userId;

  String? get userId => _userId;

  Future<void> start({String channel = 'app'}) async {
    _userId ??= _box.get('userId');

    debugPrint('[session] guest token start');
    final guest = await SessionApi.guestToken({
      'userId': _userId,
      'channel': channel,
    });
    debugPrint('[session] guest token ok: ${guest['userId']}');
    _userId = guest['userId'];
    _box.put('userId', _userId!);
    DioClient.token = guest['token']?.toString();

    debugPrint('[session] start session start');
    final resp = await SessionApi.startSession({'userId': _userId, 'channel': channel});
    debugPrint('[session] start session ok: ${resp['sessionId']}');
    final sessionIdStr = resp['sessionId']?.toString();
    final aiAccount = resp['aiAccount'] != null
        ? Map<String, dynamic>.from(resp['aiAccount'] as Map)
        : {
            'id': resp['aiAccountId']?.toString() ?? '',
            'nickname': resp['aiNickname']?.toString() ?? '智能客服'
          };
    state = state.copyWith(
      sessionId: sessionIdStr,
      groupId: resp['groupId']?.toString(),
      status: resp['status']?.toString() ?? 'AI_SERVING',
      handlerType: resp['handlerType']?.toString() ?? 'AI',
      aiAccount: aiAccount,
    );

    if (sessionIdStr != null) {
      _box.put('sessionId', sessionIdStr);
    }

    debugPrint('[session] easemob login start: $_userId');
    try {
      await EasemobClient().login(_userId!, guest['easemobToken']);
      debugPrint('[session] easemob login ok');
    } catch (e, s) {
      debugPrint('[session] easemob login failed: $e');
      debugPrint('$s');
      // 即使环信登录失败，也允许会话页面继续展示
    }
  }

  void onTransferred(Map<String, dynamic> agent) {
    state = state.copyWith(
      handlerType: 'HUMAN',
      agent: agent,
      queuePosition: 0,
    );
  }

  void onQueueUpdate(int position) {
    state = state.copyWith(queuePosition: position);
  }

  Future<void> transferToHuman() async {
    final sid = state.sessionId;
    if (sid == null || _userId == null) return;
    await SessionApi.transferToHuman({
      'sessionId': sid,
      'userId': _userId,
      'reason': 'USER_TRANSFER',
    });
  }

  void onClosed() {
    state = state.copyWith(status: 'CLOSED');
    _box.delete('sessionId');
  }
}

final sessionProvider = StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier();
});
