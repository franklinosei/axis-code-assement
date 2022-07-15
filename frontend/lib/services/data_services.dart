import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/constants.dart';
import '../model/BiodataModel/biodata_model.dart';
import '../model/EmploymentDataModel/employment_data_model.dart';

class DataServices {
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

  static Future setBiodata(BioDataModel biodata) async {
    await setupAuthHeader();

    FormData formData = FormData.fromMap(biodata.toJson());

    return await dio.post(
      '$BASE_URL/update-biodata',
      data: formData,
    );
  }

  static Future passportPictureUploadWeb(var passport) async {
    await setupAuthHeader();

    FormData data = FormData.fromMap({
      'passport_photo':
          MultipartFile.fromBytes(passport, filename: 'passport.jpg'),
    });

    var response = await dio.post(
      '$BASE_URL/update_profile_picture',
      data: data,
    );
    return response;
  }

  static Future setEmploymentData(EmploymentDataModel emplData) async {
    await setupAuthHeader();
    FormData formData = FormData.fromMap(emplData.toJson());
    return await dio.post(
      '$BASE_URL/update-employment-data',
      data: emplData.toJson(),
    );
  }

  static Future getAllEmployees() async {
    await setupAuthHeader();
    try {
      final response = await dio.get(
        "$BASE_URL/get-employees",
      );
      return response.data;
    } on DioError catch (_) {
      return false;
    }
  }

  static Future getProfile() async {
    await setupAuthHeader();
    try {
      dynamic response = await dio.get(
        "$BASE_URL/profile",
      );
      return response;
    } on DioError catch (_) {
      return false;
    }
  }

  static Future getBioStatus() async {
    await setupAuthHeader();
    try {
      dynamic response = await dio.get(
        "$BASE_URL/biodata-status",
      );
      return response;
    } on DioError catch (_) {
      // return false;
    }
  }

  static Future getEmpDataStatus() async {
    await setupAuthHeader();
    try {
      dynamic response = await dio.get(
        "$BASE_URL/employment-data-status",
      );
      return response;
    } on DioError catch (_) {
      // return false;
    }
  }
}
