import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretest_mdi_pai/data/list_user.dart';
import 'package:pretest_mdi_pai/data/user.dart';
import 'package:pretest_mdi_pai/data/user_list.dart';

import '../widget/appbar_widget.dart';
import '../widget/card_data_widget.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.userData});

  final UserList userData;

  @override
  Widget build(BuildContext context) {
    return detailProfileWidget();
  }

  Scaffold detailProfileWidget() {
    return Scaffold(
    appBar: buildAppBar(),
    body: SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4,
                    color: Colors.black,
                  ),
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Colors.cyan,
                    child: Image.network(userData.image),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "${userData.firstName} ${userData.lastName}",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userData.email,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              CardDataUserWidget(
                tittle: "College",
                data: userData.university!,
              ),
              CardDataUserWidget(
                tittle: "Username",
                data: userData.username,
              ),
              CardDataUserWidget(
                tittle: "Gender",
                data: userData.gender,
              ),
              CardDataUserWidget(
                tittle: "Phone",
                data: userData.phone!,
              ),
              CardDataUserWidget(
                tittle: "Birthdate",
                data: userData.birthDate!,
              ),
              CardDataUserWidget(
                tittle: "Blood Group",
                data: userData.bloodGroup!,
              ),
              CardDataUserWidget(
                tittle: "Weight",
                data: userData.weight.toString(),
              ),
              CardDataUserWidget(
                tittle: "Height",
                data: userData.height.toString(),
              ),
              CardDataUserWidget(
                tittle: "Hair",
                data: userData.hair.toString(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }
}
