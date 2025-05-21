// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/core/widgets/day_drop_down.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/screen/auth/auth.dart';
import 'package:youth_center/core/themes/colors.dart';
import '../../models/user_model.dart';
import '../../models/youth_center_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return SignUp();
  }
}

class SignUp extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var youthCentersNames = ["شنواي"];
  var dropdownValue = "شنواي";
  late CenterUser centerUser;

  FirebaseFirestore db = FirebaseFirestore.instance;

  bool value = false;

  late List<YouthCenterModel> youthCenters;

  late QuerySnapshot<Map<String, dynamic>> snapshot1;
  @override
  void initState() {
    //
    super.initState();
    getAllCenters();
  }

  @override
  void dispose() {
    //
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  Future signUp(CenterUser centerUser) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: usernameController.text.trim(),
          password: passwordController.text.trim(),
        )
        .then(
          (value) => db
              .collection(MyConstants.userCollection)
              .doc(value.user!.uid)
              .set(centerUser.toJson())
              .whenComplete(() {
                this.centerUser = centerUser;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).userRegistered),
                    backgroundColor: Colors.green,
                    elevation: 10, //shadow
                  ),
                );

                FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: usernameController.text.trim(),
                  password: passwordController.text.trim(),
                );
              })
              .whenComplete(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Auth()),
                ),
              )
              .catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error.toString()),
                    backgroundColor: Colors.redAccent,
                    elevation: 10, //shadow
                  ),
                );
              }),
        )
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Colors.redAccent,
              elevation: 10, //shadow
            ),
          );
        });
  }

  getAllCenters() async {
    snapshot1 = await db.collection(MyConstants.youthCentersCollection).get();
    youthCenters =
        snapshot1.docs.map((e) => YouthCenterModel.fromSnapshot(e)).toList();
    for (int i = 0; i < youthCenters.length; i++) {
      if (!youthCentersNames.contains(youthCenters.elementAt(i).name)) {
        youthCentersNames.add(youthCenters.elementAt(i).name);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: GradientContainer(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: SizeConfig().getScreenPadding(vertical: .2,horizintal: .1),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment:CrossAxisAlignment.center ,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  HelperMethods.buildTextField(
                                    Icons.email,
                                    S.of(context).username,
                                    usernameController,
                                    validator:
                                        (value) =>
                                            value?.isEmpty ?? true
                                                ? S.of(context).enterUsername
                                                : null,
                                  ),
                      
                                  HelperMethods.verticalSpace(.02),
                                  HelperMethods.buildTextField(
                                    Icons.person,
                                    S.of(context).name,
                                    nameController,
                                    validator:
                                        (value) =>
                                            value?.isEmpty ?? true
                                                ? S.of(context).entername
                                                : null,
                                  ),
                      
                                  HelperMethods.verticalSpace(.02),
                      
                                  HelperMethods.buildTextField(
                                    Icons.phone_in_talk_rounded,
                                    S.of(context).name,
                                    mobileController,
                                    validator:
                                        (value) =>
                                            value?.isEmpty ?? true
                                                ? S.of(context).enterMobile
                                                : null,
                                  ),
                                  HelperMethods.verticalSpace(.02),
                                
                      
                                  HelperMethods.buildTextField(
                                    Icons.lock,
                                    S.of(context).password,
                                    passwordController,
                                    validator:
                                        (value) =>
                                            value?.isEmpty ?? true
                                                ? S.of(context).enterPassword
                                                : null,
                                    obsecur: true,
                                  ),
                                  HelperMethods.verticalSpace(.02),
                                  DayDropdown(days:youthCentersNames , selectedDay: dropdownValue, onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    },)
                                 
                                ],
                              ),
                                  HelperMethods.verticalSpace(.02),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        signUp(
                                          CenterUser(
                                            name: nameController.text.toString().trim(),
                                            email: usernameController.text.toString().trim(),
                                            mobile: mobileController.text.toString().trim(),
                                            admin: false,
                                            youthCenterName: dropdownValue,
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorManger.mainBlue,
                                        //foregroundColor: Colors.black,
                                      ),
                                      child: Text(
                                        S.of(context).register,
                                        style: TextStyle(fontSize: 15, color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Text(
                                          S.of(context).alreadyHaveAccount,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 19,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                  HelperMethods.verticalSpace(.02),
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.of(context).pushReplacementNamed('/');
                                          },
                                          child: Text(
                                            S.of(context).signIn,
                                            style: TextStyles.darkBlueBoldStyle(SizeConfig.fontSize3!),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
