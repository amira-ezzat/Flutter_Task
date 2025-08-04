import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  // Initialize Dio instance with base options
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://hoshi.runasp.net/api/', // Replace with your base URL
        receiveDataWhenStatusError: true,
      ),
    );
  }

  // GET request
  static Future<Response> getData({
    required String url,
    Map<String, dynamic> query = const {},
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token != null ? 'Bearer $token' : '',
      'Content-Type': 'application/json',
    };

    return await dio!.get(url, queryParameters: query);
  }

  // POST request
  static Future<Response> postData({
    required String url,

    required dynamic
    data, // Data can be either Map<String, dynamic> or FormData
    Map<String, dynamic> query = const {},
    String lang = 'en',
    String? token,
    bool isMultipart = false, // Flag to indicate multipart/form-data
  }) async {
    // Set the headers for the request
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token != null ? 'Bearer $token' : '',
      'Content-Type': isMultipart ? 'multipart/form-data' : 'application/json',
    };

    // If the content type is multipart, adjust the headers accordingly
    if (isMultipart) {
      dio!.options.headers['Content-Type'] = 'multipart/form-data';
      // Ensure the data is a FormData object when using multipart
      if (data is! FormData) {
        throw Exception('Data must be FormData for multipart requests');
      }
    } else {
      dio!.options.headers['Content-Type'] = 'application/json';
    }

    return dio!.post(url, queryParameters: query, data: data);
  }

  // PUT request
  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic> query = const {},
    String lang = 'en',
    String? token,
  }) async {
    try {
      if (dio == null) throw Exception('Dio is not initialized');

      dio!.options.headers = {
        'lang': lang,
        'Authorization': token != null ? 'Bearer $token' : '',
        'Content-Type': 'application/json',
      };

      return await dio!.put(url, queryParameters: query, data: data);
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  static Future<Response> patchData({
    required String url,
    required dynamic data, // Allow both FormData and JSON
    Map<String, dynamic> query = const {},
    String lang = 'en',
    String? token, // Ensure token is not null
  }) async {
    try {
      if (dio == null) throw Exception('Dio is not initialized');

      if (token == null || token.isEmpty) {
        throw Exception('Authorization token is missing');
      }

      dio!.options.headers = {
        'lang': lang,
        'Authorization': 'Bearer $token', // Ensure proper format
        'Content-Type':
            data is FormData ? 'multipart/form-data' : 'application/json',
      };

      return await dio!.patch(url, queryParameters: query, data: data);
    } catch (e) {
      throw Exception('PATCH request failed: $e');
    }
  }

  // DELETE request
  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic> query = const {},
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token != null ? 'Bearer $token' : '',
      'Content-Type': 'application/json',
    };

    return await dio!.delete(url, queryParameters: query);
  }
}
