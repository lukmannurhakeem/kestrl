import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../repositories/stock_repository.dart';
import '../constants/constant.dart';
import '../widgets/common_widget.dart';
import 'local_db_service.dart';
import 'locator_service.dart';

class APIService {
  Dio dio = Dio();
  static APIService get instance => locator<APIService>();
  final StockRepository stockRepository = StockRepository();
  String url = stgUrl;

  APIService() {
    dio = Dio(
      BaseOptions(
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 30),
      ),
    );
    dio.interceptors
        .add(PrettyDioLogger(requestBody: true, requestHeader: true));
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.type == DioExceptionType.connectionError) {
            try {
              final cachedListings = stockRepository.getStoredStockListings();

              if (cachedListings != null && cachedListings.isNotEmpty) {
                print('Using cached stock listings due to connection error');

                // Create a success response with cached data
                final Response response = Response(
                  requestOptions: error.requestOptions,
                  data: cachedListings,
                  statusCode: 200,
                );

                return handler.resolve(response);
              }
            } catch (e) {
              print('Error retrieving cached data: $e');
            }
          }
          snackBarFailed(
              content: CustomException(
                      handleError(error), error.response!.statusCode!)
                  .toString());
          handler.reject(error);
        },
      ),
    );
  }

  Future<Response<dynamic>> retry(RequestOptions requestOptions) async {
    final Options options = Options(
      method: requestOptions.method,
      headers: {'authorization': 'Bearer ${LocalDBService().getToken()}'},
    );
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<Response> get(Object? body,
      {String? endpoint,
      String? fullUrl,
      String? version,
      Map<String, dynamic>? parameters}) {
    return dio.get(
      (fullUrl == null) ? (url + (endpoint ?? '')) : fullUrl,
      data: body,
      options: Options(
          headers: {'authorization': 'Bearer ${LocalDBService().getToken()}'}),
      queryParameters: parameters,
    );
  }

  Future<Response> post(dynamic body,
      {String? endpoint,
      String? fullUrl,
      String? version,
      Map<String, dynamic>? header}) {
    return dio.post(
      (fullUrl == null) ? (url + (endpoint ?? '')) : fullUrl,
      data: body,
      options: Options(
        headers: header ??
            {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'authorization': 'Bearer ${LocalDBService().getToken()}',
            },
      ),
    );
  }

  Future<Response> postOAuth2(dynamic body,
      {String? endpoint,
      String? fullUrl,
      String? version,
      Map<String, dynamic>? header}) {
    return dio.post(
      (fullUrl == null) ? (url + (endpoint ?? '')) : fullUrl,
      data: body,
      options: Options(
        headers: header ??
            {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'authorization': 'Bearer ${LocalDBService().getToken()}',
            },
      ),
    );
  }

  Future<void> getTokenOAuth2() async {
    final String basicAuth = '';
    // 'Basic ${base64.encode(utf8.encode('$clientId:$clientSecret'))}';
    try {
      final Response response = await APIService.instance.post(
        <String, String>{'grant_type': 'client_credentials'},
        fullUrl: 'https://oauth-beta-01.tetralogiq.com/api/0.1/oauth/token',
        header: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'authorization': basicAuth,
        },
      );
      final String token = response.data['access_token'];
      await LocalDBService().setToken(token);
    } on DioException catch (error) {
      throw CustomException(
          handleError(error), error.response?.statusCode ?? 0);
    }
  }

  Future<Response> put(dynamic body,
      {String? endpoint,
      String? fullUrl,
      String? version,
      Map<String, dynamic>? header}) {
    return dio.put(
      (fullUrl == null) ? (url + (endpoint ?? '')) : fullUrl,
      data: body,
      options: Options(
        headers: header ??
            {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'authorization': 'Bearer ${LocalDBService().getToken()}',
            },
      ),
    );
  }

  Future<Response> delete({String? endpoint, String? fullUrl}) {
    return dio.delete(
      (fullUrl == null) ? (url + (endpoint ?? '')) : fullUrl,
      options: Options(
        headers: {
          'authorization': 'Bearer ${LocalDBService().getToken()}',
        },
      ),
    );
  }
}

class CustomException extends APIService implements Exception {
  final String message;
  final int errorCode;
  CustomException(this.message, this.errorCode);

  String printMessage() {
    String statusDesc = '';
    try {
      final Map<String, dynamic> responseObject = jsonDecode(message);
      statusDesc = responseObject['statusList'][0]['statusDesc'];
    } catch (e) {
      statusDesc = message;
    }

    return statusDesc;
  }

  @override
  String toString() {
    return printMessage();
  }
}

String handleError(DioException error) {
  String errorDescription = '';
  switch (error.type) {
    case DioExceptionType.cancel:
      errorDescription = 'Request to API server was cancelled';
    case DioExceptionType.connectionTimeout:
      errorDescription = 'Connection timeout with API server';
    case DioExceptionType.connectionError:
      errorDescription =
          'Connection to API server failed due to internet connection';
    case DioExceptionType.receiveTimeout:
      errorDescription = 'Receive timeout in connection with API server';
    case DioExceptionType.badResponse:
      String errorMessage = '';
      if (error.response?.data['error'] != null &&
          error.response?.data['error_description'] != null) {
        errorMessage = '${error.response?.data['error_description']}';
      } else if (error.response?.data['statusList'] != null &&
          error.response?.data['statusList'].isNotEmpty) {
        errorMessage = error.response?.data['statusList'].first['statusDesc'];
      } else {
        errorMessage = error.response!.statusCode.toString();
      }
      errorDescription = errorMessage;
    case DioExceptionType.sendTimeout:
      errorDescription = 'Send timeout in connection with API server';
    case DioExceptionType.badCertificate:
      errorDescription = 'Error Bad Certificate';
    case DioExceptionType.unknown:
      errorDescription = 'Unknown Error occur';
  }
  return errorDescription;
}
