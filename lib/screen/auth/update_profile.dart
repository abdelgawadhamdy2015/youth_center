import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/core/widgets/app_text_button.dart';
import 'package:youth_center/core/widgets/body_container.dart';
import 'package:youth_center/core/widgets/day_drop_down.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/core/widgets/mytextfile.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/screen/home/logic/home_controller.dart';
import 'package:youth_center/screen/home/ui/home_screen.dart';

import '../../models/user_model.dart';

class UpdateProfile extends ConsumerStatefulWidget {
  const UpdateProfile({super.key});

  @override
  ConsumerState<UpdateProfile> createState() {
    return Update();
  }
}

class Update extends ConsumerState<UpdateProfile> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var dropdownValue = "شنواي";

  FirebaseFirestore db = FirebaseFirestore.instance;

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
  }

  setData() async {
    setState(() {
      usernameController.text =
          MyConstants.centerUser?.email.toString().trim() ?? '';
      nameController.text =
          MyConstants.centerUser?.name.toString().trim() ?? '';
      mobileController.text =
          MyConstants.centerUser?.mobile.toString().trim() ?? '';
      dropdownValue =
          MyConstants.centerUser?.youthCenterName.toString().trim() ?? '';
      adminValue = MyConstants.centerUser?.admin ?? false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setData();
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
                return HomeScreen();
              },
            ),
          );
        });
  }

  // getUser() async {
  //   await FirebaseFirestore.instance
  //       .collection(MyConstants.userCollection)
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //         if (documentSnapshot.exists) {
  //           String json = jsonEncode(documentSnapshot.data());
  //           Map<String, dynamic>? c = jsonDecode(json);
  //           centerUser = CenterUser.fromJson(c!);
  //           setState(() {
  //             usernameController.text = centerUser.email.toString().trim();
  //             nameController.text = centerUser.name.toString().trim();
  //             mobileController.text = centerUser.mobile.toString().trim();
  //             dropdownValue = centerUser.youthCenterName.toString().trim();
  //             adminValue = centerUser.admin;
  //           });
  //         } else {
  //           print(S.of(context).wrong);
  //         }
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    adminValue = ref.watch(isAdminProvider);
    return GradientContainer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            HelperMethods.buildHeader(
              context,
              S.of(context).myAccount,
              adminValue,
            ),
            BodyContainer(
              padding: SizeConfig().getScreenPadding(
                vertical: .1,
                horizintal: .08,
              ),
              height: SizeConfig.screenHeight! * .85,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(MyConstants.logoPath),
                    HelperMethods.verticalSpace(.02),
                    buildInputField(
                      Icons.email,
                      S.of(context).enterUsername,
                      usernameController,
                    ),
                    HelperMethods.verticalSpace(.02),
                    buildInputField(
                      Icons.person,
                      S.of(context).entername,
                      nameController,
                    ),
                    HelperMethods.verticalSpace(.02),
                    buildInputField(
                      Icons.phone,
                      S.of(context).enterMobile,
                      mobileController,
                    ),
                    HelperMethods.verticalSpace(.02),

                    DayDropdown(
                      days: MyConstants.centerNames,
                      selectedDay: dropdownValue,
                      onChanged:
                          MyConstants.centerUser?.admin ?? false
                              ? null
                              : (value) {
                                if (value != null) {
                                  setState(() {
                                    dropdownValue = value;
                                  });
                                }
                              },
                    ),
                    HelperMethods.verticalSpace(.04),

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
                            id: FirebaseAuth.instance.currentUser!.uid,
                            name: nameController.text,
                            mobile: mobileController.text,
                            email: usernameController.text,
                            youthCenterName: dropdownValue,
                            admin: MyConstants.centerUser?.admin ?? false,
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
