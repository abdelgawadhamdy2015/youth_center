import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youth_center/screen/home/home_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool canPop = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        
          // Handle the pop action, e.g., navigate back or show a dialog
          if (canPop) {
            canPop = false;
            SystemNavigator.pop();
          } else {
            canPop = true;
            // Show a message or perform an action if pop is not allowed
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('click back again to exit')));
          }
       
        // No return needed; onPopInvokedWithResult expects void
      },
      canPop: canPop,
      child: HomeScreenBody(tabController: _tabController),
    );
  }
}
