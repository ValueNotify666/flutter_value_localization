import 'dart:convert';

import 'package:value_localization_core/value_localization_core.dart';

/// 从内存 Map 加载本地化数据的 Source
/// 适用于 Hive 等本地存储场景
class MapLocalizationSource implements LocalizationSource {
  /// 多语言数据源
  /// 格式: { "app_zh": { "key": "value" }, "app_en": { "key": "value" } }
  final Map<String, Map<String, String>> _data;

  const MapLocalizationSource(this._data);

  @override
  Future<String> loadString({
    required String langCode,
    required String resolvedPath,
  }) async {
    final normalizedLangCode = langCode.trim().toLowerCase();

    // 尝试直接匹配 langCode
    var translations = _data[normalizedLangCode];

    // 如果没找到，尝试添加 "app_" 前缀匹配
    if (translations == null && !normalizedLangCode.startsWith('app_')) {
      translations = _data['app_$normalizedLangCode'];
    }

    if (translations == null) {
      throw ValueLocalizationException.translationLoadFailed(
        langCode: langCode,
        resolvedPath: resolvedPath,
        cause: Exception('Language data not found for: $langCode'),
      );
    }

    return jsonEncode(translations);
  }
}
