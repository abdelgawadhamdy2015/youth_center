// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youth_center/auth.dart';
import 'package:youth_center/core/colors.dart';
import '../models/user_model.dart';
import '../models/youth_center_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return SignUp();
  }
}

class SignUp extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var youthCentersNames = ["شنواي"];
  var dropdownValue = "شنواي";
  late CenterUser centerUser;

  FirebaseFirestore db = FirebaseFirestore.instance;

  bool value = false;

  late List<YouthCenterModel> youthCenters;

  late QuerySnapshot<Map<String, dynamic>> snapshot1;
  @override
  void initState() {
    //
    super.initState();
    getAllCenters();
  }

  @override
  void dispose() {
    //
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  Future signUp(CenterUser centerUser) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: usernameController.text.trim(),
          password: passwordController.text.trim(),
        )
        .then(
          (value) => db
              .collection("Users")
              .doc(value.user!.uid)
              .set(centerUser.toJson())
              .whenComplete(() {
                this.centerUser = centerUser;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("user registered successfully "),
                    backgroundColor: Colors.green,
                    elevation: 10, //shadow
                  ),
                );

                FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: usernameController.text.trim(),
                  password: passwordController.text.trim(),
                );
              })
              .whenComplete(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Auth()),
                ),
              )
              .catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error.toString()),
                    backgroundColor: Colors.redAccent,
                    elevation: 10, //shadow
                  ),
                );
              }),
        )
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Colors.redAccent,
              elevation: 10, //shadow
            ),
          );
        });
  }

  getAllCenters() async {
    snapshot1 = await db.collection("youthCenters").get();
    youthCenters =
        snapshot1.docs.map((e) => YouthCenterModel.fromSnapshot(e)).toList();
    for (int i = 0; i < youthCenters.length; i++) {
      if (!youthCentersNames.contains(youthCenters.elementAt(i).name)) {
        youthCentersNames.add(youthCenters.elementAt(i).name);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Youth Center"),
        backgroundColor: MyColors.primaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/3f.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        alignment: AlignmentDirectional.topStart,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage("images/logo.jpg"),
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    inputFormatters: [],
                    controller: usernameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      icon: const Icon(Icons.person, color: Colors.red),
                      filled: true,
                      fillColor: MyColors.primaryColor,
                      hintText: "ُEmail",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    obscureText: false,
                    controller: nameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      icon: const Icon(Icons.nature, color: Colors.red),
                      filled: true,
                      fillColor: MyColors.primaryColor,
                      hintText: "name",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    inputFormatters: [],
                    obscureText: false,
                    controller: mobileController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      icon: const Icon(
                        Icons.phone_in_talk_rounded,
                        color: Colors.red,
                      ),
                      filled: true,
                      fillColor: MyColors.primaryColor,
                      hintText: "mobile",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      icon: const Icon(Icons.lock, color: Colors.red),
                      filled: true,
                      fillColor: MyColors.primaryColor,
                      hintText: "password",
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    // margin: EdgeInsets.only(left: 70,top: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        Visibility(
                          visible: true,
                          child: DropdownButton<String>(
                            style: TextStyle(color: MyColors.primaryColor),

                            // Step 3.
                            value: dropdownValue,
                            icon: Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              color: MyColors.primaryColor,
                            ),
                            // Step 4.
                            items:
                                youthCentersNames.map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(fontSize: 30),
                                      ),
                                    );
                                  },
                                ).toList(),
                            // Step 5.
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                          ),
                        ), //
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 0),
                    child: ElevatedButton(
                      onPressed: () {
                        signUp(
                          CenterUser(
                            name: nameController.text.toString().trim(),
                            email: usernameController.text.toString().trim(),
                            mobile: mobileController.text.toString().trim(),
                            admin: false,
                            youthCenterName: dropdownValue,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primaryColor,
                        //foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(fontSize: 15, color: Colors.blue),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 50),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        const Text(
                          "already have account? ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const SizedBox(width: 0),
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/');
                          },
                          child: const Text(
                            "Sign in",
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
