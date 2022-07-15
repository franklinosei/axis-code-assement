import 'package:axis/constants/constants.dart';
import 'package:axis/controller/AdminController/admin_controller.dart';
import 'package:axis/views/AdminView/widgets/add_user.dart';
import 'package:axis/views/AdminView/widgets/view_records.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminScreen extends StatelessWidget {
  AdminScreen({Key? key}) : super(key: key);

  final AdminController adminController = Get.find();

  List<Widget> pages = [AddUser(), ViewRecords()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Row(
          children: <Widget>[
            NavigationRail(
              indicatorColor: greenColor,
              selectedIconTheme: IconThemeData(
                color: greenColor,
              ),
              selectedLabelTextStyle: TextStyle(
                color: greenColor,
              ),
              selectedIndex: adminController.selectedIndex.value,
              onDestinationSelected: (int index) {
                adminController.selectedIndex(index);
              },
              labelType: NavigationRailLabelType.selected,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  selectedIcon: Icon(Icons.person),
                  label: Text('Add User'),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.library_books_sharp,
                  ),
                  selectedIcon: Icon(Icons.book),
                  label: Text('View records'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            // This is the main content.
            Expanded(
              child: pages[adminController.selectedIndex.value],
            ),
          ],
        ),
      ),
    );
  }
}
