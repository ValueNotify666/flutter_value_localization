import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:value_localization_core/value_localization_core.dart';

import 'flutter_asset_localization_source.dart';
import 'localization_value_notifier.dart';
import 'map_localization_source.dart';
import 'system_lang_mapper.dart';
import 'system_locale_controller.dart';

class ValueLocalization {
  ValueLocalization._();

  static ValueLocalizationCore? _core;
  static StreamSubscription<String>? _langCodeSubscription;
  static LocalizationValueNotifier? _listenable;
  static SystemLocaleController? _systemLocaleController;
  static bool _isFollowingSystem = false;

  static String get langCode {
    _ensureInitialized();
    return _core!.currentLangCode;
  }

  static ValueListenable<String> get listenable {
    _ensureInitialized();
    return _listenable!;
  }

  static bool get isInitialized => _core?.isInitialized ?? false;

  /// 从 Flutter assets 初始化
  static Future<void> init({
    required String langCode,
    bool openLog = false,
  }) async {
    if (_core != null) {
      if (_core!.isInitialized) {
        return;
      }
      await _core!.init(langCode: langCode);
      return;
    }

    final logger = openLog ? const _PrintLocalizationLogger() : null;
    final core = ValueLocalizationCore(
      source: const FlutterAssetLocalizationSource(),
      logger: logger,
    );

    await core.init(langCode: langCode);
    _bindCore(core);
  }

  /// 从 Map 数据源初始化（适用于 Hive 等本地存储）
  /// [data] 格式: { "app_zh": { "key": "value" }, "app_en": { "key": "value" } }
  /// 支持简写 langCode: 'zh_cn' 会自动匹配 'app_zh_cn'
  static Future<void> initFromMap({
    required String langCode,
    required Map<String, Map<String, String>> data,
    bool openLog = false,
  }) async {
    if (_core != null) {
      if (_core!.isInitialized) {
        return;
      }
      await _core!.init(langCode: langCode);
      return;
    }

    final logger = openLog ? const _PrintLocalizationLogger() : null;
    
    // 从 data 自动注册所有可用语言
    final registry = LangRegistry();
    for (final key in data.keys) {
      // 注册带 app_ 前缀的完整 key
      registry.registerPath(key, 'memory:$key');
      
      // 同时注册简写形式 (app_zh_cn -> zh_cn)
      if (key.startsWith('app_')) {
        final shortKey = key.substring(4); // 去掉 'app_' 前缀
        registry.registerPath(shortKey, 'memory:$key');
      }
    }
    
    final core = ValueLocalizationCore(
      source: MapLocalizationSource(data),
      logger: logger,
      langRegistry: registry, // 传入注册好的 registry
    );

    await core.init(langCode: langCode);
    _bindCore(core);
  }

  static Future<void> set(String langCode) async {
    _ensureInitialized();
    await _core!.set(langCode);
  }

  static Future<void> followSys({required bool follow}) async {
    _ensureInitialized();

    if (follow == _isFollowingSystem) {
      return;
    }

    if (!follow) {
      _isFollowingSystem = false;
      _systemLocaleController?.stop();
      return;
    }

    _systemLocaleController ??= SystemLocaleController(
      onLocaleChanged: _handleSystemLocaleChanged,
    );
    _isFollowingSystem = true;
    _systemLocaleController!.start();
    await _systemLocaleController!.syncCurrentLocale();
  }

  static String get(String key, {Map<String, dynamic>? params}) {
    _ensureInitialized();
    return _core!.get(key, params: params);
  }

  static void dispose() {
    _isFollowingSystem = false;
    _systemLocaleController?.stop();
    _systemLocaleController = null;
    _langCodeSubscription?.cancel();
    _langCodeSubscription = null;
    _listenable?.dispose();
    _listenable = null;
    _core?.dispose();
    _core = null;
  }

  static void _bindCore(ValueLocalizationCore core) {
    _langCodeSubscription?.cancel();
    _listenable?.dispose();

    final listenable = LocalizationValueNotifier(core.currentLangCode);
    _langCodeSubscription = core.langCodeStream.listen(listenable.update);
    _listenable = listenable;
    _core = core;
  }

  static Future<void> _handleSystemLocaleChanged(Locale? locale) async {
    if (!_isFollowingSystem || _core == null || !_core!.isInitialized) {
      return;
    }

    final mappedLangCode = SystemLangMapper.mapLocale(locale);
    if (mappedLangCode == _core!.currentLangCode) {
      return;
    }

    await _core!.set(mappedLangCode);
  }

  static void _ensureInitialized() {
    if (_core == null || !_core!.isInitialized || _listenable == null) {
      throw ValueLocalizationException.notInitialized();
    }
  }
}

class _PrintLocalizationLogger implements LocalizationLogger {
  const _PrintLocalizationLogger();

  @override
  void debug(String message) {
    debugPrint(message);
  }

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    debugPrint(message);
    if (error != null) {
      debugPrint(error.toString());
    }
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }
}