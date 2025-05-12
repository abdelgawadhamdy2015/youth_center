import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youth_center/fetch_data.dart';

import '../../models/user_model.dart';

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

  FetchData fetchData = FetchData();
  bool adminValue = false;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future updateMyProfile(CenterUser centerUser) async {
    await db
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(centerUser.toJson())
        .whenComplete(
          () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile updated successfully "),
              backgroundColor: Colors.redAccent,
              elevation: 10, //shadow
            ),
          ),
        );
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
              adminValue = centerUser.admin;
                
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
        backgroundColor: Colors.blueGrey,
        title: Text('Youth Center', style: GoogleFonts.tajawal()),
        leading: BackButton(),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/1f.jpg'), // Replace with your background
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo.jpg',
              height: 80,
            ), // Replace with your logo
            SizedBox(height: 20),
            buildInputField(Icons.email, "email", usernameController),
            SizedBox(height: 10),
            buildInputField(Icons.person, "name", nameController),
            SizedBox(height: 10),
            buildInputField(Icons.phone, "mobile", mobileController),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.blueGrey),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: youthCentersNames[0],
                  icon: Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                  items:
                      youthCentersNames.map((center) {
                        return DropdownMenuItem(
                          value: center,
                          child: Text(
                            center,
                            style: GoogleFonts.tajawal(fontSize: 16),
                          ),
                        );
                      }).toList(),
                  onChanged: !adminValue? (value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  }: null,
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                updateMyProfile(
                  CenterUser(
                    name: nameController.text,
                    mobile: mobileController.text,
                    email: usernameController.text,
                    youthCenterName: dropdownValue,
                    admin: centerUser.admin,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "تحديث الملف الشخصي",
                style: GoogleFonts.cairo(fontSize: 16,color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(
    IconData icon,
    String hintText,
    TextEditingController controller,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.blueGrey),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.tajawal(),
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
