import 'package:flutter/material.dart';
import 'package:youth_center/core/themes/colors.dart';

class GradientContainer extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final double? height;
  final double? width;

  const GradientContainer({
    super.key,
    this.appBar,
    required this.child,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? double.infinity,
      width: width ?? double.infinity,
      decoration: BoxDecoration(gradient: ColorManger.mainGradient),
      child: child,
    );
  }
}
