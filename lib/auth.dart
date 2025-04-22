import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youth_center/models/user_model.dart';
import 'package:youth_center/screen/login_screen.dart';
import 'package:youth_center/screen/welcome_screen.dart';

class Auth extends StatelessWidget {
  const Auth({super.key,  });

  @override
  Widget build(BuildContext context) {
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
