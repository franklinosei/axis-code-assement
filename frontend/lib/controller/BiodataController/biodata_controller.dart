import 'dart:convert';
import 'package:axis/model/BiodataModel/biodata_model.dart';
import 'package:axis/services/data_services.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../model/HttpResponse/http_response.dart';

class BioDataController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<BioDataModel> userData = BioDataModel().obs;
  Rx<String> appointment_date = ''.obs;
  Rx<String> dob = ''.obs;
  Rx<String> passport_photo = ''.obs;
  RxList? webImage = [].obs;

  Future<HttpResponse> uploadBioData() async {
    var httpReponse = HttpResponse(
      message: "Biodata uploaded successfully",
      success: true,
      statusCode: 200,
      data: true,
    );

    try {
      isLoading(true);

      print(userData.value.toJson());

      var response = await DataServices.setBiodata(userData.value);

      if (response?.statusCode == 200) {
        httpReponse.message = response.toString();
        // isLoading(false);
        // return httpReponse;

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
      print(error.response);

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
