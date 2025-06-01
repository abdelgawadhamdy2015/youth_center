import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:youth_center/FetchData.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/screen/auth/login_screen.dart';
import 'package:youth_center/screen/home/home_controller.dart';
import 'package:youth_center/screen/home/home_screen.dart';

import '../models/user_model.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return Welcome();
  }
}

class Welcome extends ConsumerState<WelcomeScreen> with SingleTickerProviderStateMixin {
  FirebaseFirestore db = FirebaseFirestore.instance;

  FetchData fetchDate = FetchData();

  List<String> youthCentersNames = [];
  late CenterUser centerUser;
  bool userDone = false;

  var isLiked = false;

  @override
  void initState() {
    super.initState();
  }

  getUser() async {
    if (FirebaseAuth.instance.currentUser == null) {
      // User is not logged in, redirect to login screen
      Future.delayed(Duration(seconds: 1), () {
       Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
      return;
    }
    await FirebaseFirestore.instance
        .collection(MyConstants.userCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            String json = jsonEncode(documentSnapshot.data());
            Map<String, dynamic>? c = jsonDecode(json);
            centerUser = CenterUser.fromJson(c!);

            MyConstants.centerUser = centerUser;
            ref.read(centerUserProvider) ;
            userDone = true;
           
          }
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getWidget());
  }

  Widget getWidget() {
   final userAsync = ref.watch(centerUserProvider);
   return userAsync.when(
      data: (user) {
        if (user == null) {
          return LoginScreen();
        }
        MyConstants.centerUser = user;
        return HomeScreen();
      },
      loading: () => Center(
        child: _buildWelcomeScreen(),
      ),
      error: (error, stackTrace) => Center(
        child: Text("حدث خطأ: $error"),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(MyConstants.logoSvg),
          HelperMethods.verticalSpace(.02),
          Text(
            "YOUTH CENTER",
            style: TextStyles.darkBlueBoldStyle(SizeConfig.fontSize3!),
          ),
        ],
      ),
    );
  }
}
