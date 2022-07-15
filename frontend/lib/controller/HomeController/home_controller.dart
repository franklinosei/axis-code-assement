import 'dart:convert';

import 'package:axis/services/data_services.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool bioUploaded = false.obs;
  RxBool emplDataUploaded = false.obs;

  Future getBioDataStatus() async {
    try {
      var bioRes = await DataServices.getBioStatus();

      if (bioRes != null) {
        bioUploaded(jsonDecode(bioRes.toString())['status'] as bool);
      }
    } on DioError catch (error) {
      var message = error.response?.statusMessage.toString();
    }
  }

  Future getEmplDataStatus() async {
    try {
      var empRes = await DataServices.getEmpDataStatus();

      if (empRes != null) {
        var tmp = jsonDecode(empRes.toString())['status'] as bool;
        emplDataUploaded(tmp);
      }
    } on DioError catch (error) {
      var message = error.response?.statusMessage.toString();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getBioDataStatus();
    getEmplDataStatus();
  }
}
