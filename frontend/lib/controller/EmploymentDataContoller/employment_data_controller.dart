import 'dart:convert';
import 'package:axis/model/EmploymentDataModel/employment_data_model.dart';
import 'package:axis/services/data_services.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../model/HttpResponse/http_response.dart';

class EmploymentDataController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<EmploymentDataModel> userData = EmploymentDataModel().obs;
  Rx<String> employment_date = ''.obs;

  Future<HttpResponse> uploadEmploymentData() async {
    var httpReponse = HttpResponse(
      message: "Biodata uploaded successfully",
      success: true,
      statusCode: 200,
      data: true,
    );

    try {
      isLoading(true);
      var response = await DataServices.setEmploymentData(userData.value);

      if (response?.statusCode == 200) {
        httpReponse.message = response.toString();
      } else {
        print(response);

        httpReponse.success = false;
        httpReponse.message =
            jsonDecode(response.toString())["detail"] ?? "Upload failed";
        httpReponse.statusCode = response.statusCode;
      }

      isLoading(false);
      return httpReponse;
    } on DioError catch (error) {
      var message = error.response?.statusMessage.toString();

      isLoading(false);

      return HttpResponse(
        message: message ?? "Error! Upload failed",
        success: false,
        statusCode: error.response!.statusCode!,
        data: false,
      );
    }
  }
}
