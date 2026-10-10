import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import '../config/env.dart';

class EasemobClient {
  static final EasemobClient _instance = EasemobClient._internal();
  factory EasemobClient() => _instance;
  EasemobClient._internal();

  bool _inited = false;

  Future<void> init() async {
    if (_inited) return;
    final options = EMOptions(appKey: Env.easemobAppKey, autoLogin: false);
    await EMClient.getInstance.init(options);
    _inited = true;
  }

  Future<void> login(String userId, String token) async {
    await init();
    await EMClient.getInstance.loginWithToken(userId, token);
  }
}
