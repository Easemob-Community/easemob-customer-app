import 'package:dio/dio.dart';
import 'dio_client.dart';

class SessionApi {
  static final Dio _dio = DioClient.instance;

  static Future<Map<String, dynamic>> guestToken(Map<String, dynamic> params) async {
    final res = await _dio.post('/open/auth/guest-token', data: params);
    return res.data['data'];
  }

  static Future<Map<String, dynamic>> startSession(Map<String, dynamic> params) async {
    final res = await _dio.post('/open/session/start', data: params);
    return res.data['data'];
  }

  static Future<void> transferToHuman(Map<String, dynamic> params) async {
    await _dio.post('/open/session/transfer', data: params);
  }

  static Future<void> evaluate(Map<String, dynamic> params) async {
    await _dio.post('/open/session/evaluate', data: params);
  }

  static Future<List<dynamic>> history(String sessionId, {String? beforeMsgId, int size = 20}) async {
    final res = await _dio.get('/open/message/history', queryParameters: {
      'sessionId': sessionId,
      if (beforeMsgId != null) 'beforeMsgId': beforeMsgId,
      'size': size,
    });
    return res.data['data']['list'] ?? [];
  }

  static Future<void> recordMessage(Map<String, dynamic> params) async {
    await _dio.post('/open/message/record', data: params);
  }
}
