# flutter_value_localization

<p align="center">
  <strong>Flutter 响应式本地化解决方案 / Flutter Reactive Localization Solution</strong><br>
  支持 Assets 与内存数据源，轻松实现多语言动态切换
</p>

---

## 目录 / Contents

- [特性 / Features](#特性--features)
- [安装 / Installation](#安装--installation)
- [使用教程 / Tutorial](#使用教程--tutorial)
  - [Assets 模式 / Assets Mode](#方式一assets-模式--method-1-assets-mode)
  - [Map 模式（Hive）/ Map Mode (Hive)](#方式二map-模式-hive--method-2-map-mode-hive)
- [响应式 UI / Reactive UI](#响应式-ui--reactive-ui)
- [完整示例 / Complete Example](#完整示例--complete-example)
- [API 参考 / API Reference](#api-参考--api-reference)

---

## 特性 / Features

| 特性 | 说明 | Feature | Description |
|------|------|---------|-------------|
| 🗂️ **双数据源** | 支持 Assets 文件或内存 Map 加载 | **Dual Data Sources** | Load from Assets files or in-memory Map |
| 🔄 **动态切换** | 运行时无缝切换语言 | **Runtime Switching** | Seamless language switching at runtime |
| 📱 **系统跟随** | 自动跟随设备系统语言 | **System Following** | Auto-follow device system locale |
| 🎯 **参数插值** | 支持 `{name}` 模板变量替换 | **Param Interpolation** | Template variable replacement like `{name}` |
| 🏗️ **响应式组件** | 自动重建 UI，无需手动监听 | **Reactive Widget** | Auto-rebuild UI without manual listening |
| ⚡ **高性能** | 内置缓存机制，避免重复加载 | **High Performance** | Built-in caching to avoid redundant loading |

---

## 安装 / Installation

```yaml
dependencies:
  flutter_value_localization: ^0.0.3
```

> 依赖核心库 / Core dependency: [value_localization_core](https://github.com/ValueNotify666/value_localization_core.git)

---

## 使用教程 / Tutorial

### 方式一：Assets 模式 / Method 1: Assets Mode

适用于静态翻译文件存储在项目中的场景。<br>
*Ideal for static translation files stored in the project.*

#### 1. 添加翻译文件 / Add Translation Files

创建 `langFiles/` 目录并添加 JSON 文件：<br>
*Create `langFiles/` directory and add JSON files:*

```
assets/langFiles/
├── app_en.json      # 英文 / English
├── app_zh.json      # 繁体中文 / Traditional Chinese
└── app_zh_cn.json   # 简体中文 / Simplified Chinese
```

**`app_en.json`**:
```json
{
  "appname": "Nice Player",
  "welcome": "Welcome to {appName}!",
  "today": "Today is {month}/{day}/{year}",
  "greeting": "Hello, {name}!",
  "items_count": "You have {count} items"
}
```

**`app_zh_cn.json`** (简体中文 / Simplified):
```json
{
  "appname": "Nice Player",
  "welcome": "欢迎使用 {appName}！",
  "today": "今天是{year}年{month}月{day}日",
  "greeting": "你好，{name}！",
  "items_count": "你有 {count} 个项目"
}
```

#### 2. 配置 pubspec.yaml / Configure pubspec.yaml

```yaml
flutter:
  assets:
    - langFiles/app_en.json
    - langFiles/app_zh.json
    - langFiles/app_zh_cn.json
```

#### 3. 初始化 / Initialize

```dart
import 'package:flutter_value_localization/flutter_value_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化本地化 / Initialize localization
  await ValueLocalization.init(
    langCode: 'en',      // 默认语言 / Default language
    openLog: true,       // 开启调试日志 / Enable debug logs
  );
  
  runApp(const MyApp());
}
```

---

### 方式二：Map 模式（Hive）/ Method 2: Map Mode (Hive)

适用于从 API 获取翻译数据并本地缓存的场景，如使用 Hive。<br>
*Ideal for fetching translations from API and caching locally, e.g., using Hive.*

#### 1. 准备数据结构 / Prepare Data Structure

```dart
// 从 API 获取的翻译数据 / Translation data from API
final Map<String, Map<String, String>> translations = {
  'app_en': {
    'appname': 'Nice Player',
    'welcome': 'Welcome to {appName}!',
    'today': 'Today is {month}/{day}/{year}',
  },
  'app_zh': {
    'appname': 'Nice Player',
    'welcome': '歡迎使用 {appName}！',
    'today': '今天是{year}年{month}月{day}日',
  },
  'app_zh_cn': {
    'appname': 'Nice Player',
    'welcome': '欢迎使用 {appName}！',
    'today': '今天是{year}年{month}月{day}日',
  },
};
```

#### 2. 存储到 Hive / Store to Hive

```dart
import 'package:hive_ce/hive.dart';

// 存储翻译数据 / Store translation data
final box = await Hive.openBox<Map<String, Map<String, String>>>('localization');
await box.put('translations', translations);
```

#### 3. 从 Hive 读取并初始化 / Read from Hive and Initialize

```dart
// 从 Hive 读取 / Read from Hive
final box = await Hive.openBox<Map<String, Map<String, String>>>('localization');
final storedData = box.get('translations') ?? {};

// 从 Map 初始化 / Initialize from Map
await ValueLocalization.initFromMap(
  langCode: 'zh_cn',    // 默认语言 / Default language
  data: storedData,    // Hive 存储的数据 / Data from Hive
  openLog: true,
);
```

> **注意 / Note**: 数据格式要求 `app_<langCode>` 作为 key，如 `app_en`、`app_zh_cn`。<br>
> *Data format requires `app_<langCode>` as key, e.g., `app_en`, `app_zh_cn`.*

#### 4. 从 API 直接初始化（无需类型转换）/ Initialize from API (No Type Conversion)

```dart
// 从远程 API 获取翻译数据 / Fetch translations from remote API
final response = await http.get(Uri.parse('https://api.example.com/translations'));
final data = jsonDecode(response.body);  // 原始 JSON，无需转换 / Raw JSON, no conversion needed

// 直接初始化，自动注册所有语言 / Initialize directly, auto-registers all languages
await ValueLocalization.initFromMap(
  langCode: 'zh_cn',  // 默认语言 / Default language
  data: data,         // 支持 Map<dynamic, dynamic> / Supports Map<dynamic, dynamic>
  openLog: true,
);

// 切换语言（支持简写）/ Switch language (shorthand supported)
await ValueLocalization.set('en');      // 自动匹配 app_en / Auto-matches app_en
await ValueLocalization.set('zh_cn');   // 自动匹配 app_zh_cn / Auto-matches app_zh_cn
```

---

## 响应式 UI / Reactive UI

使用 `LocalizationWidgetBuilder` 让 UI 自动响应语言变化：<br>
*Use `LocalizationWidgetBuilder` for UI to automatically respond to language changes:*

```dart
import 'package:flutter_value_localization/flutter_value_localization.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LocalizationWidgetBuilder(
          builder: (context, child) => Text(
            ValueLocalization.get('appname'),
          ),
        ),
      ),
      body: LocalizationWidgetBuilder(
        builder: (context, child) {
          return Column(
            children: [
              // 当前语言 / Current language
              Text('Language: ${ValueLocalization.langCode}'),
              
              // 带参数的翻译 / Translation with params
              Text(ValueLocalization.get(
                'welcome',
                params: {'appName': 'MyApp'},
              )),
              
              // 语言切换按钮 / Language switcher
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'en', label: Text('EN')),
                  ButtonSegment(value: 'zh_cn', label: Text('ZH')),
                ],
                selected: {ValueLocalization.langCode},
                onSelectionChanged: (selection) async {
                  await ValueLocalization.set(selection.first);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
```

### 手动监听（备选）/ Manual Listening (Alternative)

```dart
// 使用 ValueListenableBuilder / Using ValueListenableBuilder
ValueListenableBuilder<String>(
  valueListenable: ValueLocalization.listenable,
  builder: (context, langCode, child) {
    return Text('Current: $langCode');
  },
)
```

---

## 完整示例 / Complete Example

见 `/example` 目录，包含完整演示：<br>
*See `/example` directory for complete demo:*

```bash
cd example
flutter pub get
flutter run
```

### 示例功能 / Example Features

| 功能 | 描述 | Feature | Description |
|------|------|---------|-------------|
| 🎛️ 双模式切换 | 选择 Assets 或 Map 模式 | Mode Selection | Choose Assets or Map mode |
| 🌐 多语言切换 | EN / ZH / ZH_CN | Multi-language | Switch between EN / ZH / ZH_CN |
| 🔄 实时响应 | 语言切换立即更新 UI | Real-time Update | UI updates immediately on switch |
| 🔙 返回导航 | 支持物理/手势返回 | Back Navigation | Physical/gesture back support |

---

## API 参考 / API Reference

### ValueLocalization

| 方法 / Method | 参数 / Parameters | 说明 / Description |
|--------------|-------------------|------------------|
| `init()` | `String langCode`<br>`bool openLog` | 从 Assets 初始化<br>Initialize from Assets |
| `initFromMap()` | `String langCode`<br>`Map data`<br>`bool openLog` | 从内存 Map 初始化<br>Initialize from in-memory Map |
| `set()` | `String langCode` | 切换当前语言<br>Switch current language |
| `get()` | `String key`<br>`Map? params` | 获取翻译文本<br>Get translation text |
| `followSys()` | `bool follow` | 是否跟随系统语言<br>Follow system locale |
| `dispose()` | - | 释放资源<br>Release resources |

### 属性 / Properties

| 属性 / Property | 类型 / Type | 说明 / Description |
|----------------|------------|-------------------|
| `langCode` | `String` | 当前语言代码<br>Current language code |
| `listenable` | `ValueListenable<String>` | 语言变化通知器<br>Language change notifier |
| `isInitialized` | `bool` | 是否已初始化<br>Whether initialized |

### LocalizationWidgetBuilder

| 参数 / Parameter | 类型 / Type | 说明 / Description |
|----------------|------------|-------------------|
| `builder` | `Widget Function(BuildContext, Widget?)` | 构建函数，语言变化时自动重建<br>Build function, auto-rebuild on language change |
| `child` | `Widget?` | 可选的子组件，用于优化性能<br>Optional child for performance optimization |

---

## 常见问题 / FAQ

### Q: Map 模式下语言切换找不到数据？
*Language switching fails in Map mode?*

确保数据 key 使用 `app_<langCode>` 格式：<br>
*Ensure data keys use `app_<langCode>` format:*

```dart
// ✅ 正确 / Correct
{
  'app_en': {...},
  'app_zh_cn': {...},
}

// ❌ 错误 / Incorrect
{
  'en': {...},        // 缺少 app_ 前缀
  'zh_cn': {...},
}
```

### Q: 如何强制刷新所有 UI？
*How to force refresh all UI?*

使用 `LocalizationWidgetBuilder` 包裹顶层组件：<br>
*Wrap top-level widget with `LocalizationWidgetBuilder`:*

```dart
MaterialApp(
  home: LocalizationWidgetBuilder(
    builder: (context, child) => MyHomePage(),
  ),
)
```

---

## 更多信息 / Additional Information

- 📋 报告问题 / Report issues: [GitHub Issues](https://github.com/ValueNotify666/value_localization_core/issues)
- 📚 核心库文档 / Core library: [value_localization_core](https://github.com/ValueNotify666/value_localization_core.git)
- 📜 更新日志 / Changelog: [CHANGELOG.md](./CHANGELOG.md)
