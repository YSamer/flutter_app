import 'package:flutter_app/core/localization/my_localization.dart';
import 'package:flutter_app/core/utilities/app_routes.dart';

class AppValidator {
  static String? phoneValidate(String? value) {
    final phoneRegExp = RegExp(r'^\+?\d{8,14}$');
    if (value == null || !phoneRegExp.hasMatch(value)) {
      return tr(AppNavigator.context).invalidPhone;
    }
    return null;
  }

  static String? emailValidate(String? value) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (value == null || !emailRegExp.hasMatch(value)) {
      return tr(AppNavigator.context).invalidEmail;
    }
    return null;
  }

  static String? passwordValidate(String? value) {
    if (value == null || value.length < 9) {
      return tr(AppNavigator.context).invalidPassword;
    }
    return null;
  }

  static String? nameValidate(String? value) {
    if (value == null || value.length < 2) {
      return tr(AppNavigator.context).invalidName;
    }
    return null;
  }
}
