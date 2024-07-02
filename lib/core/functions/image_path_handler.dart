import 'package:flutter_app/core/utilities/app_endpoints.dart';

String imagePathComplete(String? img) {
  img ??= '';
  return img.isEmpty
      ? 'http://via.placeholder.com/360x360'
      : img.startsWith('http')
          ? img
          : img.startsWith('/')
              ? AppEndPoints.filePath + img
              : '${AppEndPoints.filePath}/$img';
}
