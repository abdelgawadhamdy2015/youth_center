import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/shared_pref_helper.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/models/cup_model.dart';
import 'package:youth_center/models/match_model.dart';
import 'package:youth_center/models/user_model.dart';
import 'package:youth_center/models/youth_center_model.dart';
import 'package:youth_center/screen/home/booking_service.dart';

final centerUserProvider = Provider<CenterUser>((ref) {
  return MyConstants.centerUser; // تأتي من تسجيل الدخول
});

final isAdminProvider = Provider<bool>((ref) {
  return ref.watch(centerUserProvider).admin;
});

final youthCentersProvider = FutureProvider<List<YouthCenterModel>>((
  ref,
) async {
  final service = BookingService();

  final centers = await service.getAllCenters();
  return centers;
});

final youthCenterNamesProvider = FutureProvider<List<String>>((ref) async {
  List<String> centerNames = await SharedPrefHelper.getListString(
    MyConstants.prefCenterNames,
  );
  if (centerNames.isEmpty) {
    final centers = await BookingService().getAllCenters();
    centerNames = centers.map((e) => e.name).toList();
    await SharedPrefHelper.setData(MyConstants.prefCenterNames, centerNames);
  }
  return centerNames;
});

final selectedCenterNameProvider = StateProvider<String?>((ref) {
  return null;
});

final selectedDayProvider = StateProvider<String>((ref) {
  return DateFormat("EEE").format(DateTime.now()); // الأحد، الإثنين، إلخ
});

final bookingsProvider = FutureProvider.autoDispose<List<BookingModel>>((ref) async {
  final bookingService = BookingService();

  final isAdmin = ref.watch(isAdminProvider);
  final selectedCenter = ref.watch(selectedCenterNameProvider);
  final user = ref.watch(centerUserProvider);

  // إذا كان المستخدم Admin، استخدم اسم مركزه
  if (isAdmin) {
    return bookingService.getBookingsByCenter(user.youthCenterName);
  }

  // إذا تم تحديد مركز، اجلب الحجوزات له
  if (selectedCenter != null && selectedCenter.isNotEmpty) {
    return bookingService.getBookingsByCenter(selectedCenter);
  }

  // في حال لم يتم تحديد أي مركز
  return [];
});
final filteredBookingsProvider = FutureProvider<List<BookingModel>>((
  ref,
) async {
  final bookingsAsync = ref.watch(bookingsProvider);
  final selectedDay = ref.watch(selectedDayProvider);
  final selectedCenter = ref.watch(selectedCenterNameProvider);

  return bookingsAsync.when(
    data: (bookings) {
      return bookings
          .where(
            (booking) =>
                booking.day == selectedDay &&
                booking.youthCenterId == selectedCenter,
          )
          .toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

final activeCupsProvider = FutureProvider<List<CupModel>>((ref) async {
  final bookingService = BookingService();
  final isAdmin = ref.watch(isAdminProvider);
  final selectedCenter = ref.watch(selectedCenterNameProvider);

  if (isAdmin) {
    final user = ref.watch(centerUserProvider);
    return await bookingService.getCups(user.youthCenterName, finished: false);
  } else if (selectedCenter != null) {
    return await bookingService.getCups(selectedCenter, finished: false);
  } else {
    return [];
  }

});

final cupsProvider = FutureProvider<List<CupModel>>((ref) async {
  final bookingService = BookingService();
  final isAdmin = ref.watch(isAdminProvider);
  final selectedCenter = ref.watch(selectedCenterNameProvider);

  if (isAdmin) {
    final user = ref.watch(centerUserProvider);
    return await bookingService.getCups(user.youthCenterName);
  }

  if (selectedCenter != null) {
    return await bookingService.getCups(selectedCenter);
  }

  return [];
});

final filteredCupsProvider = FutureProvider<List<CupModel>>((ref) async {
  final cupProvider = ref.watch(activeCupsProvider);
  final selectedCenter = ref.watch(selectedCenterNameProvider);

  return cupProvider.when(
    data: (cups) {
      return cups.where((cup) => cup.youthCenterId == selectedCenter).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

final matchesProvider = FutureProvider<List<MatchModel>>((ref) async {
  final isAdmin = ref.watch(isAdminProvider);
  final filteredCupsAsync = !isAdmin ? ref.watch(filteredCupsProvider) : ref.watch(activeCupsProvider);

  return filteredCupsAsync.when(
    data: (cups) {
      log( "Fetching matches for ${cups.length} cups");
      List<MatchModel> matches = [];
      for (final cup in cups) {
        for (final match in cup.matches) {
          matches.add(MatchModel.fromMap(match));
        }
      }
      log( "Total matches found: ${matches.length}");
      return matches;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
