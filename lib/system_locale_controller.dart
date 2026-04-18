import 'dart:async';

import 'package:flutter/widgets.dart';

class SystemLocaleController with WidgetsBindingObserver {
  SystemLocaleController({
    required Future<void> Function(Locale? locale) onLocaleChanged,
  }) : _onLocaleChanged = onLocaleChanged;

  final Future<void> Function(Locale? locale) _onLocaleChanged;
  bool _isStarted = false;

  bool get isStarted => _isStarted;

  void start() {
    if (_isStarted) {
      return;
    }

    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addObserver(this);
    _isStarted = true;
  }

  void stop() {
    if (!_isStarted) {
      return;
    }

    WidgetsBinding.instance.removeObserver(this);
    _isStarted = false;
  }

  Future<void> syncCurrentLocale() {
    if (!_isStarted) {
      return Future<void>.value();
    }

    final locales = WidgetsBinding.instance.platformDispatcher.locales;
    return _notifyLocale(locales.isEmpty ? null : locales.first);
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    unawaited(_notifyLocale(locales == null || locales.isEmpty ? null : locales.first));
  }

  Future<void> _notifyLocale(Locale? locale) {
    return _onLocaleChanged(locale);
  }
}