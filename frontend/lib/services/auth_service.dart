import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/constants.dart';

class AuthService {
  static Dio dio = Dio();
  static Box settings = Hive.box('settings');

  static Future<bool> setupAuthHeader() async {
    String? token = settings.get('authToken');

    if (token != null) {
      dio.options.headers["Authorization"] = "Bearer $token";
      return true;
    } else {
      dio.options.headers.remove("Authorization");
      return false;
    }
  }

  static Future<bool> verifyToken() async {
    if (!await setupAuthHeader()) return false;
    try {
      final response = await dio.get(
        "$BASE_URL/profile",
      );
      return response.statusCode == 200;
    } on DioError catch (_) {
      return false;
    }
  }

  static Future createUser(String email, String password) async {
    await setupAuthHeader();
    return await dio.post(
      '$BASE_URL/add-employee',
      data: {'email': email, 'password': password},
    );
  }

  static Future<Response> loginUser(String email, String password) async {
    dio.options.headers.remove("Authorization");
    return await dio
        .post('$BASE_URL/login', data: {'email': email, 'password': password});
  }

  static Future logOut() async {
    await setupAuthHeader();

    try {
      dynamic response = await dio.get(
        '$BASE_URL/logout',
      );
      return response;
    } on DioError catch (_) {
    } finally {
      settings.delete('authToken');
    }
  }
}
