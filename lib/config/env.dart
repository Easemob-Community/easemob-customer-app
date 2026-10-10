class Env {
  // 真机运行时请用电脑的局域网 IP，例如：
  // flutter run --dart-define=API_BASE=http://192.168.x.x:8080
  // 下面的默认值是当前构建环境的 IP，若网络变化请重新编译或使用 dart-define 覆盖。
  static const apiBase = String.fromEnvironment('API_BASE', defaultValue: 'http://192.168.3.4:8080');
  static const easemobAppKey = String.fromEnvironment('EASEMOB_APP_KEY', defaultValue: 'easemob-demo#support');
}
