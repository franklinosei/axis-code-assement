import 'dart:convert';

import 'package:axis/model/FullUserDataModel/full_user_data_model.dart';
import 'package:axis/services/data_services.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../model/HttpResponse/http_response.dart';
import '../../services/auth_service.dart';

class AdminController extends GetxController {
  RxInt selectedIndex = 0.obs;
  Rx<String> email = ''.obs;
  Rx<String> password = ''.obs;
  RxBool isLoading = false.obs;
  RxList fullUserData = [].obs;
  RxBool getLoading = false.obs;

  Future<HttpResponse<bool>> addEmployee(String email, String password) async {
    var httpReponse = HttpResponse(
      message: "User added successfully",
      success: true,
      statusCode: 200,
      data: true,
    );

    try {
      isLoading(true);

      dynamic response = await AuthService.createUser(email, password);

      if (response == null) {
        httpReponse.success = false;
        httpReponse.message = jsonDecode(response.toString())["detail"];
      }
      isLoading(false);
      return httpReponse;
    } on DioError catch (error) {
      var message = jsonDecode(error.response.toString())["detail"];
      isLoading(false);

      return HttpResponse(
        message: message ?? "Couldn't add employee",
        success: false,
        statusCode: error.response!.statusCode!,
        data: false,
      );
    }
  }

  Future<HttpResponse<bool>> getEmployees() async {
    var httpReponse = HttpResponse(
      message: "Fetched Data Successfully",
      success: true,
      statusCode: 200,
      data: true,
    );

    try {
      getLoading(true);

      dynamic response = await DataServices.getAllEmployees() as List;

      // print(response);

      if (response == null) {
        httpReponse.success = false;
        httpReponse.message = jsonDecode(response.toString())["detail"];
      } else {
        var tmp = response.map((e) => FullUserDataModel.fromJson(e)).toList();
        fullUserData(tmp);
      }
      getLoading(false);
      return httpReponse;
    } on DioError catch (error) {
      var message = jsonDecode(error.response.toString())["detail"];
      getLoading(false);

      return HttpResponse(
        message: message ?? "Couldn't add employee",
        success: false,
        statusCode: error.response!.statusCode!,
        data: false,
      );
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getEmployees();
  }
}
