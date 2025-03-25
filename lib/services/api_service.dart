// import 'dart:convert';

// import 'package:app_mobile/services/api_config.dart';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const int timeout = 60;

//   Future<http.Response> post(
//       {String? path,
//       Map<String, String>? headers,
//       Map<String, dynamic>? body,
//       Map<String, dynamic>? queryParams}) async {
//     var uri = Uri.https(ApiConfig.baseUrl, path!, queryParams);
//     final response = await http
//         .post(
//           uri,
//           body: body != null ? json.encode(body) : null,
//           headers: headers,
//         )
//         .timeout(const Duration(seconds: timeout));

//     print("Status Code : ${response.statusCode}");

//     return response;
//   }

//   Future<http.Response> get(
//       {String? path,
//       Map<String, String>? headers,
//       Map<String, dynamic>? queryParams}) async {
//     var uri = Uri.https(ApiConfig.baseUrl, path!, queryParams);
//     print('URL : $uri');
//     final response = await http
//         .get(uri, headers: headers)
//         .timeout(const Duration(seconds: timeout));

//     print("Status Code : ${response.statusCode}");

//     return response;
//   }
// }

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:app_mobile/services/api_config.dart';

class ApiService {
  static const int timeout = 60;
  final Dio dio = Dio();

  // Constructor untuk mengonfigurasi dio (jika diperlukan)
  ApiService() {
    dio.options.baseUrl = 'https://${ApiConfig.baseUrl}';
    dio.options.connectTimeout =
        Duration(seconds: timeout); // Timeout untuk koneksi
    dio.options.receiveTimeout =
        Duration(seconds: timeout); // Timeout untuk menerima data
    dio.interceptors.add(LogInterceptor(
        responseBody: true,
        requestBody: true)); // Tambahkan interceptor untuk logging
  }

  Future<Response> post({
    String? path,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      // Menyiapkan request options (headers, query parameters)
      final options = Options(
        headers: headers,
        contentType: Headers.jsonContentType,
      );

      // Mengirim request POST menggunakan Dio
      Response response = await dio.post(
        path!,
        data: body != null ? json.encode(body) : null,
        queryParameters: queryParams,
        options: options,
      );

      // Mencetak status code
      print("Status Code : ${response.statusCode}");

      return response;
    } catch (e) {
      // Menangani error dan memberi tahu jika terjadi kegagalan
      print("Error occurred: $e");
      rethrow;
    }
  }

  Future<Response> get({
    String? path,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      // Menyiapkan request options (headers, query parameters)
      final options = Options(headers: headers);

      // Mengirim request GET menggunakan Dio
      Response response = await dio.get(
        path!,
        queryParameters: queryParams,
        options: options,
      );

      // Mencetak status code
      print("Status Code : ${response.statusCode}");

      return response;
    } catch (e) {
      // Menangani error dan memberi tahu jika terjadi kegagalan
      print("Error occurred: $e");
      rethrow;
    }
  }
}
