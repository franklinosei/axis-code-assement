import 'package:axis/controller/EmploymentDataContoller/employment_data_controller.dart';
import 'package:axis/views/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constants/constants.dart';
import '../../utilities/responsive_handler.dart';
import '../Login/widgets/right_side.dart';

class EmployeeDataScreen extends StatelessWidget {
  EmployeeDataScreen({Key? key}) : super(key: key);

  final EmploymentDataController employmentDataController = Get.find();
  final _emplFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Row(
        children: [
          !Responsive.isMobile(context) && !Responsive.isTablet(context)
              ? LoginPageRightSide(
                  img_url: 'assets/images/forms2.jpg',
                )
              : Container(),
          SingleChildScrollView(
            child: Container(
              // height: MediaQuery.of(context).size.height,
              width: Responsive.isMobile(context)
                  ? MediaQuery.of(context).size.width
                  : 800,
              margin: Responsive.isMobile(context)
                  ? const EdgeInsets.only(
                      left: 24, right: 24, top: 30, bottom: 50)
                  : const EdgeInsets.only(
                      left: 24, right: 24, top: 30, bottom: 150),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: Responsive.isMobile(context)
                    ? const EdgeInsets.only(left: 20.0, right: 20)
                    : const EdgeInsets.only(left: 120.0, right: 120),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Complete this form by providing your employment data",
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: _emplFormKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1970),
                                lastDate: DateTime(2100),
                              ).then((date) {
                                if (date != null) {
                                  employmentDataController.userData.value
                                      .employment_date = date.toString();

                                  employmentDataController
                                          .employment_date.value =
                                      DateFormat.yMEd().format(date);
                                }
                              });
                            },
                            child: Obx(
                              () => TextFormField(
                                // readOnly: true,
                                cursorColor: greenColor,
                                controller: TextEditingController(
                                    text: employmentDataController
                                        .employment_date.value),
                                enabled: false,
                                decoration: textInputDecoration.copyWith(
                                  labelText: 'Employment Date',
                                  // hintText: userController
                                  //     .registration.value.startDate,

                                  labelStyle: TextStyle(
                                    color: grayColorDeep,
                                  ),
                                ),
                                validator: RequiredValidator(
                                    errorText: 'Required'),

                                // onChanged: (value) {},
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              label: const Text("Designation"),
                            ),
                            cursorColor: greenColor,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter your designation';
                              }

                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onChanged: (value) => employmentDataController
                                .userData.value.designation = value,
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              label: const Text("Job Grade"),
                            ),
                            cursorColor: greenColor,
                            onChanged: (value) => employmentDataController
                                .userData.value.job_grade = value,
                            validator: MultiValidator(
                              [
                                RequiredValidator(
                                  errorText:
                                      'Please enter your Staff Number',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          //employment type
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              label: const Text("Employment Type"),
                            ),
                            cursorColor: greenColor,
                            onChanged: (value) => employmentDataController
                                .userData.value.employment_type = value,
                            validator: MultiValidator(
                              [
                                RequiredValidator(
                                  errorText:
                                      'Please enter employment type',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          //Branch
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              label: const Text("Branch"),
                            ),
                            cursorColor: greenColor,
                            onChanged: (value) => employmentDataController
                                .userData.value.branch = value,
                            validator: MultiValidator(
                              [
                                RequiredValidator(
                                  errorText:
                                      'Please enter your brnach name',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          //hod name
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              label: const Text("Name of HOD"),
                            ),
                            cursorColor: greenColor,
                            onChanged: (value) => employmentDataController
                                .userData.value.hod_name = value,
                            validator: MultiValidator(
                              [
                                RequiredValidator(
                                  errorText:
                                      'Please enter the name of HOD',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          //contact number
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              label: const Text("Contranct Freq Code"),
                            ),
                            cursorColor: greenColor,
                            onChanged: (value) => employmentDataController
                                .userData
                                .value
                                .contract_freq_code = value,
                            validator: MultiValidator(
                              [
                                RequiredValidator(
                                  errorText:
                                      'Please enter the contract freq code',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          //address
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              label: const Text("Contract Duration"),
                            ),
                            cursorColor: greenColor,
                            onChanged: (value) => employmentDataController
                                .userData.value.contract_duration = value,
                            validator: MultiValidator(
                              [
                                RequiredValidator(
                                  errorText:
                                      'Please enter contract duration',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 50,
                          ),

                          Obx(
                            () => MaterialButton(
                              onPressed: employmentDataController
                                      .isLoading.value
                                  ? null
                                  : () async {
                                      if (_emplFormKey.currentState!
                                          .validate()) {
                                        await employmentDataController
                                            .uploadEmploymentData()
                                            .then(
                                          (response) {
                                            return !response.success
                                                ? showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                        context) {
                                                      return AlertDialog(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10),
                                                        ),
                                                        title: Icon(
                                                          Icons.error,
                                                          color: redColor,
                                                          size: 40,
                                                        ),
                                                        content: Text(
                                                          response
                                                              .message,
                                                          textAlign:
                                                              TextAlign
                                                                  .center,
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child:
                                                                const Text(
                                                                    'OK'),
                                                            onPressed:
                                                                () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  )
                                                : Get.offAll(
                                                    () => HomeScreen());
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
                              child:
                                  employmentDataController.isLoading.value
                                      ? CircularProgressIndicator(
                                          color: greenColor,
                                        )
                                      : const Text(
                                          'Submit',
                                          // style: GoogleFonts.notoSans().copyWith(
                                          //   fontWeight: FontWeight.bold,
                                          // ),
                                        ),
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
