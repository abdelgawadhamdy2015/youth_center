import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:youth_center/screen/auth/login_controller.dart';
import 'package:youth_center/screen/auth/sign_up_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _Login();
}

class _Login extends ConsumerState<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool canPop = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final loginController = ref.read(loginControllerProvider.notifier);
    loginController.signIn(usernameController.text, passwordController.text);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    HelperMethods.invalidateAllProviders(context, ref);
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);
    var lang = S.of(context);

    ref.listen<AsyncValue<void>>(loginControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (canPop) {
          canPop = false;
          SystemNavigator.pop();
        } else {
          canPop = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).clickAgainToExit)),
          );
          Future.delayed(Duration(seconds: 2), () {
            canPop = false;
          });
        }
      },
      canPop: canPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: GradientContainer(
          child: Center(
            child: SingleChildScrollView(
              padding: SizeConfig().getScreenPadding(horizintal: .05),
              child: Column(
                children: [
                  SvgPicture.asset(
                    MyConstants.logoSvg,
                    width: 100,
                    height: 100,
                  ),
                  HelperMethods.verticalSpace(.02),
                  Text(
                    "YOUTH CENTER",
                    style: TextStyles.darkBlueBoldStyle(SizeConfig.fontSize5!),
                  ),
                  HelperMethods.verticalSpace(.02),

                  HelperMethods.buildTextField(
                    inputType: TextInputType.emailAddress,
                    Icons.person,
                    lang.username,
                    usernameController,
                    validator: (value) {
                      value?.isEmpty ?? true
                          ? S.of(context).enterUsername
                          : null;

                      if (!MyConstants.emailCharRegExp.hasMatch(value)) {
                        return lang.enterValidEmail;
                      }
                      return null;
                    },
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
                    onPressed:
                        loginState is AsyncLoading ? () {} : _handleLogin,
                  ),

                  HelperMethods.verticalSpace(.02),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
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
      ),
    );
  }
}
