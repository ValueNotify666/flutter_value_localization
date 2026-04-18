import 'package:flutter/services.dart';
import 'package:value_localization_core/value_localization_core.dart';

class FlutterAssetLocalizationSource implements LocalizationSource {
  const FlutterAssetLocalizationSource();

  @override
  Future<String> loadString({
    required String langCode,
    required String resolvedPath,
  }) {
    return rootBundle.loadString(resolvedPath);
  }
}