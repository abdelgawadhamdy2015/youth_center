import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/core/widgets/app_text_button.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/core/widgets/passwordtext.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/screen/auth/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => Login();
}

class Login extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  Future signIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: usernameController.text.trim(),
          password: passwordController.text.trim(),
        )
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Colors.redAccent,
              elevation: 10, //shadow
            ),
          );
          throw error; // Rethrow the error to maintain the expected type
        });
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: GradientContainer(
        child: Center(
          child: SingleChildScrollView(
            padding: SizeConfig().getScreenPadding(horizintal: .05),
            child: Column(
              children: [
                SvgPicture.asset(MyConstants.logoSvg, width: 100, height: 100),
                HelperMethods.verticalSpace(.02),

                Text(
                  "YOUTH CENTER",
                  style: TextStyles.darkBlueBoldStyle(SizeConfig.fontSize5!),
                ),
                HelperMethods.verticalSpace(.02),
                HelperMethods.buildTextField(
                  Icons.person,

                  lang.username,
                  usernameController,
                  validator:
                      (value) =>
                          value?.isEmpty ?? true
                              ? S.of(context).enterUsername
                              : null,
                ),
                HelperMethods.verticalSpace(.02),

                PasswordText(
                  fillColor: ColorManger.whiteColor,
                  hint: lang.password,
                  obsecur: true,
                  control: passwordController,
                ),
                HelperMethods.verticalSpace(.02),

                AppButtonText(
                  backGroundColor: ColorManger.darkBlue,
                  borderRadius: SizeConfig.screenWidth! * .05,
                  textStyle: GoogleFonts.tajawal(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  butonText: lang.login,
                  onPressed: signIn,
                ),

                HelperMethods.verticalSpace(.02),

                TextButton(
                  onPressed:
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SignUpScreen();
                          },
                        ),
                      ),
                  child: Text(
                    lang.DonotHaveAccount,
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // signup() async {
  // Navigator.of(context).pushReplacementNamed('signupScreen');
  //   // Future.delayed(Duration.zero, () {
  //   //   Navigator.of(context).pushReplacementNamed('signupScreen');
  //   // });
  // }
}
