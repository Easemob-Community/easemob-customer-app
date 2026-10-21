# easemob-customer-app · 移动端(Flutter)

智能客服系统的 Flutter 移动端(iOS / Android),与 Web 访客端共用同一后端与环信应用,功能对齐:AI 接待、转人工、消息漫游、满意度评分。

## 技术栈

Flutter 3.x · Dart · im_flutter_sdk(环信 IM)· dio · hive

## 目录结构

```
lib/
├── api/       # 后端接口封装
├── config/    # 环境配置(后端地址、环信 AppKey)
├── pages/     # 页面(会话列表、聊天页、评分等)
├── sdk/       # 环信 IM 连接与消息收发
├── services/  # 业务服务
├── store/     # 状态管理
└── main.dart  # 入口
```

## 本地运行

```bash
flutter pub get
flutter run        # 连接设备/模拟器后运行
```

运行前在 `lib/config/` 中确认后端接口地址与环信 AppKey 配置正确。

## 构建

```bash
flutter build apk          # Android
flutter build ios          # iOS
```

## 相关仓库

- 服务端:[easemob-customer-service](https://github.com/Easemob-Community/easemob-customer-service)
- Web 访客端:[easemob-customer-web](https://github.com/Easemob-Community/easemob-customer-web)
- 管理控制台:[easemob-customer-console](https://github.com/Easemob-Community/easemob-customer-console)
