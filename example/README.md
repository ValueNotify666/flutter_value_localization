# Flutter Value Localization Example

示例应用演示两种初始化方式：

## 1. Assets 模式
从 `pubspec.yaml` 配置的 `langFiles/` 目录加载 JSON 文件。

## 2. Map 模式（Mock API/Hive）
从内存 Map 加载，模拟从 API 或 Hive 获取数据。

## 运行

```bash
cd example
flutter pub get
flutter run
```

## 文件说明

- `lib/main.dart` - 主应用，包含 UI、返回键支持和两种初始化方式
- `lib/mock_data.dart` - 模拟 API/Hive 数据源
- `langFiles/` - Assets 模式使用的 JSON 文件目录
