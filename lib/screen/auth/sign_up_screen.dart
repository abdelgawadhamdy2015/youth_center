import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/core/widgets/day_drop_down.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/user_model.dart';
import 'package:youth_center/models/youth_center_model.dart';
import 'package:youth_center/screen/auth/auth.dart';
import 'package:youth_center/screen/auth/signub_controller.dart';

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
    bool isLoadingCenters = true;
  List<String> youthCentersNames = ["شنواي"];
  String? dropdownValue ;

  late List<YouthCenterModel> youthCenters;

  @override
  void initState() {
    super.initState();
    getAllCenters();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    mobileController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> getAllCenters() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection(MyConstants.youthCentersCollection)
        .get();

    youthCenters = snapshot.docs
        .map((doc) => YouthCenterModel.fromSnapshot(doc))
        .toList();

    youthCentersNames = youthCenters.map((e) => e.name).toSet().toList();

    // Set initial dropdown value
    if (youthCentersNames.isNotEmpty) {
      dropdownValue ??= youthCentersNames.first;
    }

    setState(() {
      isLoadingCenters = false;
    });
  } catch (e) {
    print('Error loading youth centers: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Failed to load youth centers'),
      backgroundColor: Colors.red,
    ));
  }
}


  void handleSignUp() {
    final controller = ref.read(signUpControllerProvider.notifier);
    final user = CenterUser(
      name: nameController.text.trim(),
      email: usernameController.text.trim(),
      password: passwordController.text.trim(), // ensure this field exists
      mobile: mobileController.text.trim(),
      youthCenterName: dropdownValue?? youthCentersNames.first,
      admin: false,
    );
    controller.signUp(user);
  }

  @override
  Widget build(BuildContext context) {
    final signUpState = ref.watch(signUpControllerProvider);
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
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Auth()));
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString()), backgroundColor: Colors.red),
          );
        },
      );
    });

    return Scaffold(
      body: GradientContainer(
        child: Center(
          child: SingleChildScrollView(
            padding: SizeConfig().getScreenPadding(horizintal: .1, vertical: .2),
            child: Column(
              children: [
                HelperMethods.buildTextField(Icons.email, lang.username, usernameController),
                HelperMethods.verticalSpace(.02),
                HelperMethods.buildTextField(Icons.person, lang.name, nameController),
                HelperMethods.verticalSpace(.02),
                HelperMethods.buildTextField(Icons.phone, lang.mobile, mobileController),
                HelperMethods.verticalSpace(.02),
                HelperMethods.buildTextField(Icons.lock, lang.password, passwordController, obsecur: true),
                HelperMethods.verticalSpace(.02),
                DayDropdown(
                  days: youthCentersNames,
                  selectedDay: dropdownValue,
                  onChanged: (newVal) => setState(() => dropdownValue = newVal!),
                ),
                HelperMethods.verticalSpace(.02),
                ElevatedButton(
                  onPressed: signUpState is AsyncLoading ? null : handleSignUp,
                  style: ElevatedButton.styleFrom(backgroundColor: ColorManger.mainBlue),
                  child: Text(lang.register, style: TextStyle(fontSize: 15, color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
                  child: Text(lang.signIn, style: TextStyles.darkBlueBoldStyle(SizeConfig.fontSize3!)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
