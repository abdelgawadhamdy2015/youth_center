
import 'package:flutter/material.dart';
import 'package:youth_center/models/user_model.dart';
import 'package:youth_center/screen/home/home_body.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.centerUser});
  final CenterUser centerUser;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreenBody(
      centerUser: widget.centerUser,
      tabController: _tabController,
    );
  }
}
