import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:kiratoxz_flutter/data/data.dart';

class ApiRepository {
  late Dio dio;
  late HttpClient client;

  ApiRepository();
  late ApiProvider _apiProvider;
  ApiProvider get apiProvider => _apiProvider;

  Future<void> initialize() async {
    /// Todo: add certificate if needed
    client = HttpClient();
    final option = BaseOptions(connectTimeout: const Duration(seconds: 60));
    dio = Dio(option);
    dio.interceptors.add(AuthInterceptor());

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      return client;
    };

    _apiProvider = ApiProvider(dio: dio);
  }
}
