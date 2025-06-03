import 'package:flutter/material.dart';
import 'package:youth_center/core/helper/extensions.dart';
import 'package:youth_center/core/helper/size_config.dart';

class ArrowBackWidget extends StatelessWidget {
  const ArrowBackWidget({super.key, this.route});
  final String? route;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
       route==null? context.pop() :context.pushReplacementNamed(route!);
      },
      child: Icon(
        (Icons.arrow_back),
        color: Colors.white,
        size: SizeConfig.screenHeight! * .04,
      ),
    );
  }
}
