import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/shared_pref_helper.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/models/match_model.dart';
import 'package:youth_center/models/tournament.dart';
import 'package:youth_center/models/user_model.dart';
import 'package:youth_center/models/youth_center_model.dart';
import 'package:youth_center/core/service/data_base_service.dart';

final centerUserProvider = FutureProvider<CenterUser?>((ref) async {
  return await DataBaseService().getCurrentUser();
});

final isAdminProvider = Provider<bool>((ref) {
  final userAsync = ref.watch(centerUserProvider);
  return userAsync.maybeWhen(
    data: (user) {
      MyConstants.centerUser = user;
      return user?.admin ?? false;
    },
    orElse: () => false,
  );
});

final youthCentersProvider = FutureProvider<List<YouthCenterModel>>((
  ref,
) async {
  final service = DataBaseService();

  final centers = await service.getAllCenters();
  return centers;
});

final youthCenterNamesProvider = FutureProvider<List<String>>((ref) async {
  List<String> centerNames = await SharedPrefHelper.getListString(
    MyConstants.prefCenterNames,
  );
  if (centerNames.isEmpty) {
    final centers = await DataBaseService().getAllCenters();
    centerNames = centers.map((e) => e.name).toList();
    await SharedPrefHelper.setData(MyConstants.prefCenterNames, centerNames);
  }
  return centerNames;
});

final selectedCenterNameProvider = StateProvider<String?>((ref) {
  return MyConstants.centerUser?.youthCenterName;
});

final selectedDayProvider = StateProvider<String>((ref) {
  return DateFormat("EEE").format(DateTime.now()); // الأحد، الإثنين، إلخ
});

final bookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final bookingService = DataBaseService();

  final isAdmin = ref.watch(isAdminProvider);
  final selectedCenter = ref.watch(selectedCenterNameProvider);
  final user =
      MyConstants.centerUser ?? ref.watch(centerUserProvider).asData?.value;

  if (isAdmin) {
    return bookingService.getBookingsByCenter(user?.youthCenterName ?? '');
  }

  if (selectedCenter != null && selectedCenter.isNotEmpty) {
    return bookingService.getBookingsByCenter(selectedCenter);
  }

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

final activeCupsProvider = FutureProvider<List<Tournament>>((ref) async {
  final bookingService = DataBaseService();
  final isAdmin = ref.watch(isAdminProvider);
  final selectedCenter = ref.watch(selectedCenterNameProvider);

  if (isAdmin) {
    final user = ref.watch(centerUserProvider).asData?.value;
    return await bookingService.getCups(
      user?.youthCenterName ?? '',
      finished: false,
    );
  } else if (selectedCenter != null) {
    return await bookingService.getCups(selectedCenter, finished: false);
  } else {
    return [];
  }
});

final cupsProvider = FutureProvider<List<Tournament>>((ref) async {
  final bookingService = DataBaseService();
  final isAdmin = ref.watch(isAdminProvider);
  final selectedCenter = ref.watch(selectedCenterNameProvider);

  if (isAdmin) {
    final user = ref.watch(centerUserProvider).asData?.value;
    log("${user?.youthCenterName}");
    return await bookingService.getCups(user?.youthCenterName ?? '');
  }

  if (selectedCenter != null) {
    return await bookingService.getCups(selectedCenter);
  }

  return [];
});

final filteredCupsProvider = FutureProvider<List<Tournament>>((ref) async {
  final cupProvider = ref.watch(activeCupsProvider);
  final selectedCenter = ref.watch(selectedCenterNameProvider);

  return cupProvider.when(
    data: (cups) {
      return cups.where((cup) => cup.location == selectedCenter).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

final matchesProvider = FutureProvider<List<MatchModel>>((ref) async {
  final isAdmin = ref.watch(isAdminProvider);
  final filteredCupsAsync =
      !isAdmin
          ? ref.watch(filteredCupsProvider)
          : ref.watch(activeCupsProvider);

  return filteredCupsAsync.when(
    data: (cups) {
      log("Fetching matches for ${cups.length} cups");
      List<MatchModel> matches = [];
      for (final cup in cups) {
        if (cup.matches != null) {
          for (final match in cup.matches!) {
            matches.add(MatchModel.fromMap(match));
          }
        }
      }
      log("Total matches found: ${matches.length}");
      return matches;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
