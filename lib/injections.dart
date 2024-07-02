import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/core/utilities/app_endpoints.dart';

final getIt = GetIt.instance;

Future<void> initInj() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  Dio dio = Dio();
  dio.options.baseUrl = AppEndPoints.baseUrl;
  dio.options.validateStatus = (i) => true;

  if (kDebugMode) {
    dio.interceptors.add(PrettyDioLogger(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
    ));
  }
  getIt.registerSingleton<Dio>(dio);
}
