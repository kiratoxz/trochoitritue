// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_logger/pretty_logger.dart';
import 'package:kiratoxz_flutter/shared/shared.dart';

mixin ErrorMixin {
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
      return errorMessage?.toString() ?? "Something went wrong!";
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
      PLog.error('[$errorTag] - Exception - $e - $s');
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

class ArgumentUtils {
  static checkArgument(
    Object? argument, {
    String? argumentName,
  }) {
    String missingArgumentContent = '';
    if (argumentName != null) {
      missingArgumentContent = ' - Missing param $argumentName';
    }
    if (argument == null) {
      throw ErrorException(
        message:
            'Something went wrong! Please try again$missingArgumentContent',
      );
    }

    if (argument is List && argument.isEmpty) {
      throw ErrorException(
        message:
            'Something went wrong! Please try again$missingArgumentContent',
      );
    }
    if (argument is String && argument.trim().isEmpty) {
      throw ErrorException(
        message:
            'Something went wrong! Please try again$missingArgumentContent',
      );
    }
  }

  static checkArguments(List<Object> arguments, {List<String>? argumentsName}) {
    for (var index = 0; index < arguments.length; index++) {
      final argument = arguments[index];
      bool isValidArgumentName = index < (argumentsName?.length ?? -1);
      checkArgument(
        argument,
        argumentName:
            (isValidArgumentName ? argumentsName?.elementAt(index) : null),
      );
    }
  }
}

class ErrorUtils {}
