import 'package:dio/dio.dart';

String baseUrl = 'http://192.168.1.24:3000/api/';
String chatUrl = 'ws://laravel2.chefcoders.com/app/chatapp_key';

class DioHelper {
  static late Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Optional: enable logging (remove in production)
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  // ================= PRIVATE HEADER BUILDER =================
  static Options _buildOptions(String? token) {
    return Options(
      headers: {
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token',
      },
    );
  }

  // ================= GET =================
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    print("TOKEN BEFORE REQUEST: $token");

    return await dio.get(
      url,
      queryParameters: query,
      options: _buildOptions(token),
    );
  }

  // ================= POST =================
  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    return await dio.post(
      url,
      queryParameters: query,
      data: data,
      options: _buildOptions(token),
    );
  }

  // ================= POST IMAGE =================
  static Future<Response> postDataImage({
    required String url,
    required FormData data,
    Map<String, dynamic>? query,
    String? token,
    ProgressCallback? onSendProgress,
  }) async {
    return await dio.post(
      url,
      queryParameters: query,
      data: data,
      onSendProgress: onSendProgress,
      options: Options(
        headers: {
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  // ================= PUT =================
  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    return await dio.put(
      url,
      data: data,
      options: _buildOptions(token),
    );
  }

  // ================= DELETE =================
  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    return await dio.delete(
      url,
      data: data,
      options: _buildOptions(token),
    );
  }
}