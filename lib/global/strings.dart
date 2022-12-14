import 'package:flutter/material.dart';
import 'package:notie/store/global/language_store.dart';
import 'package:provider/provider.dart';

import 'vars.dart';

enum Language { system, en, vi }

class Strings {
  static BuildContext? get _context => Vars.context;

  static Language get language {
    if (_context == null) return Language.en;
    final languageStore = _context!.read<LanguageStore>();
    switch (languageStore.activeLanguage) {
      case Language.system:
        Locale locale = Localizations.localeOf(_context!);
        return locale.languageCode == Language.en.name
            ? Language.en
            : Language.vi;
      case Language.en:
      case Language.vi:
        return languageStore.activeLanguage;
    }
  }

  static bool get isEn => Strings.language == Language.en;

  static bool get isVi => Strings.language == Language.vi;

  static Locale get locale => Locale(language.name);

  static String capitalize(String s, {bool eachWord = false}) {
    s = s.toLowerCase();
    if (eachWord) return s.split(' ').map((w) => capitalize(w)).join(' ');
    return s[0].toUpperCase() + s.substring(1);
  }

  static bool isLowercase(String s) =>
      s == s.toLowerCase() && s.trim().isNotEmpty;

  static bool isCapitalized(String s) =>
      s == capitalize(s) && s.trim().isNotEmpty;

  static bool isUppercase(String s) =>
      s == s.toUpperCase() && s.trim().isNotEmpty;
}