import 'package:axis/controller/AdminController/admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/constants.dart';
import '../../../utilities/responsive_handler.dart';

class AddUser extends StatelessWidget {
  AddUser({Key? key}) : super(key: key);
  final _addUserFormKey = GlobalKey<FormState>();

  AdminController adminController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      margin: const EdgeInsets.all(120),
      child: Center(
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
                "Add New Employee",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _addUserFormKey,
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
                      onChanged: (value) => adminController.email(value),
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
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
                      onChanged: (value) => adminController.password(value),
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
                        onPressed: adminController.isLoading.value
                            ? null
                            : () async {
                                if (_addUserFormKey.currentState!.validate()) {
                                  await adminController
                                      .addEmployee(
                                          adminController.email.value.trim(),
                                          adminController.password.value.trim())
                                      .then(
                                    (response) {
                                      return !response.success
                                          ? showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                          : showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  title: Icon(
                                                    Icons
                                                        .thumb_up_off_alt_sharp,
                                                    color: greenColor,
                                                    size: 40,
                                                  ),
                                                  content: const Text(
                                                    "Employee added",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('OK'),
                                                      onPressed: () {
                                                        adminController
                                                            .email.value = "";
                                                        adminController
                                                            .email.value = "";
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                    },
                                  );
                                }
                              },
                        minWidth: 150,
                        height: 52,
                        elevation: 10,
                        color: greenColor,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: adminController.isLoading.value
                            ? CircularProgressIndicator(
                                color: greenColor,
                              )
                            : Text(
                                'Add User',
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
      ),
    );
  }
}
