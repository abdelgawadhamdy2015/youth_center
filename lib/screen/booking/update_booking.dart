import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
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

class UpdateBooking extends ConsumerStatefulWidget {
  const UpdateBooking({super.key, required this.booking});
  final BookingModel booking;

  @override
  ConsumerState<UpdateBooking> createState() => _UpdateBookingState();
}

class _UpdateBookingState extends ConsumerState<UpdateBooking> {
  late final TextEditingController nameController;
  late final TextEditingController mobileController;
  late final List<String> _weekdays;

  String? selectedStartTime;
  String? selectedEndTime;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.booking.name);
    mobileController = TextEditingController(text: widget.booking.mobile);
    selectedStartTime = widget.booking.timeStart;
    selectedEndTime = widget.booking.timeEnd;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedCenterNameProvider.notifier).state = widget.booking.youthCenterId;
      ref.read(selectedDayProvider.notifier).state = widget.booking.day;
    });
    _weekdays = HelperMethods.getWeekDays(context);
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final selectedDay = ref.watch(selectedDayProvider);
    final timesAsync = ref.watch(
      availableTimesProvider((
        ref.watch(selectedCenterNameProvider) ?? "",
        selectedDay,
      )),
    );

    ref.listen(addBookingProvider, (_, state) {
      state.whenOrNull(
        data: (_) {
          _showSnackBar(lang.successSave, ColorManger.buttonGreen);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
        },
        error: (error, _) {
          _showSnackBar(error.toString(), ColorManger.darkRed);
        },
      );
    });

    return Scaffold(
      body: GradientContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(title: lang.bookings),
              BodyContainer(
                height: SizeConfig.screenHeight! * .85,
                padding: SizeConfig().getScreenPadding(vertical: .1, horizintal: .08),
                child: Column(
                  children: [
                    DayDropdown(
                      days: _weekdays,
                      selectedDay: selectedDay,
                      onChanged: MyConstants.centerUser?.admin == true
                          ? (newDay) => ref.read(selectedDayProvider.notifier).state = newDay!
                          : null,
                    ),
                    HelperMethods.verticalSpace(.03),

                    HelperMethods.buildTextField(
                      readOnly: !(MyConstants.centerUser?.admin ?? false),
                      Icons.person,
                      lang.entername,
                      nameController,
                    ),
                    HelperMethods.verticalSpace(.03),

                    HelperMethods.buildTextField(
                      readOnly: !(MyConstants.centerUser?.admin ?? false),
                      Icons.phone,
                      lang.enterMobile,
                      mobileController,
                    ),
                    HelperMethods.verticalSpace(.03),

                    _buildTimeDropdown(
                      context,
                      timesAsync,
                      label: lang.enterStartTime,
                      selectedTime: selectedStartTime,
                      onChanged: (value) => setState(() => selectedStartTime = value),
                    ),
                    HelperMethods.verticalSpace(.03),

                    _buildTimeDropdown(
                      context,
                      timesAsync,
                      label: lang.enterEndTime,
                      selectedTime: selectedEndTime,
                      onChanged: (value) => setState(() => selectedEndTime = value),
                    ),
                    HelperMethods.verticalSpace(.03),

                    if (MyConstants.centerUser?.admin ?? false) _buildActionButtons(lang),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeDropdown(
    BuildContext context,
    AsyncValue<List<String>> timesAsync, {
    required String label,
    required String? selectedTime,
    required void Function(String?) onChanged,
  }) {
    return timesAsync.when(
      data: (times) => DayDropdown(
        lableText: label,
        days: times,
        selectedDay: selectedTime,
        validator: (value) => (value?.isEmpty ?? true) ? label : null,
        onChanged: onChanged,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text(e.toString(), style: const TextStyle(color: Colors.red)),
    );
  }

  Widget _buildActionButtons(S lang) {
    final double buttonWidth = SizeConfig.screenWidth! * .4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppButtonText(
          buttonWidth: buttonWidth,
          backGroundColor: ColorManger.mainBlue,
          textStyle: GoogleFonts.tajawal(
            color: Colors.white,
            fontSize: SizeConfig.fontSize3!,
          ),
          butonText: lang.update,
          onPressed: _updateBooking,
        ),
        AppButtonText(
          buttonWidth: buttonWidth,
          backGroundColor: ColorManger.lighterGray,
          textStyle: GoogleFonts.tajawal(
            color: Colors.white,
            fontSize: SizeConfig.fontSize3!,
          ),
          butonText: lang.delete,
          onPressed: _deleteBooking,
        ),
      ],
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, elevation: 10),
    );
  }

  void _updateBooking() {
    final updatedBooking = _buildBookingModel();
    ref.read(addBookingProvider.notifier).updateBooking(updatedBooking);
  }

  void _deleteBooking() {
    ref.read(addBookingProvider.notifier).deleteBooking(widget.booking.id!);
  }

  BookingModel _buildBookingModel() {
    return BookingModel(
      id: widget.booking.id,
      date: widget.booking.date,
      name: nameController.text.trim(),
      mobile: mobileController.text.trim(),
      timeStart: selectedStartTime!,
      timeEnd: selectedEndTime!,
      day: ref.read(selectedDayProvider),
      youthCenterId: ref.read(selectedCenterNameProvider)!,
    );
  }
}
