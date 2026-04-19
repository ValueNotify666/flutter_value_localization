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

    // 从 memory:path 中提取实际 key，或直接使用 langCode
    String? dataKey;
    if (resolvedPath.startsWith('memory:')) {
      dataKey = resolvedPath.substring(7); // 去掉 'memory:' 前缀
    }

    // 优先使用 resolvedPath 中的 key（如果存在）
    var translations = dataKey != null ? _data[dataKey] : null;

    // 回退：尝试直接匹配 langCode
    translations ??= _data[normalizedLangCode];

    // 再回退：尝试添加 "app_" 前缀匹配
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
