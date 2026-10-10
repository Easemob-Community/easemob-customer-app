import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../config/env.dart';

class DioClient {
  static final Box<String> _box = Hive.box<String>('cs_cache');
  static bool _initialized = false;

  static String? get _token => _box.get('token');

  static set token(String? value) {
    if (value == null) {
      _box.delete('token');
    } else {
      _box.put('token', value);
    }
  }

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: Env.apiBase,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ));

  static Dio get instance {
    if (!_initialized) {
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          final t = _token;
          if (t != null && t.isNotEmpty) {
            options.headers['Authorization'] = t;
          }
          return handler.next(options);
        },
      ));
      _initialized = true;
    }
    return _dio;
  }
}
