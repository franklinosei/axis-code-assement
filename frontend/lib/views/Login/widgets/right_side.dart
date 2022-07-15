import 'package:flutter/material.dart';

class LoginPageRightSide extends StatelessWidget {
  String? img_url = 'assets/images/worker.jpg';
  LoginPageRightSide({this.img_url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        color: Colors.orange,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(img_url ?? 'assets/images/worker.jpg'),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
