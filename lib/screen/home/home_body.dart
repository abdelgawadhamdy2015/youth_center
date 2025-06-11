import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/widgets/body_container.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/screen/home/home_controller.dart';
import 'package:youth_center/screen/home/matches_of_ctive_cups.dart';
import 'package:youth_center/screen/home/time_slot_card.dart';

class HomeScreenBody extends ConsumerStatefulWidget {
  final TabController tabController;

  const HomeScreenBody({super.key, required this.tabController});

  @override
  ConsumerState<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends ConsumerState<HomeScreenBody> {
  List<String> _weekdays = [];
  int selectedCenterIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weekdays = HelperMethods.getWeekDays(context);
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

    if (!isAdmin) {
      final youthCenterNames =
          youthCentersAsync.asData?.value.map((center) => center.name).toList();
      final selectedyouthCenterName =
          ref.watch(selectedCenterNameProvider) ??
          MyConstants.centerUser?.youthCenterName;
      selectedCenterIndex =
          (selectedyouthCenterName != null && youthCenterNames != null)
              ? youthCenterNames.indexOf(selectedyouthCenterName)
              : 0;
    }

    final selectedDay = ref.watch(selectedDayProvider);
    final filteredBookings = ref.watch(filteredBookingsProvider);
    return Column(
      children: [
        if (!isAdmin)
          youthCentersAsync.when(
            data: (data) {
              final youthCenterNames =
                  data.map((center) => center.name).toList();
              if (data.isEmpty) {
                return Center(child: Text(S.of(context).noData));
              }
              return SizedBox(
                height: SizeConfig.screenHeight! * .05,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: youthCenterNames.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCenterIndex = index;
                          ref.watch(selectedCenterNameProvider.notifier).state =
                              youthCenterNames[index];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color:
                              selectedCenterIndex == index
                                  ? const Color(0xFF1E40AF)
                                  : Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          youthCenterNames[index],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                selectedCenterIndex == index
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text("حدث خطأ: $error")),
          ),

        HelperMethods.verticalSpace(.02),
        SizedBox(
          height: 50, // height of each horizontal item
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _weekdays.length,
            itemBuilder: (context, index) {
              final day = _weekdays[index];
              final isSelected = day == selectedDay;

              return GestureDetector(
                onTap: () {
                  ref.read(selectedDayProvider.notifier).state = day;
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
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
                  return TimeSlotCard(
                    bookingModel: booking,
                    isAvailable: false,
                  );
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
                Tab(child: Text(lang.matches)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
