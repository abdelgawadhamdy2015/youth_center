import 'package:flutter/material.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/widgets/mytextfile.dart';

class HelperMethods {
  static Widget buildTextField(
    IconData icon,
    String hint,
    TextEditingController controller, {
    var validator,
  }) {
    return MyTextForm(
      fillColor: ColorManger.whiteColor,
      hint: hint,
      icon: Icon(icon),
      controller: controller,
      validator:validator
         
    );
  }
}
