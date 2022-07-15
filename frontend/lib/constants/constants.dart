import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String BASE_URL = 'http://127.0.0.1:8000/employee';

Color greenColor = const Color(0xFF8bbf2c);
Color greyColor = Colors.grey.shade300;
Color grayColorDeep = Colors.grey.shade600;
Color redColor = Colors.red;

InputDecoration textInputDecoration = InputDecoration(
  hintStyle: GoogleFonts.notoSans(
    textStyle: TextStyle(
      color: greenColor,
      fontSize: 20,
    ),
  ),
  contentPadding: const EdgeInsets.all(20),
  labelStyle: GoogleFonts.notoSans(
    textStyle: TextStyle(
      color: grayColorDeep,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: greenColor,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: greenColor),
    borderRadius: BorderRadius.circular(10),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: greenColor,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: redColor,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: greenColor,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
);
