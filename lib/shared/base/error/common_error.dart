import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_logger/pretty_logger.dart';

class ErrorException implements Exception {
  static const num noInternetCode = -1;
  static const String noInternetMessage = 'No internet';

  static const num internalServerCode = 500;
  static const num facebookLoginErrorCode = -1000;

  static const internalServerMessage = 'Internal Server Error';

  final dynamic errorType;
  final num? code;
  final String? message;
  final dynamic extraData;

  ErrorException({
    this.code,
    this.message,
    this.extraData,
    this.errorType,
  });

  factory ErrorException.noInternet() {
    return ErrorException(
      code: noInternetCode,
      message: noInternetMessage,
    );
  }

  factory ErrorException.commonError([String? extraInfo]) {
    return ErrorException(
      code: 1000,
      message: kDebugMode ? extraInfo : "Something went wrong!",
    );
  }

  @override
  String toString() {
    return message ?? '';
  }

  String toObjectMessage() {
    return 'ErrorException(errorType: $errorType, code: $code, message: $message, extraData: $extraData)';
  }
}

class ErrorMixin {
  String _retrieveErrorMessage(Response? response) {
    dynamic errorMessage = response?.statusMessage;

    try {
      if (response?.data?["errors"] != null) {
        final errorMessagesList = response?.data?["errors"] as List<dynamic>;
        if (errorMessagesList.isNotEmpty) {
          errorMessage = errorMessagesList.first;
        }
      }
    } catch (err) {
      PLog.error(
        '[$err] - Error: - $err',
      );
    }

    return errorMessage?.toString() ?? "Something went wrong!";
  }

  Future<T> protectRunApi<T>({
    required Future<T> Function() action,
    required String errorTag,
    ValueChanged<dynamic>? onError,
    VoidCallback? onFinally,
  }) async {
    try {
      return await action();
    } on DioException catch (e, s) {
      PLog.error(
        '[$errorTag] - DioError - ${e.response?.statusMessage} - $s',
      );
      onError?.call(e);
      if (e.error is SocketException) {
        throw ErrorException.noInternet();
      }
      //* No internet message while uploading pre signed url
      if (e.message == 'Software caused connection abort') {
        throw ErrorException.noInternet();
      }
      throw ErrorException(
        code: e.response?.statusCode,
        message: _retrieveErrorMessage(e.response),
        extraData: e.response?.data,
        errorType: e,
      );
    } on ErrorException catch (_) {
      rethrow;
    } catch (e, s) {
      PLog.error(
        '[$errorTag] - Exception - $e - $s',
      );
      onError?.call(e);
      throw ErrorException(
        code: e.hashCode,
        message: kDebugMode ? e.toString() : "Something went wrong!",
        errorType: e,
      );
    } finally {
      onFinally?.call();
    }
  }
}

class ErrorUtils {}
