## 0.0.3

### 优化 API 数据源链路 / API Data Source Optimization

- **自动语言注册** / **Automatic Language Registration**
  - `initFromMap()` 自动从数据中解析并注册所有可用语言
  - 支持简写语言代码（如 `zh_cn`）自动匹配完整 key（如 `app_zh_cn`）
  - 调用方无需手动转换数据类型，直接传入 API 返回的原始 JSON
  - `initFromMap()` now auto-registers all available languages from data
  - Supports shorthand lang codes (e.g., `zh_cn`) auto-matching full keys (e.g., `app_zh_cn`)
  - No manual data type conversion needed, pass API response directly

- **简化调用方式** / **Simplified API Usage**
  - 直接调用 `ValueLocalization.set('zh_cn')` 即可切换到对应语言
  - 内部通过 `LangRegistry` 管理语言映射，逻辑更清晰
  - Simply call `ValueLocalization.set('zh_cn')` to switch languages
  - Internal `LangRegistry` manages language mappings transparently

---

## 0.0.2

### 新增功能 / New Features

- **新增内存数据源支持** / **Added in-memory data source support**
  - 新增 `ValueLocalization.initFromMap()` 方法，支持从内存 Map 初始化本地化数据
  - 新增 `MapLocalizationSource` 类，实现从内存 Map 加载翻译数据
  - 适用于 Hive、SharedPreferences 等本地存储场景
  - Added `ValueLocalization.initFromMap()` method to initialize localization from in-memory Map
  - Added `MapLocalizationSource` class for loading translations from memory Map
  - Ideal for Hive, SharedPreferences, or other local storage scenarios

- **智能语言匹配** / **Smart language matching**
  - 支持 `zh` 自动匹配 `app_zh` 等前缀格式
  - 语言代码不区分大小写
  - Supports automatic matching like `zh` → `app_zh`
  - Case-insensitive language code handling

- **响应式组件** / **Reactive widget**
  - 新增 `LocalizationWidgetBuilder` 组件，自动监听语言变化并重建 UI
  - Added `LocalizationWidgetBuilder` widget for automatic UI rebuild on language change

---

## 0.0.1

### 初始发布 / Initial Release

- **Assets 本地化支持** / **Assets localization support**
  - 支持从 Flutter Assets 加载 JSON 翻译文件
  - 运行时动态切换语言
  - 跟随系统语言设置
  - Support loading JSON translation files from Flutter Assets
  - Runtime language switching
  - Follow system locale settings
