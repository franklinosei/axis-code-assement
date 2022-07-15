import 'package:axis/controller/HomeController/home_controller.dart';
import 'package:axis/views/EmployeeData/employee_data.dart';
import 'package:axis/views/Home/HomeWidget/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Biodata/biodata.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    // if (homeController.bioUploaded.value &&
    //     !homeController.emplDataUploaded.value) {
    //   return EmployeeDataScreen();
    // } else if (!homeController.bioUploaded.value &&
    //     homeController.emplDataUploaded.value) {
    //   return BioDataScreen();
    // } else if (homeController.bioUploaded.value &&
    //     homeController.emplDataUploaded.value) {
    //   return HomeWidget();
    // }
    // return BioDataScreen();
    return HomeWidget();
  }
}
