import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';
import 'package:youth_center/FetchData.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/shared_pref_helper.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/screen/home/home_screen.dart';

import '../models/user_model.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return Welcome();
  }
}

class Welcome extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  FirebaseFirestore db = FirebaseFirestore.instance;

  FetchData fetchDate = FetchData();

  List<String> youthCentersNames = [];
  late CenterUser centerUser;
  bool userDone = false;

  var isLiked = false;

  @override
  void initState() {
    super.initState();

    getUser();
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
            userDone = true;
            SharedPrefHelper.setData(
              MyConstants.prefCenterUser,
              centerUser.toJson(),
            );
            MyConstants.centerUser = centerUser;
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getWidget());
  }

  Widget getWidget() {
    if (!userDone) {
      Future.delayed(Duration(seconds: 3), () {
        setState(() {});
      });
      return  Center(child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(MyConstants.logoSvg),
          HelperMethods.verticalSpace(.02),
          Text("YOUTH CENTER", style: TextStyles.darkBlueBoldStyle(SizeConfig.fontSize3!),)
        ],
      ));
    }

    return HomeScreen();
  }
}
