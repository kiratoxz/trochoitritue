// ignore_for_file: constant_identifier_names

import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:kiratoxz_flutter/data/data.dart';

enum RequestMethod { get, post, put, delete, patch }

class BaseService {
  late Dio dioClient;

  static const int DEFAULT_TIMEOUT = 15000;
  static const int DEFAULT_RECEIVE_TIMEOUT = 120000;

  /// Base class for all `api providers` which helps generate api request
  /// with `authentication`, `timeout` and `cache`.
  BaseService({Dio? client}) {
    if (client == null) {
      dioClient = Dio(BaseOptions(
          connectTimeout:
              const Duration(milliseconds: BaseService.DEFAULT_TIMEOUT)));
      dioClient.interceptors.add(AuthInterceptor());
    } else {
      dioClient = client;
    }
    if (!kReleaseMode) {
      if (dioClient.interceptors
              .indexWhere((element) => element is PrettyDioLogger) ==
          -1) {
        dioClient.interceptors.add(PrettyDioLogger(
          requestBody: true,
          responseBody: true,
        ));
      }
    }
  }

  Future<dynamic> simpleRequest({
    required String url,
    RequestMethod requestMethod = RequestMethod.get,
  }) async {
    try {
      final response = await dioClient.request(url);
      return _validateResponse(response).data;
    } on DioException catch (error) {
      developer.log("request - error with message: $error");
      rethrow;
    }
  }

  /// Send a normal request without any `authentication` or `cache`
  Future<dynamic> request({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    RequestMethod requestMethod = RequestMethod.get,
    String contentType = Headers.jsonContentType,
    int timeout = DEFAULT_RECEIVE_TIMEOUT,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final requestOption = await buildRequestOptions(
      requestMethod: requestMethod,
      contentType: contentType,
      timeout: timeout,
      withAuth: false,
    );
    try {
      final response = await dioClient.request(
        url,
        data: data,
        options: requestOption,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _validateResponse(response).data;
    } catch (error) {
      developer.log("request - error with message: $error");
      rethrow;
    }
  }

  /// Send a request with no `authentication` but `cache`.
  ///
  /// Client always use cached response if request before [cachedDuration]
  /// and always get new response before [staleDuration]. Between these duration,
  /// if a new response is unreachable, then client will use cached one.
  // Future<dynamic> requestWithCache({
  //   String? endPoint,
  //   dynamic data,
  //   RequestMethod requestMethod = RequestMethod.get,
  //   String contentType = Headers.jsonContentType,
  //   Map<String, dynamic>? queryParameters,
  //   Duration cacheDuration = const Duration(days: 1),
  //   Duration staleDuration = const Duration(days: 8),
  //   int timeout = DEFAULT_RECEIVE_TIMEOUT,
  //   ProgressCallback? onSendProgress,
  //   ProgressCallback? onReceiveProgress,
  // }) async {
  //   final String? baseUrl =
  //       await BaseServiceConfigData().baseAuthenticationUrl?.call();
  //   final url = "$baseUrl$endPoint";
  //   final cacheOptions = CacheOptions(
  //     // A default store is required for interceptor.
  //     store: MemCacheStore(),
  //     // Default.
  //     policy: CachePolicy.request,
  //     // Optional. Returns a cached response on error but for statuses 401 & 403.
  //     hitCacheOnErrorExcept: [401, 403],
  //     // Optional. Overrides any HTTP directive to delete entry past this duration.
  //     maxStale: const Duration(days: 7),
  //     // Default. Allows 3 cache sets and ease cleanup.
  //     priority: CachePriority.normal,
  //     // Default. Body and headers encryption with your own algorithm.
  //     cipher: null,
  //     // Default. Key builder to retrieve requests.
  //     keyBuilder: CacheOptions.defaultCacheKeyBuilder,
  //     // Default. Allows to cache POST requests.
  //     // Overriding [keyBuilder] is strongly recommended.
  //     allowPostMethod: false,
  //   );
  //   try {
  //     final response = await dioClient.request(
  //       url,
  //       data: data,
  //       options: cacheOptions.toOptions(),
  //       queryParameters: queryParameters,
  //       onSendProgress: onSendProgress,
  //       onReceiveProgress: onReceiveProgress,
  //     );
  //     return _validateRepsonse(response).data;
  //   } catch (error) {
  //     developer.log("request - error with message: $error");
  //     throw error;
  //   }
  // }

  /// Send a request with `authentication` but no `cache`.
  Future<dynamic> requestWithAuth({
    RequestMethod requestMethod = RequestMethod.get,
    required String url,
    dynamic data,
    String contentType = Headers.jsonContentType,
    int timeout = DEFAULT_RECEIVE_TIMEOUT,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool handleCatchingDioError = true,
  }) async {
    final requestOption = await buildRequestOptions(
      requestMethod: requestMethod,
      contentType: contentType,
      timeout: timeout,
    );
    try {
      return await _sendRequest(
        requestMethod: requestMethod,
        url: url,
        contentType: contentType,
        options: requestOption,
        data: data,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        handleCatchingDioError: handleCatchingDioError,
      );
    } catch (error) {
      debugPrint("requestWithCache - error with message $error");
      rethrow;
    }
  }

  /// Send a request with `authentication` and `cache`.
  ///
  /// Client always use cached response if request before [cachedDuration]
  /// and always get new response before [staleDuration]. Between these duration,
  /// if a new response is unreachable, then client will use cached one.
  // Future<dynamic> requestWithAuthAndCache({
  //   RequestMethod requestMethod = RequestMethod.get,
  //   String? endPoint,
  //   dynamic data,
  //   String contentType = Headers.jsonContentType,
  //   bool preferCache = false,
  //   Duration cacheDuration = const Duration(hours: 12),
  //   Duration staleDuration = const Duration(days: 2),
  //   int timeout = DEFAULT_RECEIVE_TIMEOUT,
  //   Map<String, dynamic>? queryParameters,
  //   ProgressCallback? onSendProgress,
  //   ProgressCallback? onReceiveProgress,
  //   bool handleCatchingDioError = true,
  // }) async {
  //   final requestOption = await buildRequestOptions(
  //     requestMethod: requestMethod,
  //     contentType: contentType,
  //     timeout: timeout,
  //   );
  //   final cacheOptions = CacheOptions(
  //     // A default store is required for interceptor.
  //     store: MemCacheStore(),
  //     // Default.
  //     policy: CachePolicy.request,
  //     // Optional. Returns a cached response on error but for statuses 401 & 403.
  //     hitCacheOnErrorExcept: [401, 403],
  //     // Optional. Overrides any HTTP directive to delete entry past this duration.
  //     maxStale: const Duration(days: 7),
  //     // Default. Allows 3 cache sets and ease cleanup.
  //     priority: CachePriority.normal,
  //     // Default. Body and headers encryption with your own algorithm.
  //     cipher: null,
  //     // Default. Key builder to retrieve requests.
  //     keyBuilder: CacheOptions.defaultCacheKeyBuilder,
  //     // Default. Allows to cache POST requests.
  //     // Overriding [keyBuilder] is strongly recommended.
  //     allowPostMethod: false,
  //   );
  //   try {
  //     return await _sendRequest(
  //       requestMethod: requestMethod,
  //       endPoint: endPoint,
  //       contentType: contentType,
  //       options: requestOption.copyWith(extra: cacheOptions.toExtra()),
  //       data: data,
  //       queryParameters: queryParameters,
  //       onSendProgress: onSendProgress,
  //       onReceiveProgress: onReceiveProgress,
  //       handleCatchingDioError: handleCatchingDioError,
  //     );
  //   } catch (error) {
  //     developer.log("requestWithAuthAndCache - error with message $error");
  //     throw error;
  //   }
  // }

  /// Generate request option for authencated request
  Future<Options> buildRequestOptions({
    RequestMethod requestMethod = RequestMethod.get,
    String contentType = Headers.jsonContentType,
    int timeout = DEFAULT_RECEIVE_TIMEOUT,
    bool withAuth = true,
  }) async {
    final deviceLanguageCode =
        await LocalizationService().loadDeviceLanguageCode();
    final packageInfo = await PackageInfo.fromPlatform();
    var appVersion = packageInfo.version;
    if (appVersion.contains('-')) {
      appVersion = appVersion.split('-')[0];
    }
    final headersMap = {
      "Version": "2.0",
      "Accept-Language": deviceLanguageCode,
      "X-Timezone-Offset": DateTimeUtils.getTimezoneOffset(),
      "Accept-Version": "v$appVersion",
      "Accept-Platform": Platform.isIOS ? "ios" : "android"
    };
    // if (withAuth) {
    //   final credentialInfo = await CredentialManager().getTokenCredentialInfo;
    //   PrettyLogger.shared
    //       .i("CredentialManager - buildRequestOptions: $credentialInfo");
    //   final accessToken =
    //       credentialInfo != null ? credentialInfo.accessToken : '';
    //   final tokenType =
    //       credentialInfo != null ? credentialInfo.tokenType : "bearer";
    //   headersMap[HttpHeaders.authorizationHeader] = "$tokenType $accessToken";
    //   PrettyLogger.shared.d('Request token: $accessToken');
    // }
    // final Map<String, String>? configHeader =
    //     await BaseServiceConfigData().header?.call();
    // if (configHeader != null) {
    //   headersMap.addAll(configHeader);
    // }
    final requestOption = Options(
        method: _requestMethodInString(requestMethod: requestMethod),
        contentType: contentType,
        receiveTimeout: Duration(milliseconds: timeout),
        sendTimeout: Duration(milliseconds: timeout),
        validateStatus: (status) {
          return (status ?? 0) < 500;
        },
        headers: headersMap);
    return requestOption;
  }

  // Future<String> getBaseUrl(bool hasAuthToken) async {
  //   return hasAuthToken
  //       ? (await BaseServiceConfigData().baseLogicUrl?.call() ?? '')
  //       : (await BaseServiceConfigData().baseAuthenticationUrl?.call() ?? '');
  // }

  /// Send a request to [endPoint] using method [requestMethod]
  /// with [data] and [options].
  Future<dynamic> _sendRequest({
    RequestMethod requestMethod = RequestMethod.get,
    Map<String, dynamic>? queryParameters,
    required String url,
    dynamic data,
    String contentType = Headers.jsonContentType,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool handleCatchingDioError = true,
  }) async {
    try {
      final response = await dioClient.request(
        url,
        data: data,
        options: options,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      developer.log("[RESPONSE] $url - code: ${response.statusCode}");
      return _validateResponse(response).data;
    } on DioException catch (dioErr) {
      if (!handleCatchingDioError) {
        if (dioErr.error is SocketException) {
          throw "No internet access";
        }
        dynamic errorMessage = dioErr.response != null
            ? dioErr.response!.statusMessage
            : dioErr.error;
        if (dioErr.response?.data is List &&
            dioErr.response?.data?["errors"] != null) {
          try {
            final errorMessagesList =
                dioErr.response?.data["errors"] as List<dynamic>;
            if (errorMessagesList.isNotEmpty) {
              errorMessage = errorMessagesList.first;
            }
          } catch (err) {
            developer.log(err.toString());
          }
        }
        developer.log(dioErr.toString());
        throw errorMessage;
      } else {
        rethrow;
      }
    } on Exception catch (error) {
      developer.log("Error while sendRequest with message: $error");
      rethrow;
    }
  }

  String _retrieveErrorMessage(Response response) {
    dynamic errorMessage = response.statusMessage;
    if (response.data?["errors"] != null) {
      try {
        final errorMessagesList = response.data?["errors"] as List<dynamic>;
        if (errorMessagesList.isNotEmpty) {
          errorMessage = errorMessagesList.first;
        }
      } catch (err) {
        developer.log(err.toString());
      }
    }
    return errorMessage;
  }

  String _requestMethodInString({RequestMethod? requestMethod}) {
    switch (requestMethod) {
      case RequestMethod.get:
        return "GET";
      case RequestMethod.put:
        return "PUT";
      case RequestMethod.post:
        return "POST";
      case RequestMethod.delete:
        return "DELETE";
      case RequestMethod.patch:
        return "PATCH";
      default:
        return "GET";
    }
  }

  Response _validateResponse(Response response) {
    final statusCode = response.statusCode ?? 0;
    if (statusCode == 200) {
      return response;
    } else {
      final errorMessage = _retrieveErrorMessage(response);
      if (errorMessage.isNotEmpty) {
        response.statusMessage = errorMessage;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: response.data,
      );
    }
  }
}
