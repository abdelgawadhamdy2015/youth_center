import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/core/widgets/app_text_button.dart';
import 'package:youth_center/core/widgets/day_drop_down.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/user_model.dart';
import 'package:youth_center/screen/auth/auth.dart';
import 'package:youth_center/screen/auth/signub_controller.dart';
import 'package:youth_center/screen/home/home_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUp();
}

class _SignUp extends ConsumerState<SignUpScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final mobileController = TextEditingController();
  final nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    mobileController.dispose();
    nameController.dispose();

    super.dispose();
  }

  void handleSignUp() {
    final controller = ref.read(signUpControllerProvider.notifier);
    final user = CenterUser(
      name: nameController.text.trim(),
      email: usernameController.text.trim(),
      password: passwordController.text.trim(),
      mobile: mobileController.text.trim(),
      youthCenterName: ref.read(selectedCenterNameProvider)!,
      admin: false,
    );
    controller.signUp(user);
  }

  @override
  Widget build(BuildContext context) {
    final signUpState = ref.watch(signUpControllerProvider);
    final youthCentersNames = ref.watch(youthCenterNamesProvider);
    final selectedyouthCenterName = ref.watch(selectedCenterNameProvider);

    final lang = S.of(context);
    ref.listen(signUpControllerProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(lang.userRegistered),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => Auth()),
          );
        },
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

    return Scaffold(
      body: GradientContainer(
        child: Center(
          child: SingleChildScrollView(
            padding: SizeConfig().getScreenPadding(
              horizintal: .1,
              vertical: .2,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  HelperMethods.buildTextField(
                    inputType: TextInputType.emailAddress,
                    Icons.email,
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
                  HelperMethods.buildTextField(
                    Icons.person,
                    lang.name,
                    nameController,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? S.of(context).entername
                                : null,
                  ),
                  HelperMethods.verticalSpace(.02),
                  HelperMethods.buildTextField(
                    inputType: TextInputType.phone,
                    Icons.phone,
                    lang.mobile,
                    mobileController,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? S.of(context).enterMobile
                                : null,
                  ),
                  HelperMethods.verticalSpace(.02),
                  HelperMethods.buildTextField(
                    Icons.lock,
                    lang.password,
                    passwordController,
                    obsecur: true,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? S.of(context).enterPassword
                                : null,
                  ),
                  HelperMethods.verticalSpace(.02),
                  youthCentersNames.when(
                    data: (centers) {
                      return DayDropdown(
                        validator:
                            (value) =>
                                value == null
                                    ? S.of(context).selectCenter
                                    : null,
                        lableText: S.of(context).selectCenter,
                        days: centers,
                        selectedDay: selectedyouthCenterName,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              ref
                                  .read(selectedCenterNameProvider.notifier)
                                  .state = value;
                            });
                          }
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return Center(child: Text(error.toString()));
                    },
                    loading: () {
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  HelperMethods.verticalSpace(.02),
                  AppButtonText(
                    onPressed:
                        signUpState is AsyncLoading
                            ? () {}
                            : () => handleSignUp(),
                    textStyle: TextStyles.whiteBoldStyle(SizeConfig.fontSize3!),
                    butonText: lang.signup,
                  ),
                  Row(
                    children: [
                      Text(
                        lang.alreadyHaveAccount,
                        style: TextStyles.whiteRegulerStyle(
                          SizeConfig.fontSize3!,
                        ),
                      ),
                      TextButton(
                        onPressed:
                            () =>
                                Navigator.of(context).pushReplacementNamed('/'),
                        child: Text(
                          lang.signIn,
                          style: TextStyles.darkBlueBoldStyle(
                            SizeConfig.fontSize3!,
                          ),
                        ),
                      ),
                    ],
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
