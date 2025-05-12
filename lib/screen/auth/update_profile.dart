import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/fetch_data.dart';
import 'package:youth_center/generated/l10n.dart';

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
  var dropdownValue = "شنواي";
  late CenterUser centerUser;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late List<String> minuItems ;

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
     minuItems = [S.of(context).homePage, S.of(context).addBooking, S.of(context).logOut];
  }

  Future updateMyProfile(CenterUser centerUser) async {
    await db
        .collection(MyConstants.userCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(centerUser.toJson())
        .whenComplete(
          () => ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              content: Text(S.of(context).profileUpdated),
              backgroundColor: Colors.redAccent,
              elevation: 10, //shadow
            ),
          ),
        );
  }

  getUser() async {
    await FirebaseFirestore.instance
        .collection(MyConstants.userCollection)
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
            print(S.of(context).wrong);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(S.of(context).appName, style: GoogleFonts.tajawal()),
        leading: BackButton(),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(MyConstants.imag1), // Replace with your background
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
             MyConstants.logoPath,
              height: 80,
            ), // Replace with your logo
            SizedBox(height: 20),
            buildInputField(Icons.email, S.of(context).enterUsername, usernameController),
            SizedBox(height: 10),
            buildInputField(Icons.person, S.of(context).entername, nameController),
            SizedBox(height: 10),
            buildInputField(Icons.phone, S.of(context).enterMobile, mobileController),
            SizedBox(height: 10),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 12),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(30),
            //     border: Border.all(color: Colors.blueGrey),
            //   ),
            //   child: DropdownButtonHideUnderline(
            //     child: DropdownButton<String>(
            //       isExpanded: true,
            //       value: youthCentersNames[0],
            //       icon: Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
            //       items:
            //           youthCentersNames.map((center) {
            //             return DropdownMenuItem(
            //               value: center,
            //               child: Text(
            //                 center,
            //                 style: GoogleFonts.tajawal(fontSize: 16),
            //               ),
            //             );
            //           }).toList(),
            //       onChanged: !adminValue? (value) {
            //         setState(() {
            //           dropdownValue = value!;
            //         });
            //       }: null,
            //     ),
            //   ),
            // ),
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
                S.of(context).update,
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
