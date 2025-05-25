// Redesigned HomeScreenBody to match modern login theme
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:svg_flutter/svg.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/shared_pref_helper.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/widgets/body_container.dart';
import 'package:youth_center/core/widgets/day_drop_down.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/generated/l10n.dart';
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
  List<BookingModel> _bookings = [];
  List<BookingModel> _filteredBookings = [];

  List<YouthCenterModel> youthCenters = [];
  List<String> youthCenterNames = [];
  late String dropdownValue;
  late bool isAdmin;
  late String _selectedDay;
  List<String> _weekdays = [];

  @override
  void initState() {
    super.initState();
    isAdmin = widget.centerUser.admin;
    dropdownValue = widget.centerUser.youthCenterName;
    _fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weekdays = HelperMethods.getWeekDays(context);
    String weekday = DateFormat(
      'EEEE',
      Intl.defaultLocale,
    ).format(DateTime.now());
    _selectedDay = weekday;
  }

  Future<void> _fetchData() async {
    youthCenterNames = await SharedPrefHelper.getListString(
      MyConstants.prefCenterNames,
    );
    if (youthCenterNames.isEmpty) {
      youthCenters = await bookingService.getAllCenters();
      youthCenterNames = youthCenters.map((e) => e.name).toSet().toList();
      SharedPrefHelper.setData(MyConstants.prefCenterNames, youthCenterNames);
    }
    await _loadBookings();
  }

  Future<void> _loadBookings() async {
    if (isAdmin) {
      _bookings = await bookingService.getBookingsByCenter(
        widget.centerUser.youthCenterName,
      );
    } else {
      _bookings = await bookingService.getBookingsByCenter(dropdownValue);
      _filterBookings();
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
              builder: (context) => AddBooking(center: widget.centerUser),
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
    var lang = S.of(context);
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: GradientContainer(
          child: SingleChildScrollView(
            child: Column(children: [_buildHeader(lang), _buildBody()]),
          ),
        ),
      ),
    );
  }

  _filterBookings() {
    _filteredBookings =
        _bookings.where((booking) {
          return booking.day == _selectedDay;
        }).toList();
  }

  _buildBody() {
    return BodyContainer(
      padding: SizeConfig().getScreenPadding(
        vertical: .05,
      ), //EdgeInsets.only(bottom: SizeConfig.screenHeight! * .05),
      height: SizeConfig.screenHeight! * .8,
      child: SwipeDetector(
        onSwipeDown: (offset) => _loadBookings(),
        child: TabBarView(
          controller: widget.tabController,
          children: [
            _buildBookingsTab(),
            MatchesOfActiveCups(center: widget.centerUser),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsTab() {
    return Column(
      children: [
        if (!isAdmin)
          DayDropdown(
            lableText: S.of(context).selectCenter,
            days: youthCenterNames,
            selectedDay: dropdownValue,
            onChanged: _onDropdownChanged,
          ),
        HelperMethods.verticalSpace(.02),
        DayDropdown(
          lableText: S.of(context).selectDay,
          days: _weekdays,
          selectedDay: _selectedDay,
          onChanged: (newDay) {
            setState(() {
              _selectedDay = newDay!;
              _filterBookings();
            });
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredBookings.length,
            itemBuilder: (context, index) {
              var booking = _filteredBookings[index];
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

  _buildHeader(var lang) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo and App Name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(
                    MyConstants.logoSvg,
                    height: SizeConfig.screenHeight! * .12,
                    width: SizeConfig.screenWidth! * .12,
                  ),
                  // Image.asset(MyConstants.logoPath, height: 50, width: 50),
                  Text(
                    lang.appName,
                    style: GoogleFonts.tajawal(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
      
              // Popup Menu Icon
              PopupMenuButton<int>(
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        value: 0,
                        child: _buildMenuItem(
                          lang.myAccount,
                          Icons.account_circle_outlined,
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: _buildMenuItem(lang.addBooking, Icons.add),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: _buildMenuItem(
                          lang.tournaments,
                          Icons.sports_baseball,
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: _buildMenuItem(lang.logOut, Icons.logout),
                      ),
                    ],
                onSelected: _onMenuSelected,
                icon: const Icon(Icons.menu, color: Colors.white),
              ),
            ],
          ),
      
          // TabBar 
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(SizeConfig.screenWidth! * .2), 
            ),
            child: TabBar(
              controller: widget.tabController,
      
              unselectedLabelColor: Colors.white60,
              labelColor: Colors.white,
              tabs: [
                Tab(child: Text(lang.bookings)),
                Tab(child: Text(lang.tournaments)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
