import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /// Todo: add token declare
    // final token = userLocalStorage.token;
    // if (token.isNotEmpty) {
    //   Map<String, String> headers = new Map();
    //   headers["accept"] = 'application/json';
    //   headers["Authorization"] = 'Bearer $token';
    //   headers["Content-Type"] = 'application/json';
    //   options.headers = headers;
    // }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    /// Todo: handle error case
    // if (error.response?.statusCode == 401) {
    //   final refreshResponse = await refreshToken();
    //   final dio = Dio();
    //   if(refreshResponse == null) {
    //     super.onError(error, handler);
    //     return;
    //   }
    //   userLocalStorage.refreshToken = refreshResponse.refreshToken;
    //   userLocalStorage.token = refreshResponse.token;
    //   final requestOption = error.requestOptions;
    //   requestOption.headers["Authorization"] = 'Bearer ${refreshResponse.token}';
    //   final retry = await _retry(error.requestOptions, dio);
    //   handler.resolve(retry);
    // }
    super.onError(err, handler);
  }

  // Future<Response<dynamic>> _retry(
  //     RequestOptions requestOptions, Dio dio) async {
  //   final options = new Options(
  //     method: requestOptions.method,
  //     headers: requestOptions.headers,
  //   );
  //   final result = await dio.request<dynamic>('${AppApi.basePath}${requestOptions.path}',
  //       data: requestOptions.data,
  //       queryParameters: requestOptions.queryParameters,
  //       options: options);
  //   return result;
  // }

  // Future<UserResponse?> refreshToken() async {
  //   final refreshToken = userLocalStorage.refreshToken;
  //   if (refreshToken.isEmpty) return null;
  //   Dio dio = new Dio();
  //   final request = RefreshTokenRequest(refreshToken: refreshToken);
  //   final _data = <String, dynamic>{};
  //   _data.addAll(request.toJson());
  //   Response response;
  //   try {
  //     response =
  //     await dio.post("${AppApi.basePath}auth/refresh-token", data: _data);
  //     return UserResponse.fromJson(response.data as Map<String, dynamic>);
  //   } catch (e) {
  //     return null;
  //   }
  // }
}
