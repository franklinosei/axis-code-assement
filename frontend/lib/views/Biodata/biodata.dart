import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:axis/controller/BiodataController/biodata_controller.dart';
import 'package:axis/views/EmployeeData/employee_data.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../constants/constants.dart';
import '../../utilities/responsive_handler.dart';
import '../Login/widgets/right_side.dart';

class BioDataScreen extends StatelessWidget {
  BioDataScreen({Key? key}) : super(key: key);

  final BioDataController bioDataController = Get.find();
  final _bioLoginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Row(
        children: [
          !Responsive.isMobile(context) && !Responsive.isTablet(context)
              ? LoginPageRightSide(
                  img_url: 'assets/images/forms1.jpg',
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
                      "Continue by filling your biodata",
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Obx(
                      () => Center(
                        child: Container(
                          height: 300,
                          width: 300,
                          // padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: grayColorDeep.withOpacity(0.3),
                            // borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 2,
                              color: bioDataController
                                      .passport_photo.value.isNotEmpty
                                  ? greenColor
                                  : redColor,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              bioDataController
                                      .passport_photo.value.isNotEmpty
                                  ? Image.network(
                                      bioDataController
                                          .passport_photo.value,
                                      fit: BoxFit.cover,
                                      height: 230,
                                      width:
                                          MediaQuery.of(context).size.width,
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 150,
                                    ),
                              TextButton(
                                onPressed: () async {
                                  // XFile? res = await getDocumentImage(context);
                                  final ImagePicker _picker = ImagePicker();
      
                                  XFile? image = await _picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 100);
      
                                  var f = await image!.readAsBytes();
                                  bioDataController.webImage?.value = f;
      
                                  bioDataController
                                          .userData.value.passport_photo =
                                      dio.MultipartFile.fromBytes(f,
                                          filename: 'prof_photo.png');
                                  // setState(() {
                                  //   webImage = f;
                                  // });
      
                                  bioDataController.passport_photo.value =
                                      image.path;
                                },
                                style: TextButton.styleFrom(
                                  primary: greenColor,
                                  padding: EdgeInsets.zero,
                                ),
                                child:
                                    const Text('Upload Passport Picture'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: _bioLoginFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              label: const Text("Employee ID"),
                            ),
                            cursorColor: greenColor,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter your Employee ID';
                              }
      
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onChanged: (value) => bioDataController
                                .userData.value.employee_id = value,
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              label: const Text("Staff Number"),
                            ),
                            cursorColor: greenColor,
                            onChanged: (value) => bioDataController
                                .userData.value.staff_no = value,
                            validator: MultiValidator(
                              [
                                RequiredValidator(
                                  errorText:
                                      'Please enter your Staff Number',
                                ),
                                MinLengthValidator(5,
                                    errorText:
                                        'Staff number must be atleast 5 characters long'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1970),
                                lastDate: DateTime(2100),
                              ).then((date) {
                                if (date != null) {
                                  bioDataController.userData.value
                                      .appointment_date = date.toString();
      
                                  bioDataController.appointment_date.value =
                                      DateFormat.yMEd().format(date);
                                }
                              });
                            },
                            child: Obx(
                              () => TextFormField(
                                controller: TextEditingController(
                                    text: bioDataController
                                        .appointment_date.value),
                                // readOnly: true,
                                cursorColor: greenColor,
                                enabled: false,
                                decoration: textInputDecoration.copyWith(
                                  labelText: "Appointment Date",
                                  // hintText: userController
                                  //     .registration.value.startDate,
                                  labelStyle: TextStyle(
                                    color: grayColorDeep,
                                  ),
                                ),
                                // validator:
                                //     RequiredValidator(errorText: 'Required'),
      
                                // onChanged: (value) {},
                              ),
                            ),
                          ),
      
                          const SizedBox(
                            height: 20,
                          ),
      
                          //ssnit
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              label: const Text("SSNIT Number"),
                            ),
                            cursorColor: greenColor,
                            onChanged: (value) => bioDataController
                                .userData.value.ssnit_no = value,
                            validator: MultiValidator(
                              [
                                RequiredValidator(
                                  errorText:
                                      'Please enter your ssnit Number',
                                ),
                                MinLengthValidator(10,
                                    errorText:
                                        'ssnit number must be atleast 5 characters long'),
                              ],
                            ),
                          ),
      
                          const SizedBox(
                            height: 20,
                          ),
      
                          //dob
                          GestureDetector(
                            onTap: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              ).then((date) {
                                if (date != null) {
                                  bioDataController.userData.value.dob =
                                      date.toString();
      
                                  bioDataController.dob.value =
                                      DateFormat.yMEd().format(date);
                                }
                              });
                            },
                            child: Obx(
                              () => TextFormField(
                                // readOnly: true,
                                controller: TextEditingController(
                                    text: bioDataController.dob.value),
                                cursorColor: greenColor,
                                enabled: false,
                                decoration: textInputDecoration.copyWith(
                                  labelText: "Date of Birth",
                                  // hintText: userController
                                  //     .registration.value.startDate,
                                  labelStyle: TextStyle(
                                    color: grayColorDeep,
                                  ),
                                ),
                                // validator:
                                //     RequiredValidator(errorText: 'Required'),
      
                                // onChanged: (value) {},
                              ),
                            ),
                          ),
      
                          const SizedBox(
                            height: 20,
                          ),
      
                          //title
                          TextDropdownFormField(
                              options: const ['Mr', 'Mrs', 'Miss', 'Dr'],
                              decoration: textInputDecoration.copyWith(
                                labelText: 'Title',
                                suffixIcon:
                                    const Icon(Icons.arrow_drop_down),
                              ),
                              dropdownHeight: 120,
                              validator:
                                  RequiredValidator(errorText: 'Required'),
                              onChanged: (dynamic item) {
                                bioDataController.userData.value.title =
                                    item;
                              }),
      
                          const SizedBox(
                            height: 20,
                          ),
      
                          //surname
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              label: const Text("Surname"),
                            ),
                            cursorColor: greenColor,
                            onChanged: (value) => bioDataController
                                .userData.value.surname = value,
                            validator: MultiValidator(
                              [
                                RequiredValidator(
                                  errorText: 'Please enter your surname',
                                ),
                              ],
                            ),
                          ),
      
                          const SizedBox(
                            height: 20,
                          ),
      
                          //other names
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              label: const Text("Other Names"),
                            ),
                            cursorColor: greenColor,
                            onChanged: (value) => bioDataController
                                .userData.value.other_name = value,
                            validator: MultiValidator(
                              [
                                RequiredValidator(
                                  errorText: 'Please enter your name',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // //Gender
      
                          TextDropdownFormField(
                            options: const ['Male', 'Female'],
                            decoration: textInputDecoration.copyWith(
                              labelText: 'Gender',
                              suffixIcon: const Icon(Icons.arrow_drop_down),
                            ),
                            dropdownHeight: 120,
                            validator:
                                RequiredValidator(errorText: 'Required'),
                            onChanged: (dynamic item) {
                              bioDataController.userData.value.gender_code =
                                  item;
                            },
                          ),
      
                          const SizedBox(
                            height: 20,
                          ),
      
                          TextDropdownFormField(
                              options: const ['Single', 'Married'],
                              decoration: textInputDecoration.copyWith(
                                labelText: 'Marital Status',
                                suffixIcon:
                                    const Icon(Icons.arrow_drop_down),
                              ),
                              dropdownHeight: 120,
                              validator:
                                  RequiredValidator(errorText: 'Required'),
                              onChanged: (dynamic item) {
                                bioDataController
                                    .userData.value.marital_status = item;
                              }),
      
                          const SizedBox(
                            height: 20,
                          ),
      
                          //phone number
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              label: const Text("Phone Number"),
                            ),
                            cursorColor: greenColor,
                            onChanged: (value) => bioDataController
                                .userData.value.cellphone = value,
                            validator: MultiValidator(
                              [
                                RequiredValidator(
                                  errorText:
                                      'Please enter your phone Number',
                                ),
                                MinLengthValidator(10,
                                    errorText:
                                        'phone number must be atleast 10 characters long'),
                              ],
                            ),
                          ),
      
                          const SizedBox(
                            height: 20,
                          ),
      
                          //address
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              label: const Text("Address"),
                            ),
                            cursorColor: greenColor,
                            onChanged: (value) => bioDataController
                                .userData.value.address = value,
                            validator: MultiValidator(
                              [
                                RequiredValidator(
                                  errorText: 'Please enter your Address',
                                ),
                              ],
                            ),
                          ),
      
                          const SizedBox(
                            height: 50,
                          ),
      
                          Obx(
                            () => MaterialButton(
                              onPressed: bioDataController.isLoading.value
                                  ? null
                                  : () async {
                                      if (_bioLoginFormKey.currentState!
                                          .validate()) {
                                        await bioDataController
                                            .uploadBioData()
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
                                                          response.message,
                                                          textAlign:
                                                              TextAlign
                                                                  .center,
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child:
                                                                const Text(
                                                                    'Ok'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  )
                                                : Get.offAll(() =>
                                                    EmployeeDataScreen());
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
                              child: bioDataController.isLoading.value
                                  ? CircularProgressIndicator(
                                      color: greenColor,
                                    )
                                  : Text(
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
