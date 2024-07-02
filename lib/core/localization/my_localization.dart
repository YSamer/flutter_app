// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_app/injections.dart';

const String LAGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String ARABIC = 'ar';

Future<Locale> setLocale(String languageCode) async {
  await getIt<SharedPreferences>().setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Locale get getLocale {
  String languageCode =
      getIt<SharedPreferences>().getString(LAGUAGE_CODE) ?? ARABIC;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, '');
    case ARABIC:
      return const Locale(ARABIC, '');
    default:
      return const Locale(ENGLISH, '');
  }
}

AppLocalizations tr(BuildContext context) {
  return AppLocalizations.of(context)!;
}
