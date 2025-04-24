import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youth_center/fetch_data.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/shared_pref_helper.dart';
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
      return const Center(child: Image(image: AssetImage("images/logo.jpg")));
    }

    return HomeScreen(centerUser: centerUser);
  }
}
