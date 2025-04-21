import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Youth Center"),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/3f.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        alignment: AlignmentDirectional.topStart,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Image.asset("images/logo.jpg", width: 50, height: 50),

                  const SizedBox(height: 20),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      icon: Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.amber,
                      hintText: "username",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      icon: Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.amber,
                      hintText: "password",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 0),
                    child: ElevatedButton(
                      onPressed: () {
                        signIn();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                      ),
                      child: const Text(
                        "submit",
                        style: TextStyle(fontSize: 15, color: Colors.blue),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 70),
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint("clear");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        "clear",
                        style: TextStyle(fontSize: 15, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 50),
                child: Row(
                  children: [
                    const Text(
                      "not have account yet?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(width: 0),
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed('signupScreen');
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
