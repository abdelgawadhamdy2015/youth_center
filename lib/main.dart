import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:youth_center/auth.dart';
import 'package:youth_center/firebase_options.dart';
import 'package:youth_center/models/user_model.dart';
import 'package:youth_center/screen/login_screen.dart';
import 'package:youth_center/screen/sign_up_screen.dart';
import 'package:youth_center/screen/update_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(title: "Youth Center", home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.purple),
        bannerTheme: const MaterialBannerThemeData(),
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const Auth(
        centerUser: CenterUser(
          name: "name",
          mobile: "mobile",
          email: "email",
          youthCenterName: "youthCenterName",
          admin: true,
        ),
      ),
      routes: {
        // '/': (context) =>const Auth(),
        'signupScreen': (context) => const SignUpScreen(),
        "loginScreen": (context) => const LoginScreen(),
        //  "homeScreen": (context) => const HomeScreen(),
        // 'addBooking': (context) => const AddBooking(),
        'updateProfile': (context) => const UpdateProfile(),
      },
    );
  }
}
