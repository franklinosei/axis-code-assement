import 'dart:io';

import 'package:axis/controller/AdminController/admin_controller.dart';
import 'package:axis/controller/BiodataController/biodata_controller.dart';
import 'package:axis/controller/EmploymentDataContoller/employment_data_controller.dart';
import 'package:axis/controller/HomeController/home_controller.dart';
import 'package:axis/controller/LoginController/login_controller.dart';
import 'package:axis/services/auth_service.dart';
// import 'package:axis/views/AdminView/admin_view.dart';
import 'package:axis/views/Biodata/biodata.dart';
import 'package:axis/views/EmployeeData/employee_data.dart';
import 'package:axis/views/Home/home.dart';
import 'package:axis/views/Loading/loading.dart';
import 'package:axis/views/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await openHiveBox('settings');

  // remove this line since it's now only mobile
  setPathUrlStrategy();

  runApp(const MyApp());
}

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = dir.path;
    File dbFile = File('$dirPath/$boxName.hive');
    File lockFile = File('$dirPath/$boxName.lock');

    await dbFile.delete();
    await lockFile.delete();
    await Hive.openBox(boxName);
    throw 'Failed to open $boxName Box\nError: $error';
  });
  // clear box if it grows large
  if (limit && box.length > 500) {
    box.clear();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Widget pageToRender = const LoginScreen();
  // late Widget pageToRender = const LoadingScreen();
  // late Widget pageToRender = AdminScreen();
  // late Widget pageToRender = BioDataScreen();
  // late Widget pageToRender = EmployeeDataScreen();

//add controllers here
  LoginController loginController = Get.put(LoginController());
  BioDataController bioDataController = Get.put(BioDataController());
  EmploymentDataController employmentDataController =
      Get.put(EmploymentDataController());

  HomeController homeController = Get.put(HomeController());
  AdminController adminController = Get.put(AdminController());

  @override
  void initState() {
    super.initState();

    AuthService.verifyToken().then(
      (valid) {
        if (valid) {
          if (homeController.bioUploaded.value) {
            pageToRender = EmployeeDataScreen();
          }
          if (!homeController.emplDataUploaded.value) {
            if (!homeController.bioUploaded.value) {
              pageToRender = BioDataScreen();
            } else {
              pageToRender = EmployeeDataScreen();
            }
          }

          if (homeController.emplDataUploaded.value &&
              homeController.bioUploaded.value) {
            pageToRender = HomeScreen();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSans',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: pageToRender,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/': (context) => pageToRender,
        // '/biodata': (context) => BioDataScreen(),
        // '/employment': (context) => EmployeeDataScreen(),
      },
    );
  }
}
