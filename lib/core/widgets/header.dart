import 'package:flutter/material.dart';

import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/core/widgets/arrow_back_widget.dart';

class Header extends StatelessWidget {
  const Header({super.key, this.route, required this.title, this.height});
  final String? route;
  final String title;
  final double ? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: SizeConfig().getScreenPadding(vertical: .03,horizintal: .01),
      height:height?? SizeConfig.screenHeight! * .15,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ArrowBackWidget(
              route: route,
            ),
            Text(
              title,
              style: TextStyles.whiteBoldStyle(SizeConfig.fontSize4!),
            ),
            IconButton(
              onPressed: () {},
              icon: Center(
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
            ),
          ]),
    );
  }
}
