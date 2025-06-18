import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/screen/auth/login_screen.dart';
import 'package:youth_center/screen/auth/update_profile.dart';
import 'package:youth_center/screen/booking/ui/add_booking.dart';
import 'package:youth_center/screen/booking/ui/widgets/requests_booking.dart';
import 'package:youth_center/screen/cup/ui/cups_screen.dart';
import 'package:youth_center/screen/cup/ui/widgets/create_tournament_screen.dart';
import 'package:youth_center/screen/home/ui/widgets/home_body.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_center/screen/home/logic/home_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  late List<Widget> _screens;
  bool canPop = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _screens = [
      HomeScreenBody(tabController: _tabController),
      CupScreen(tabController: _tabController),
      UpdateProfile(),
      BookingRequestsScreen(),
    ];
  }

  _signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            ListTile(
              onTap: () {
                HelperMethods.buildAlertDialog(
                  context: context,
                  message: S.of(context).needLogOut,
                  actions: [S.of(context).cancel, S.of(context).ok],
                  onTap: _signOut,
                );
              },
              titleAlignment: ListTileTitleAlignment.center,
              trailing: Icon(Icons.logout),
              title: Text(S.of(context).logOut),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(isAdminProvider);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (canPop) {
          canPop = false;
          SystemNavigator.pop();
        } else {
          canPop = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).clickAgainToExit)),
          );
          Future.delayed(Duration(seconds: 2), () {
            canPop = false;
          });
        }
      },
      canPop: canPop,
      child: Scaffold(
        body: _screens[_currentIndex],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 3) {
              _showMenu();
              return;
            }
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: S.of(context).bookings,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              label: S.of(context).tournaments,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: S.of(context).myAccount,
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: S.of(context).more,
            ),
          ],
          selectedItemColor: const Color(0xFF1E40AF),
          unselectedItemColor: Colors.grey,
        ),
        floatingActionButton:
            _currentIndex == 0 || (_currentIndex == 1 && isAdmin)
                ? FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        if (_currentIndex == 0) {
                          return CreateBooking();
                        } else if (_currentIndex == 1 && isAdmin) {
                          return NewCreateTournament();
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    );
                  },
                  backgroundColor: ColorManger.darkBlack,
                  child: const Icon(Icons.add, color: Colors.white),
                )
                : SizedBox.shrink(),
      ),
    );
  }
}
