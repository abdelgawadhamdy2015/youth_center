import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/service/local_notification_service.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/core/widgets/app_text_button.dart';
import 'package:youth_center/core/widgets/body_container.dart';
import 'package:youth_center/core/widgets/day_drop_down.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/core/widgets/mytextfile.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/screen/auth/login_controller.dart';
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

  updateMyProfile(CenterUser centerUser) {
    final loginController = ref.read(loginControllerProvider.notifier);
    loginController
        .updateProfile(centerUser)
        .whenComplete(() {
          LocalNotificationService localNotificationService =
              LocalNotificationService();
          localNotificationService.initNotification();
          localNotificationService.showNotification(
            RemoteMessage(
              notification: RemoteNotification(
                body: "this is test",
                title: "me",
              ),
            ),
          );
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
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: ColorManger.redButtonColor,
              elevation: 10,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    adminValue = ref.watch(isAdminProvider);
    final youthCenterNames = ref.watch(youthCenterNamesProvider);
    final selectedYouthCenter = ref.watch(selectedCenterNameProvider);
    return GradientContainer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            HelperMethods.buildHeader(
              context: context,
              title: S.of(context).myAccount,
              isAdmin: adminValue,
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
                    youthCenterNames.when(
                      data: (names) {
                        return DayDropdown(
                          days: names,
                          selectedDay: selectedYouthCenter,
                          onChanged:
                              MyConstants.centerUser?.admin ?? false
                                  ? null
                                  : (value) {
                                    if (value != null) {
                                      ref
                                          .read(
                                            selectedCenterNameProvider.notifier,
                                          )
                                          .state = value;
                                    }
                                  },
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Text('Error: $error'),
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
                            youthCenterName:
                                selectedYouthCenter ??
                                MyConstants.centerUser!.youthCenterName,
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
  }
}
