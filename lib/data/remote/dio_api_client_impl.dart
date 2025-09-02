import 'dart:async';
import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mydrivenepal/data/model/optional_headers.dart';
import 'package:mydrivenepal/data/remote/status_codes.dart';
import 'package:mydrivenepal/navigation/navigation_routes.dart';
import 'package:mydrivenepal/shared/constant/remote_api_constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mydrivenepal/data/data.dart';
import 'package:mydrivenepal/data/remote/api_exceptions.dart';
import 'package:mydrivenepal/data/remote/data/model/api_response.dart';
import 'package:mydrivenepal/shared/constant/message/error_messages.dart';
import 'package:mydrivenepal/shared/constant/route_names.dart';
import 'package:mydrivenepal/shared/helper/jwt_helper.dart';

class DioApiClientImpl implements ApiClient {
  late Dio dio;
  final LocalStorageClient _sharedPrefManager;

  DioApiClientImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;

  @override
  init(String baseUrl) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        responseType: ResponseType.json,
        contentType: ContentType.json.toString(),
      ),
    )
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            await _requestInterceptorToAttachAccessToken(options, handler);
          },
          onError:
              (DioException exception, ErrorInterceptorHandler handler) async {
            await _onSessionExpired(exception, handler);
          },
        ),
      )
      ..interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: true,
        ),
      );
  }

  @override
  Future<ApiResponse> get(
    String path, {
    AdditionalHeaders? headers,
    Map<String, dynamic>? queryParameters,
    bool updateBaseUrl = false,
    String? url,
  }) async {
    if (updateBaseUrl && (url != null)) {
      this.updateBaseUrl(url);
    }

    String _baseUrl = dotenv.env["BASE_URL"]!;

    try {
      Response response = await dio.get(
        path,
        options: Options(headers: headers?.toJson()),
        queryParameters: queryParameters,
      );
      /*
        todo: remove this later. 
        This was done for comet chat response from API 
        but now we are using the comet chat classes.
      */
      if (updateBaseUrl) {
        this.updateBaseUrl(_baseUrl);
        final adoptResponse = mapApiResponse(response.data);
        return adoptResponse;
      } else {
        return ApiResponse.fromJson(response.data);
      }
    } catch (e) {
      if (updateBaseUrl) {
        this.updateBaseUrl(_baseUrl);
      }
      // if (e is DioException) {
      //   await _onSessionExpired(e, ErrorInterceptorHandler());
      //   print("e: $e");
      //   // navigationRouter.goNamed(AppRoute.login.name);
      // } else {
      //   print("e: $e");
      //   // navigationRouter.goNamed(AppRoute.login.name);
      // }
      debugPrint(
          'API Error | Method: GET | Path: $path | Error: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<ApiResponse> post(
    String path,
    dynamic body, {
    AdditionalHeaders? headers,
  }) async {
    try {
      Response response = await dio.post(
        path,
        data: body,
        options: Options(headers: headers?.toJson()),
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint(
          'API Error | Method: POST | Path: $path | Error: ${e.toString()}');

      if (path == RemoteAPIConstant.LOGIN ||
          path == RemoteAPIConstant.BIOMETRIC_LOGIN) {
        var response = e.response;
        if (response != null &&
            response.statusCode == HttpStatusCodes.Forbidden.code) {
          var responseData = response.data as Map<String, dynamic>;

          if (responseData.containsKey('code')) {
            return ApiResponse(data: responseData);
          }
        }
      }

      rethrow;
    } catch (e) {
      debugPrint(
          'API Error | Method: POST | Path: $path | Error: ${e.toString()}');

      rethrow;
    }
  }

  @override
  Future<ApiResponse> put(
    String path,
    dynamic body, {
    AdditionalHeaders? headers,
  }) async {
    try {
      Response response = await dio.put(
        path,
        data: body,
        options: Options(headers: headers?.toJson()),
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      debugPrint(
          'API Error | Method: PUT | Path: $path | Error: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<ApiResponse> patch(
    String path,
    dynamic body, {
    AdditionalHeaders? headers,
  }) async {
    try {
      Response response = await dio.patch(
        path,
        data: body,
        options: Options(headers: headers?.toJson()),
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      debugPrint(
          'API Error | Method: PATCH | Path: $path | Error: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<ApiResponse> delete(
    String path, {
    AdditionalHeaders? headers,
  }) async {
    try {
      Response response = await dio.delete(
        path,
        options: Options(headers: headers?.toJson()),
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      debugPrint(
          'API Error | Method: DELETE | Path: $path | Error: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<ApiResponse> multipartRequest(
    String path, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Function(int, int)? onSendProgress,
  }) async {
    try {
      FormData formData = FormData.fromMap(data ?? {});

      var response = await dio.patch(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(
            headers: {
          "Content-Type": "multipart/form-data",
        }..addAll(headers ?? {})),
      );

      return ApiResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  ApiResponse _returnResponse(Response response) {
    var apiResponse = ApiResponse.fromJson(response.data);
    if (apiResponse.success == true) {
      return apiResponse;
    } else {
      if (apiResponse.message is List && apiResponse.message!.isNotEmpty) {
        throw FailedResponseException(apiResponse.message);
      } else if (apiResponse.message is String) {
        throw FailedResponseException(apiResponse.message);
      } else {
        throw FailedResponseException(ErrorMessages.defaultError);
      }
    }
  }

  _requestInterceptorToAttachAccessToken(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken =
        await _sharedPrefManager.getString(LocalStorageKeys.ACCESS_TOKEN);
    if (accessToken != null) {
      // _checkJwtExpiry(accessToken);
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    options.headers['requestsource'] = 'localhost';
    options.headers['content-type'] = 'application/json';
    options.headers['ownerid'] = '3!@/fX7';
    options.headers['Accept'] = 'application/json, text/plain, /';
    return handler.next(options);
  }

  _checkJwtExpiry(String accessToken) {
    try {
      final jwtPayload =
          JwtHelper.verify(accessToken, dotenv.env['JWT_SECRET']!);
      debugPrint('jwt: $jwtPayload');
    } on JWTExpiredException {
      navigationRouter.goNamed(AppRoute.login.name);
    } on JWTException catch (e) {
      navigationRouter.goNamed(AppRoute.login.name);
    }
  }

  @override
  updateBaseUrl(String url) {
    dio.options.baseUrl = url;
  }

  _onSessionExpired(
    DioException exception,
    ErrorInterceptorHandler handler,
  ) async {
    if (exception.response?.statusCode == HttpStatusCodes.Unauthorized.code ||
        exception.response?.statusCode == HttpStatusCodes.Forbidden.code) {
      await _sharedPrefManager.remove(LocalStorageKeys.ACCESS_TOKEN);
      await _sharedPrefManager.remove(LocalStorageKeys.MEMBER_ID);
      await _sharedPrefManager.remove(LocalStorageKeys.DISCLAIMER_ACK);
      await _sharedPrefManager.setBool(LocalStorageKeys.BANNER_CLOSED, false);

      navigationRouter.goNamed(AppRoute.login.name);
    }
    return handler.next(exception);
  }
}

dynamic mapApiResponse(dynamic data) {
  return ApiResponse(
    success: true,
    data: data,
    message: "Data successfully mapped",
  );
}
