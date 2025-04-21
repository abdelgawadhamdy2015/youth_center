import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youth_center/FetchData.dart';

import '../models/user_model.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<StatefulWidget> createState() {
    return Update();
  }
}

class Update extends State<UpdateProfile> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var youthCentersNames = ["شنواي", "الساقية", "كفر الحما"];
  var dropdownValue = "شنواي";
  late CenterUser centerUser;
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<String> minuItems = ["الصفحة الرئيسية", "إضافة حجز", "تسجيل خروج"];

  FetchData fetchData=FetchData();
  bool adminValue=false;


  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    mobileController.dispose();
    nameController.dispose();
  }

  @override
  void initState() {
    super.initState();

    getUser();
   
  }

  Future updateMyProfile(CenterUser centerUser) async {
    await db
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(centerUser.toJson())
        .whenComplete(
            () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Profile updated successfully "),
                  backgroundColor: Colors.redAccent,
                  elevation: 10, //shadow
                )));
  }

  getUser() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        String json = jsonEncode(documentSnapshot.data());
        Map<String, dynamic>? c = jsonDecode(json);
        centerUser = CenterUser.fromJson(c!);
        setState(() {
          usernameController.text = centerUser.email.toString().trim();
          nameController.text = centerUser.name.toString().trim();
          mobileController.text = centerUser.mobile.toString().trim();
          dropdownValue = centerUser.youthCenterName.toString().trim();
          adminValue=centerUser.admin;
        //  print(centerUser.name);
        });
      } else {
        print("error: no document found");
      }
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
                image: AssetImage("images/3f.jpg"), fit: BoxFit.cover)),
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
                    image: AssetImage("images/icon3.jpg"),
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          icon: Icon(Icons.person, color: Colors.red),
                          filled: true,
                          fillColor: Colors.amber,
                          hintText: "Email")),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                      obscureText: false,
                      controller: nameController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          icon: Icon(
                            Icons.nature,
                            color: Colors.red,
                          ),
                          filled: true,
                          fillColor: Colors.amber,
                          hintText: "name")),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                      obscureText: false,
                      controller: mobileController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          icon: Icon(
                            Icons.phone_in_talk_rounded,
                            color: Colors.red,
                          ),
                          filled: true,
                          fillColor: Colors.amber,
                          hintText: "mobile")),
                  Container(
                    color: Colors.amber,
                    child: DropdownButton<String>(
                        // Step 3.
                        value: dropdownValue,
                        icon: const Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          color: Colors.purple,
                        ),
                        // Step 4.
                        items: youthCentersNames
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(fontSize: 30),
                            ),
                          );
                        }).toList(),
                        // Step 5.
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        }),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 0),
                    child: ElevatedButton(
                      onPressed: () {
                        updateMyProfile(CenterUser(
                            admin: centerUser.admin,
                            name: nameController.text.toString().trim(),
                            email: usernameController.text.toString().trim(),
                            mobile: mobileController.text.toString().trim(),
                            youthCenterName: dropdownValue));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        //foregroundColor: Colors.black,
                      ),
                      child: const Text("Update my profile",
                          style: TextStyle(fontSize: 15, color: Colors.blue)),
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
