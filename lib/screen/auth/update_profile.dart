import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/core/widgets/app_text_button.dart';
import 'package:youth_center/core/widgets/body_container.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/core/widgets/header.dart';
import 'package:youth_center/core/widgets/mytextfile.dart';
import 'package:youth_center/fetch_data.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/screen/home/home_screen.dart';

import '../../models/user_model.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<StatefulWidget> createState() {
    return Update();
  }
}

class Update extends State<UpdateProfile> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var dropdownValue = "شنواي";
  late CenterUser centerUser;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late List<String> minuItems;

  FetchData fetchData = FetchData();
  bool adminValue = false;

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    mobileController.dispose();
    nameController.dispose();
  }

  @override
  void initState() {
    super.initState();

    getUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    minuItems = [
      S.of(context).homePage,
      S.of(context).addBooking,
      S.of(context).logOut,
    ];
  }

  Future updateMyProfile(CenterUser centerUser) async {
    await db
        .collection(MyConstants.userCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(centerUser.toJson())
        .whenComplete(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).profileUpdated),
              backgroundColor: ColorManger.greenButtonColor,
              elevation: 10,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return HomeScreen(centerUser: centerUser);
              },
            ),
          );
        });
  }

  getUser() async {
    await FirebaseFirestore.instance
        .collection(MyConstants.userCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            String json = jsonEncode(documentSnapshot.data());
            Map<String, dynamic>? c = jsonDecode(json);
            centerUser = CenterUser.fromJson(c!);
            setState(() {
              usernameController.text = centerUser.email.toString().trim();
              nameController.text = centerUser.name.toString().trim();
              mobileController.text = centerUser.mobile.toString().trim();
              dropdownValue = centerUser.youthCenterName.toString().trim();
              adminValue = centerUser.admin;
            });
          } else {
            print(S.of(context).wrong);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(title: S.of(context).myAccount),
              BodyContainer(
                padding: SizeConfig().getScreenPadding(vertical: .1,horizintal: .08),
                height: SizeConfig.screenHeight! * .85,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(MyConstants.logoPath, height: 80),
                      SizedBox(height: 20),
                      buildInputField(
                        Icons.email,
                        S.of(context).enterUsername,
                        usernameController,
                      ),
                      SizedBox(height: 10),
                      buildInputField(
                        Icons.person,
                        S.of(context).entername,
                        nameController,
                      ),
                      SizedBox(height: 10),
                      buildInputField(
                        Icons.phone,
                        S.of(context).enterMobile,
                        mobileController,
                      ),
                      SizedBox(height: 10),

                      SizedBox(height: 30),

                      AppButtonText(
                        buttonWidth: SizeConfig.screenWidth! * .6,
                        backGroundColor: ColorManger.buttonGreen,
                        textStyle: TextStyles.whiteBoldStyle(
                          SizeConfig.fontSize3!,
                        ),
                        butonText: S.of(context).update,
                        onPressed: () {
                          updateMyProfile(
                            CenterUser(
                              name: nameController.text,
                              mobile: mobileController.text,
                              email: usernameController.text,
                              youthCenterName: dropdownValue,
                              admin: centerUser.admin,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
    IconData icon,
    String hintText,
    TextEditingController controller,
  ) {
    return MyTextForm(
      fillColor: ColorManger.whiteColor,
      icon: Icon(icon, color: Colors.blueGrey),
      hint: hintText,
      controller: controller,
    );

    // return Container(
    //   padding: EdgeInsets.symmetric(horizontal: 16),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.circular(30),
    //     border: Border.all(color: Colors.blueGrey),
    //   ),
    //   child: Row(
    //     children: [
    //       Icon(icon, color: Colors.blueGrey),
    //       SizedBox(width: 10),
    //       Expanded(
    //         child: TextField(
    //           controller: controller,
    //           style: GoogleFonts.tajawal(),
    //           decoration: InputDecoration(
    //             hintText: hintText,
    //             border: InputBorder.none,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
