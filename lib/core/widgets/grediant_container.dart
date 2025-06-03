import 'package:flutter/material.dart';
import 'package:youth_center/core/themes/colors.dart';

class GradientContainer extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const GradientContainer({
    super.key,
    this.appBar,
    required this.child,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient:ColorManger.mainGradient,
      ),
      child: child,
      
    );
  }
}
