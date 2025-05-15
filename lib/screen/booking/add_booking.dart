import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/core/widgets/app_text_button.dart';
import 'package:youth_center/core/widgets/body_container.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/core/widgets/header.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/models/user_model.dart';
import 'package:youth_center/screen/home/home_screen.dart';

import '../../fetch_data.dart';

class AddBooking extends StatefulWidget {
  const AddBooking({super.key, required this.center});

  final CenterUser center;

  @override
  State<StatefulWidget> createState() {
    return Add();
  }
}

class Add extends State<AddBooking> {
  Add();

  FirebaseFirestore db = FirebaseFirestore.instance;
  late BookingModel booking;
  TextEditingController nameController = TextEditingController();
  TextEditingController timeStartController = TextEditingController();
  TextEditingController timeEndController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  FetchData fetchDate = FetchData();
  bool adminValue = true;
  var dropdownValue = "شنواي";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(widget.center);
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    timeStartController.dispose();
    mobileController.dispose();
  }

  Future addBooking(BookingModel booking) async {
    db
        .collection(MyConstants.bookingCollection)
        .add(booking.toJson())
        .whenComplete(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).successSave),
              backgroundColor: ColorManger.buttonGreen,
              elevation: 10,
            ),

          );
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
            return HomeScreen(centerUser: widget.center);
          }));
        });
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      body: GradientContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(title: S.of(context).addBooking),
              _buildBody(lang),
            ],
          ),
        ),
      ),
    );
  }

  _buildBody(var lang) {
    return BodyContainer(
      height: SizeConfig.screenHeight! * .85,

      child: Form(
        key:_formKey ,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HelperMethods.buildTextField(
              Icons.person,
              lang.entername,
              nameController,
              validator:
                (value) =>
                    value?.isEmpty ?? true ? S.of(context).entername : null,
            ),
        
            const SizedBox(height: 20),
            HelperMethods.buildTextField(
              Icons.phone,
              lang.enterMobile,
              mobileController,
             validator:
                (value) =>
                    value?.isEmpty ?? true ? S.of(context).enterMobile : null,
            ),
        
            const SizedBox(height: 20),
            HelperMethods.buildTextField(
              Icons.timer_rounded,
              lang.enterStartTime,
              timeStartController,
               validator:
                (value) =>
                    value?.isEmpty ?? true ? S.of(context).enterStartTime : null,
            ),
        
            const SizedBox(height: 20),
            HelperMethods.buildTextField(
              Icons.timer,
              lang.enterEndTime,
              timeEndController,
              validator:
                (value) =>
                    value?.isEmpty ?? true ? S.of(context).enterEndTime : null,
            ),
            const SizedBox(height: 20),
        
            AppButtonText(
              backGroundColor: ColorManger.buttonGreen,
              buttonWidth: SizeConfig.screenWidth! * .5,
              textStyle: TextStyles.whiteBoldStyle(SizeConfig.fontSize3!),
              butonText: lang.addBooking,
              onPressed: () {
           if( _formKey.currentState!.validate()){    addBooking(
                 BookingModel(
                    name: nameController.text.toString().trim(),
                    mobile: mobileController.text.toString().trim(),
                    timeEnd: timeEndController.text.toString().trim(),
                    timeStart: timeStartController.text.toString().trim(),
                    youthCenterId: widget.center.youthCenterName,
                  ),
                );
           }
              },
            ),
          ],
        ),
      ),
    );
  }
}
