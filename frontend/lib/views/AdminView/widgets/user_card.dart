import 'package:axis/model/FullUserDataModel/full_user_data_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class EmployeeDataCard extends StatelessWidget {
  final FullUserDataModel userData;
  const EmployeeDataCard({required this.userData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    return Container(
      margin: const EdgeInsets.only(
        right: 10,
      ),
      child: SizedBox(
        height: 250,
        width: 250,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                      color: Colors.grey.shade100,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: userData.passport_photo != null
                          ? '${BASE_URL}/static/media/${userData.passport_photo}'
                          : 'https://unsplash.com/photos/TMt3JGoVlng/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjU3ODA5NzQ4&force=true&w=640',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Email: ${userData.email}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Name: ${userData.surname ?? "N/A"} ${userData.other_name ?? ""}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Designation: ${userData.designation ?? "N/A"}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
