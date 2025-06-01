
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/core/widgets/app_text_button.dart';
import 'package:youth_center/core/widgets/body_container.dart';
import 'package:youth_center/core/widgets/day_drop_down.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/core/widgets/header.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/screen/booking/booking_controller.dart';
import 'package:youth_center/screen/home/home_controller.dart';
import 'package:youth_center/screen/home/home_screen.dart';

class AddBooking extends ConsumerStatefulWidget {
  const AddBooking({super.key,});


  @override
  @override
  ConsumerState<AddBooking> createState() {
    return Add();
  }
}

class Add extends ConsumerState<AddBooking> {
  late BookingModel booking;
  TextEditingController nameController = TextEditingController();

  TextEditingController mobileController = TextEditingController();
  bool adminValue = true;
  late String _selectedDay;
  List<String> _weekdays = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> _times = [];
  String? selectedStartTime;
  String? selectedEndTime;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weekdays = HelperMethods.getWeekDays(context);
    _selectedDay = _weekdays.first;
  }

  // void _handlePickTime(bool isStart) async {
  //   DateTime? selected = await HelperMethods.pickTime(context);
  //   if (selected == null) return;

  //   setState(() {
  //     if (isStart) {
  //       startTime = selected;
  //       timeStartController.text = MyConstants.hourFormat.format(startTime);
  //     } else {
  //       endTime = selected;
  //       timeEndController.text = MyConstants.hourFormat.format(endTime);
  //     }
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    mobileController.dispose();
  }

  Future addBooking(BookingModel booking) async {
    if (adminValue) {
      await ref.watch(addBookingProvider.notifier).addBooking(booking);
    } else {
      await ref.watch(addBookingProvider.notifier).requestBooking(booking);
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    ref.listen(addBookingProvider, (_, state) {
      state.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).successSave),
              backgroundColor: ColorManger.buttonGreen,
              elevation: 10,
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
            ),
          );
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: ColorManger.darkRed,
              elevation: 10,
            ),
          );
        },
      );
    });
    return Scaffold(
      body: GradientContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(title: S.of(context).addBooking),
              _buildBody(lang),
            ],
          ),
        ),
      ),
    );
  }

  _buildBody(S lang) {
    final centerName = ref.watch(selectedCenterNameProvider);
    final day = ref.watch(selectedDayProvider);
    adminValue = ref.watch(isAdminProvider);
    final timesAsync = ref.watch(
      availableTimesProvider((centerName ?? '', day)),
    );
    return BodyContainer(
      height: SizeConfig.screenHeight! * .85,
      padding: SizeConfig().getScreenPadding(vertical: .1, horizintal: .08),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildDayDropDown(),
              HelperMethods.verticalSpace(.03),
        
              HelperMethods.buildTextField(
                Icons.person,
                lang.entername,
                nameController,
                validator:
                    (value) =>
                        value?.isEmpty ?? true ? S.of(context).entername : null,
              ),
        
              HelperMethods.verticalSpace(.03),
              HelperMethods.buildTextField(
        
                Icons.phone,
                lang.enterMobile,
                mobileController,
                validator:
                    (value) =>
                        value?.isEmpty ?? true ? S.of(context).enterMobile : null,
              ),
        
              HelperMethods.verticalSpace(.03),
              timesAsync.when(
                data: (times) {
                  _times = times;
                  return DayDropdown(
                    validator: (value) => value?.isEmpty ?? true
                        ? S.of(context).enterStartTime
                        : null,
                    lableText: lang.enterStartTime,
                    days: _times,
                    selectedDay: selectedStartTime,
                    onChanged: (newTime) {
                      setState(() {
                        selectedStartTime = newTime;
                      });
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Text(error.toString()),
              ),
        
             
              HelperMethods.verticalSpace(.03),
              timesAsync.when(
                data: (times) {
                  _times = times;
                  return DayDropdown(
                    validator: (value) => value?.isEmpty ?? true
                        ? S.of(context).enterEndTime
                        : null,
                    lableText: lang.enterEndTime,
                    days: _times,
                    selectedDay: selectedEndTime,
                    onChanged: (newTime) {
                      setState(() {
                        selectedEndTime = newTime;
                      });
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Text(error.toString()),
              ),
              
              HelperMethods.verticalSpace(.03),
        
              AppButtonText(
                backGroundColor: ColorManger.buttonGreen,
                textStyle: TextStyles.whiteBoldStyle(SizeConfig.fontSize3!),
                butonText: adminValue ? lang.addBooking : lang.requestBooking,
                onPressed: () {
                 
                  
                  if (_formKey.currentState!.validate()) {
                    final newBooking = BookingModel(
                    date: DateTime.now().toIso8601String(),
                    day: _selectedDay,
                    name: nameController.text.toString().trim(),
                    mobile: mobileController.text.toString().trim(),
                    timeEnd: selectedEndTime!,
                    timeStart: selectedStartTime!,
                    youthCenterId: MyConstants.centerUser?.youthCenterName ?? '',
                  );
                    addBooking(newBooking);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildDayDropDown() {
    return DayDropdown(
      days: _weekdays,
      selectedDay: _selectedDay,

      onChanged: (newDay) {
        setState(() {
          _selectedDay = newDay!;
        });
      },
    );
  }
}
