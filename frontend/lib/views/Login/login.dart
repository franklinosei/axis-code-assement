import 'package:axis/utilities/responsive_handler.dart';
import 'package:axis/views/Login/widgets/left_side.dart';
import 'package:axis/views/Login/widgets/right_side.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: Responsive.isMobile(context) || Responsive.isTablet(context)
                ? 500
                : 640,
            width: 1080,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26.withOpacity(0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                LoginPageLeftSide(),
                if (MediaQuery.of(context).size.width > 900)
                  LoginPageRightSide(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
