import 'package:axis/constants/constants.dart';
import 'package:axis/controller/AdminController/admin_controller.dart';
import 'package:axis/views/AdminView/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewRecords extends StatelessWidget {
  ViewRecords({Key? key}) : super(key: key);

  final AdminController adminController = Get.find();

  @override
  Widget build(BuildContext context) {
    return adminController.getLoading.value
        ? Center(
            child: CircularProgressIndicator(
              color: greenColor,
            ),
          )
        : Scaffold(
            body: Container(
              color: Colors.grey.shade100,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 30,
                ),
                children: [
                  const Text(
                    "All Employees",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 10,
                    runSpacing: 20,
                    children: [
                      for (var i = 0;
                          i < adminController.fullUserData.value.length;
                          i++)
                        EmployeeDataCard(
                          userData: adminController.fullUserData.value[i],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
