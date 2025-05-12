// Redesigned HomeScreenBody to match modern login theme
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/shared_pref_helper.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/models/user_model.dart';
import 'package:youth_center/models/youth_center_model.dart';
import 'package:youth_center/screen/booking/add_booking.dart';
import 'package:youth_center/screen/cup/cups_screen.dart';
import 'package:youth_center/screen/home/booking_card.dart';
import 'package:youth_center/screen/home/booking_service.dart';
import 'package:youth_center/screen/home/matches_of_ctive_cups.dart';
import 'package:youth_center/screen/auth/update_profile.dart';

class HomeScreenBody extends StatefulWidget {
  final CenterUser centerUser;
  final TabController tabController;

  const HomeScreenBody({
    super.key,
    required this.centerUser,
    required this.tabController,
  });

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  final BookingService bookingService = BookingService();
  List<BookingModel> bookings = [];
  List<YouthCenterModel> youthCenters = [];
  List<String> youthCenterNames = [];
  late String dropdownValue;
  late bool isAdmin;

  @override
  void initState() {
    super.initState();
    isAdmin = widget.centerUser.admin;
    dropdownValue = widget.centerUser.youthCenterName;
    _fetchData();
  }

  Future<void> _fetchData() async {
    youthCenters = await bookingService.getAllCenters();
    youthCenterNames = youthCenters.map((e) => e.name).toSet().toList();
    SharedPrefHelper.setData(MyConstants.prefCenterNames, youthCenterNames);

    await _loadBookings();
  }

  Future<void> _loadBookings() async {
    if (isAdmin) {
      bookings = await bookingService.getBookingsByCenter(
        widget.centerUser.youthCenterName,
      );
    } else {
      bookings = await bookingService.getBookingsByCenter(dropdownValue);
    }
    setState(() {});
  }

  void _onDropdownChanged(String? newValue) async {
    if (newValue != null) {
      dropdownValue = newValue;
      await _loadBookings();
    }
  }

  void _onMenuSelected(int value) {
    switch (value) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UpdateProfile()),
        );
        break;
      case 1:
        if (isAdmin) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBooking(center: widget.centerUser.youthCenterName),
            ),
          );
        }
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CupScreen(center: widget.centerUser),
          ),
        );
        break;
      case 3:
        FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacementNamed('/');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/football_logo.png', height: 30),
            const SizedBox(width: 8),
            Text(
              'Youth Center',
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: widget.tabController,
          indicator: BoxDecoration(borderRadius: BorderRadius.circular(25.0)),
          unselectedLabelColor: Colors.white60,
          labelColor: Colors.white,
          tabs: const [
            Tab(child: Text("الحجوزات")),
            Tab(child: Text("البطولات")),
          ],
        ),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: _buildMenuItem("حسابي", Icons.account_circle_outlined),
              ),
              PopupMenuItem(
                value: 1,
                child: _buildMenuItem("اضافة حجز", Icons.add),
              ),
              PopupMenuItem(
                value: 2,
                child: _buildMenuItem("الدورات", Icons.sports_baseball),
              ),
              PopupMenuItem(
                value: 3,
                child: _buildMenuItem("تسجيل خروج", Icons.logout),
              ),
            ],
            onSelected: _onMenuSelected,
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: SwipeDetector(
        onSwipeDown: (offset) => _loadBookings(),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/stadium_bg.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6),
                BlendMode.darken,
              ),
            ),
          ),
          child: TabBarView(
            controller: widget.tabController,
            children: [
              _buildBookingsTab(),
              MatchesOfActiveCups(center: widget.centerUser),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsTab() {
    return Column(
      children: [
        const SizedBox(height: 10),
        if (!isAdmin)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white54),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: dropdownValue,
                dropdownColor: Colors.blueGrey[900],
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                items: youthCenterNames.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: _onDropdownChanged,
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              var booking = bookings[index];
              return BookingCard(booking: booking);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(width: 10),
        Text(title),
      ],
    );
  }
}