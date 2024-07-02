import 'package:flutter/material.dart';

extension Convert on String? {
  double get toDoubleNum {
    if (this == null || this!.isEmpty) {
      return 0;
    }

    try {
      double n = double.parse(this!);
      if (n == 0.0) {
        return 0;
      } else {
        return n;
      }
    } catch (e) {
      return 0;
    }
  }

  int get toIntNum {
    if (this == null || this!.isEmpty) {
      return 0;
    }
    try {
      return int.parse(this!);
    } catch (e) {
      return 0;
    }
  }
}
String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length >= 4) {
      return phoneNumber.replaceRange(
          phoneNumber.length - 4, phoneNumber.length, 'xxxx');
    } else {
      return '';
    }
  }
extension StringConvert on dynamic {
  String get numToString {
    if (this == null || this == 0.0 || this == 0) {
      return '0';
    } else {
      String s = toString();
      if (s.split('.').length > 1 && s.split('.')[1] == '0') {
        return s.split('.')[0];
      }
      if (s.split('.').length > 1 && s.split('.')[1] != '0') {
        return '${s.split('.')[0]}.${s.split('.')[1].substring(0, 2)}';
      }
      return s;
    }
  }
}

extension ColorExtension on Color {
  /// Convert a color into a hex string representation.
  String toHex() {
    return '#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }
}
