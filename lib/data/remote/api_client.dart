import 'package:mydrivenepal/data/model/optional_headers.dart';
import 'package:mydrivenepal/data/remote/data/model/api_response.dart';

abstract class ApiClient {
  Future<ApiResponse> get(
    String path, {
    AdditionalHeaders? headers,
    Map<String, dynamic>? queryParameters,
    bool updateBaseUrl = false,
    String? url,
  });

  Future<ApiResponse> post(
    String path,
    dynamic body, {
    AdditionalHeaders? headers,
  });

  Future<ApiResponse> put(
    String path,
    dynamic body, {
    AdditionalHeaders? headers,
  });

  Future<ApiResponse> patch(
    String path,
    dynamic body, {
    AdditionalHeaders? headers,
  });

  Future<ApiResponse> delete(
    String path, {
    AdditionalHeaders? headers,
  });

  Future<ApiResponse> multipartRequest(String path,
      {Map<String, dynamic> data, Map<String, String> headers});

  updateBaseUrl(String url);

  init(String url);
}
