import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_app/core/data/remote/app_request.dart';
import 'package:flutter_app/core/data/remote/app_response.dart';
import 'package:flutter_app/injections.dart';

class RemoteData {
  static Future<AppResponse> requestDio(
    String path, {
    String reqType = ReqType.get,
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response response = await getIt<Dio>().request(
      path,
      options: Options(headers: headers, method: reqType),
      data: data,
      queryParameters: queryParameters,
    );
    AppResponse? appResponse;
    try {
      if (response.data['message'] != null &&
          response.data['message'].toString() == 'Unauthenticated.') {
        appResponse = AppResponse(
          data: '',
          message: response.data?['message']?.toString() ?? 'Faild',
          statusCode: 401,
        );
      } else {
        appResponse = AppResponse.fromJson(response.data, response.statusCode);
      }
    } catch (e) {
      appResponse = AppResponse(
        data: '',
        message: 'Faild',
        statusCode: 401,
      );
      log(e.toString());
    }
    return appResponse;
  }
}
