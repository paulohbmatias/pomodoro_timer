import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_timer/i18n/localization_strings.dart';

class Localization {
  final Locale locale;

  Localization(this.locale);

  static Localization of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'es' : es,
    'en' : en,
    'pt' : pt
  };

  _getValue(String key) => _localizedValues[locale.languageCode][key];

  String get shortBreak => _getValue(ShortBreak);
  String get longBreak => _getValue(LongBreak);
  String get pomodoro => _getValue(Pomodoro);
  String get timeIsOver => _getValue(TimeIsOver);
  String get pomodoroTime => _getValue(PomodoroTime);
  String get shortBreakTime => _getValue(ShortBreakTime);
  String get longBreakTime => _getValue(LongBreakTime);
  String get timeIsRunning => _getValue(TimeIsRunning);
  String get pomodoroIsOver => _getValue(PomodoroIsOver);
  String get breakIsOver => _getValue(BreakIsOver);
  String get itsTimeFor => _getValue(ItsTimeFor);
  String get itsTimeToWork => _getValue(ItsTimeToWork);
}

class LocalizationDelegate extends LocalizationsDelegate<Localization> {
  const LocalizationDelegate();
  @override
  bool isSupported(Locale locale) => ['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  Future<Localization> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of Localization.
    return SynchronousFuture<Localization>(Localization(locale));
  }

  @override
  bool shouldReload(LocalizationDelegate old) => false;
}