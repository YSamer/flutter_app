import 'package:flutter_app/core/data/local/local_data.dart';
import 'package:flutter_app/core/data/remote/remote_data.dart';
import 'package:flutter_app/core/data/remote/app_response.dart';
import 'package:flutter_app/core/localization/my_localization.dart';

class AppRequest {
  static Map<String, dynamic> get headers => {
        'Accept': 'application/json',
        'lang': getLocale.languageCode,
        // 'api-key':  //.......................................
      };
  // Request
  static Future<AppResponse> get(
    String path,
    bool isAuth, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    AppResponse res = await RemoteData.requestDio(
      path,
      reqType: ReqType.get,
      data: data,
      headers: headers
        ..addAll(
          isAuth ? {'Authorization': 'Bearer ${token ?? LocalData.token}'} : {},
        ),
      queryParameters: queryParameters,
    );
    return res;
  }

  static Future<AppResponse> post(
    String path,
    bool isAuth, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    AppResponse res = await RemoteData.requestDio(
      path,
      reqType: ReqType.post,
      data: data,
      headers: headers
        ..addAll(
          (isAuth)
              ? {'Authorization': 'Bearer ${token ?? LocalData.token}'}
              : {},
        ),
      queryParameters: queryParameters,
    );
    return res;
  }
}

class ReqType {
  static const String get = 'GET';
  static const String post = 'POST';
}
