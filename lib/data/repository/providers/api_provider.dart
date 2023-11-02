// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:kiratoxz_flutter/data/data.dart';

class ApiProvider extends BaseService with ErrorMixin {
  static const String TAG = "ApiProvider";

  ApiProvider({required Dio dio}) : super(client: dio);

  Future<void> getConfigData() async {
    return protectRunApi<void>(
      action: () async {
        final response = await request(url: Constant.configUrl, timeout: 30000);
        return response;
      },
      errorTag: TAG,
    );
  }
}
