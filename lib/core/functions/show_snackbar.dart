import 'package:flutter/material.dart';
import 'package:flutter_app/core/localization/my_localization.dart';
import 'package:flutter_app/core/utilities/app_routes.dart';

showSnackbar(String message, {bool error = false}) {
  closeSnackbar();
  final isAr = getLocale.languageCode == 'ar';
  ScaffoldMessenger.of(AppNavigator.context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      ),
      backgroundColor: error ? Colors.red : Colors.green,
    ),
  );
}

closeSnackbar() {
  ScaffoldMessenger.of(AppNavigator.context).clearSnackBars();
}
