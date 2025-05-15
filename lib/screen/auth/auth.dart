import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/screen/auth/login_screen.dart';
import 'package:youth_center/screen/welcome_screen.dart';

class Auth extends StatelessWidget {
  const Auth({super.key,  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return  WelcomeScreen();
          } else {
            return const LoginScreen();
          }
        }),
      ),
    );
  }
}
