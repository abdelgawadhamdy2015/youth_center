import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/screen/booking/add_booking.dart';
import 'package:youth_center/screen/cup/create_tournement.dart';
import 'package:youth_center/screen/cup/cups_screen.dart';
import 'package:youth_center/screen/home/home_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  late List<Widget> _screens;
  bool canPop = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _screens = [HomeScreenBody(tabController: _tabController), CupScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (canPop) {
          canPop = false;
          SystemNavigator.pop();
        } else {
          canPop = true;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('click back again to exit')));
        }
      },
      canPop: canPop,
      child: Scaffold(
        body: _screens[_currentIndex],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items:  [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: S.of(context).bookings,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              label: S.of(context).tournaments,
            ),
            
          ],
          selectedItemColor: const Color(0xFF1E40AF),
          unselectedItemColor: Colors.grey,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) =>  CreateTournamentScreen(),
            );
          },
          backgroundColor: const Color(0xFF1E40AF),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
