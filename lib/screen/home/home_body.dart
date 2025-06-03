import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/widgets/body_container.dart';
import 'package:youth_center/core/widgets/day_drop_down.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/screen/booking/add_booking.dart';
import 'package:youth_center/screen/booking/requests_booking.dart';
import 'package:youth_center/screen/cup/cups_screen.dart';
import 'package:youth_center/screen/home/booking_card.dart';
import 'package:youth_center/screen/home/home_controller.dart';
import 'package:youth_center/screen/home/matches_of_ctive_cups.dart';
import 'package:youth_center/screen/auth/update_profile.dart';

class HomeScreenBody extends ConsumerStatefulWidget {
  final TabController tabController;

  const HomeScreenBody({super.key, required this.tabController});

  @override
  ConsumerState<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends ConsumerState<HomeScreenBody> {
  List<String> _weekdays = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weekdays = HelperMethods.getWeekDays(context);
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingRequestsScreen(),
          ),
        );

        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddBooking(),
          ),
        );

        break;

      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CupScreen()),
        );
        break;
      case 4:
        FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacementNamed('/');

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    final isAdmin = ref.read(isAdminProvider);

    return DefaultTabController(
        length: 2,
        child: GradientContainer(
          child: SingleChildScrollView(
            child: Column(
              children: [_buildHeader(lang, isAdmin), _buildBody(isAdmin)],
            ),
          ),
        ),
      );
    
  }

  _buildBody(bool isAdmin) {
    return BodyContainer(
      padding: SizeConfig().getScreenPadding(vertical: .01),
      height: SizeConfig.screenHeight! * .85,
      child: SwipeDetector(
        child: TabBarView(
          controller: widget.tabController,
          children: [_buildBookingsTab(isAdmin), MatchesOfActiveCups()],
        ),
      ),
    );
  }

  Widget _buildBookingsTab(bool isAdmin) {
    final youthCentersAsync = ref.watch(youthCentersProvider);

    // final youthCenterNames =
    //     youthCentersAsync.asData?.value.map((center) => center.name).toList() ??
    //     [];
    final selectedCenter = ref.watch(selectedCenterNameProvider)?? MyConstants.centerUser?.youthCenterName;

    final selectedDay = ref.watch(selectedDayProvider);
    final filteredBookings = ref.watch(filteredBookingsProvider);
    return Column(
      children: [
        if (!isAdmin)
          youthCentersAsync.when(
            data: (data) {
              final youthCenterNames = data
                  .map((center) => center.name)
                  .toList();
              if (data.isEmpty) {
                return Center(child: Text(S.of(context).noData));
              }
            return  DayDropdown(
                lableText: S.of(context).selectCenter,
                selectedDay: selectedCenter,
                days: youthCenterNames,
                onChanged: (newValue) {
                  setState(() {
                    ref.read(selectedCenterNameProvider.notifier).state =
                        newValue;
                  });
                },
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text("حدث خطأ: $error")),
          ),

        HelperMethods.verticalSpace(.02),
        DayDropdown(
          lableText: S.of(context).selectDay,
          days: _weekdays,
          selectedDay: selectedDay,
          onChanged: (newDay) {
            setState(() {
              ref.read(selectedDayProvider.notifier).state = newDay!;
            });
          },
        ),
        HelperMethods.verticalSpace(.02),

        filteredBookings.when(
          data: (bookings) {
            if (bookings.isEmpty) {
              return Center(child: Text(S.of(context).noData));
            }
            return Expanded(
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  var booking = bookings[index];
                  return BookingCard(booking: booking);
                },
              ),
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("حدث خطأ: $e")),
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

  _buildHeader(var lang, bool isAdmin) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SvgPicture.asset(
                MyConstants.logoSvg,
                height: SizeConfig.screenHeight! * .05,
              ),
              HelperMethods.horizintalSpace(.02),

              Text(
                lang.appName,
                style: GoogleFonts.tajawal(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),

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
                    if(isAdmin)  PopupMenuItem(
                        value: 1,
                        child: _buildMenuItem(
                          lang.requests,
                          Icons.request_page,
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: _buildMenuItem(
                          (isAdmin) ? lang.addBooking : lang.requestBooking,
                          Icons.add,
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: _buildMenuItem(
                          lang.tournaments,
                          Icons.sports_baseball,
                        ),
                      ),
                      PopupMenuItem(
                        value: 4,
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
