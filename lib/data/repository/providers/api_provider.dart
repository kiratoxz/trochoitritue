// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:kiratoxz_flutter/data/data.dart';

class ApiProvider extends BaseService with ErrorMixin {
  static const String TAG = "ApiProvider";

  ApiProvider({required Dio dio}) : super(client: dio);
}
