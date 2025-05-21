
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/widgets/app_text_button.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/core/widgets/passwordtext.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/screen/auth/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      body: GradientContainer(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image.asset(
            //   MyConstants.backgroundImagePath,
            //   fit: BoxFit.cover,
            // ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(MyConstants.logoPath, width: 100, height: 100),
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
                          () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                            return SignUpScreen();
                          })),
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
          ],
        ),
      ),
    );
  }

  
}
