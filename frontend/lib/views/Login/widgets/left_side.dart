import 'package:axis/constants/constants.dart';
import 'package:axis/controller/HomeController/home_controller.dart';
import 'package:axis/controller/LoginController/login_controller.dart';
import 'package:axis/utilities/responsive_handler.dart';
import 'package:axis/views/AdminView/admin_view.dart';
import 'package:axis/views/Biodata/biodata.dart';
import 'package:axis/views/EmployeeData/employee_data.dart';
import 'package:axis/views/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPageLeftSide extends StatelessWidget {
  LoginPageLeftSide({Key? key}) : super(key: key);

  final LoginController loginController = Get.find();
  final HomeController homeController = Get.find();
  final _loginFormKey = GlobalKey<FormState>();

  Widget togo() {
    Widget url = HomeScreen();

    if (loginController.isSuperuser.value) {
      url = AdminScreen();
    } else {
      if (homeController.bioUploaded.value) {
        url = EmployeeDataScreen();
      }
      if (!homeController.emplDataUploaded.value) {
        if (!homeController.bioUploaded.value) {
          url = BioDataScreen();
        } else {
          url = EmployeeDataScreen();
        }
      }

      if (homeController.emplDataUploaded.value &&
          homeController.bioUploaded.value) {
        url = HomeScreen();
      }
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: Responsive.isMobile(context)
            ? const EdgeInsets.only(left: 80.0, right: 80)
            : const EdgeInsets.only(left: 120.0, right: 120),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                  height: 120,
                  width: 150,
                  child: Image.asset('assets/images/logo.png')),
            ),
            const Text(
              "Login",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 15,
            ),
            Form(
              key: _loginFormKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      label: const Text("Email"),
                    ),
                    cursorColor: greenColor,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter your email';
                      }
                      bool isEmail = RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                          .hasMatch(val.trimRight());
                      if (!isEmail) {
                        return 'Please enter a valid email';
                      }

                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    onChanged: (value) => loginController.email(value),
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(
                      label: const Text("Password"),
                    ),
                    cursorColor: greenColor,
                    onChanged: (value) => loginController.password(value),
                    validator: MultiValidator(
                      [
                        RequiredValidator(
                          errorText: 'Password is required',
                        ),
                        MinLengthValidator(5,
                            errorText:
                                'Password must be atleast 5 characters long'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => MaterialButton(
                      onPressed: loginController.isLoading.value
                          ? null
                          : () async {
                              if (_loginFormKey.currentState!.validate()) {
                                await loginController
                                    .loginUser(
                                        loginController.email.value.trim(),
                                        loginController.password.value.trim())
                                    .then(
                                  (response) {
                                    return !response.success
                                        ? showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                title: Icon(
                                                  Icons.error,
                                                  color: redColor,
                                                  size: 40,
                                                ),
                                                content: Text(
                                                  response.message,
                                                  textAlign: TextAlign.center,
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          )
                                        : Get.offAll(() => togo());
                                  },
                                );
                              }
                            },
                      minWidth: double.infinity,
                      height: 52,
                      elevation: 10,
                      color: greenColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: loginController.isLoading.value
                          ? CircularProgressIndicator(
                              color: greenColor,
                            )
                          : Text(
                              'LOGIN',
                              style: GoogleFonts.notoSans().copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
