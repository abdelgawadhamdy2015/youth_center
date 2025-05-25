import 'package:flutter/material.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';

class BodyContainer extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
final double? height;
final EdgeInsets? padding;
  const BodyContainer({
    super.key,
    this.appBar,
    required this.child,
    this.floatingActionButton,
    this.bottomNavigationBar, this.height, this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding:padding?? SizeConfig().getScreenPadding(),
                decoration: BoxDecoration(
                  gradient: ColorManger.bodyGradient,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(MyConstants.containerRadius),topRight: Radius.circular(MyConstants.containerRadius))
                ),
      child: child,
      
    );
  }
}
