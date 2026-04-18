import 'package:flutter/foundation.dart';

class LocalizationValueNotifier extends ValueNotifier<String> {
  LocalizationValueNotifier(super.value);

  void update(String nextLangCode) {
    if (value == nextLangCode) {
      return;
    }
    value = nextLangCode;
  }
}