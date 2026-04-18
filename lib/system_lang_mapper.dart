import 'package:flutter/widgets.dart';

class SystemLangMapper {
  const SystemLangMapper._();

  static String mapLocale(Locale? locale) {
    if (locale == null) {
      return 'zh_cn';
    }

    final segments = <String>[locale.languageCode];
    final scriptCode = locale.scriptCode;
    final countryCode = locale.countryCode;

    if (scriptCode != null && scriptCode.isNotEmpty) {
      segments.add(scriptCode);
    }
    if (countryCode != null && countryCode.isNotEmpty) {
      segments.add(countryCode);
    }

    return mapLanguageTag(segments.join('-'));
  }

  static String mapLanguageTag(String? languageTag) {
    final normalized =
        languageTag?.trim().replaceAll('_', '-').toLowerCase() ?? '';
    if (normalized.isEmpty) {
      return 'zh_cn';
    }

    if (normalized.startsWith('en')) {
      return 'en';
    }

    if (normalized == 'zh-hans' || normalized.startsWith('zh-cn')) {
      return 'zh_cn';
    }

    if (normalized == 'zh-hant' ||
        normalized.startsWith('zh-tw') ||
        normalized.startsWith('zh-hk')) {
      return 'zh';
    }

    if (normalized.startsWith('zh')) {
      return 'zh';
    }

    return 'zh_cn';
  }
}