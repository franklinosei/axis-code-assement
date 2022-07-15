import 'dart:convert';
import 'package:axis/controller/HomeController/home_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../model/HttpResponse/http_response.dart';
import '../../services/auth_service.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var email = ''.obs;
  var password = ''.obs;
  var isSuperuser = false.obs;
  RxBool obscurePassword = true.obs;

  HomeController homeController = Get.put(HomeController());

  Future<HttpResponse<bool>> loginUser(String email, String password) async {
    var httpReponse = HttpResponse(
      message: "Login successful",
      success: true,
      statusCode: 200,
      data: true,
    );

    try {
      isLoading(true);

      dynamic response = await AuthService.loginUser(email, password);

      String? token =
          await jsonDecode(response.toString())["access_token"]["access_token"];
      bool? isAdmin =
          await jsonDecode(response.toString())["is_superuser"] as bool;

      if (isAdmin) {
        isSuperuser(isAdmin);
      }

      if (token != null) {
        Box settings = Hive.box('settings');
        settings.put('authToken', token);

        homeController.getBioDataStatus();
        homeController.getEmplDataStatus();
      } else {
        httpReponse.success = false;
        httpReponse.message = jsonDecode(response.toString())["detail"];
      }
      isLoading(false);
      return httpReponse;
    } on DioError catch (error) {
      var message = jsonDecode(error.response.toString())["detail"];
      isLoading(false);

      return HttpResponse(
        message: message ?? "Couldn't login",
        success: false,
        statusCode: error.response!.statusCode!,
        data: false,
      );
    }
  }

  Future logOutUser() async {
    var httpReponse = HttpResponse(
      message: "Logout successful",
      success: true,
      statusCode: 200,
      data: true,
    );

    try {
      dynamic response = await AuthService.logOut();

      if (response == null) {
        httpReponse.success = false;
        httpReponse.message = jsonDecode(response.toString())["detail"];
      } else {
        Box settings = Hive.box('settings');
        settings.delete('authToken');
      }
    } on DioError catch (error) {
      var message = jsonDecode(error.response.toString())["detail"];

      return HttpResponse(
        message: message ?? "Couldn't logout",
        success: false,
        statusCode: error.response!.statusCode!,
        data: false,
      );
    }
  }
}
