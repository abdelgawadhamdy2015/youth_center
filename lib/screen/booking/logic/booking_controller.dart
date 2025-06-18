import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/core/service/data_base_service.dart';
import 'package:youth_center/screen/home/logic/home_controller.dart';

final dataBaseService = DataBaseService();
final addBookingProvider =
    StateNotifierProvider<BookingController, AsyncValue<void>>((ref) {
      return BookingController(ref);
    });

class BookingController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  BookingController(this._ref) : super(const AsyncData(null));

  Future<void> addBooking(BookingModel booking) async {
    state = const AsyncLoading();
    try {
      await dataBaseService.addBooking(booking);
      _ref.invalidate(bookingsProvider);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    state = const AsyncLoading();
    try {
      await dataBaseService.deleteBooking(bookingId);
      _ref.invalidate(bookingsProvider);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> updateBooking(BookingModel booking) async {
    state = const AsyncLoading();
    try {
      await dataBaseService.updateBooking(booking);
      _ref.invalidate(bookingsProvider);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> requestBooking(BookingModel booking) async {
    state = const AsyncLoading();
    try {
      final updateBooking = booking.copyWith(status: 0);
      await dataBaseService.requestBooking(updateBooking);
      _ref.invalidate(bookingRequestsProvider);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> acceptRequestBooking(BookingModel booking) async {
    state = const AsyncLoading();
    try {
      final updatedBooking = booking.copyWith(status: 1);
      await dataBaseService.addBooking(updatedBooking);

      await dataBaseService.updateRequest(updatedBooking);
      _ref.invalidate(bookingsProvider);
      _ref.invalidate(bookingRequestsProvider);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> rejectRequestBooking(BookingModel booking) async {
    state = const AsyncLoading();
    try {
      final updatedBooking = booking.copyWith(status: 2);
      await dataBaseService.updateRequest(updatedBooking);
      _ref.invalidate(bookingsProvider);
      _ref.invalidate(bookingRequestsProvider);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> deleteRequestBooking(BookingModel booking) async {
    await dataBaseService.deleteRequest(booking.id!);
  }
}

final availableTimesProvider = FutureProvider.family<
  List<String>,
  (String centerName, String day)
>((ref, args) async {
  final (centerName, day) = args;

  final bookings = await dataBaseService.getBookingsByCenter(centerName);
  final bookedTimes = bookings.where((booking) => booking.day == day).toList();

  if (bookedTimes.isEmpty) {
    return HelperMethods.generateTimes();
  }
  final allTimes = HelperMethods.generateTimes();
  return allTimes.where((time) => !isTimeBooked(time, bookedTimes)).toList();
});

bool isTimeBooked(String time, List<BookingModel> bookings) {
  final timeDate = HelperMethods.parseTime(time);
  for (final booking in bookings) {
    final bookingStart = HelperMethods.parseTime(booking.timeStart);
    final bookingEnd = HelperMethods.parseTime(booking.timeEnd);
    if (bookingStart != null &&
        bookingEnd != null &&
        timeDate != null &&
        timeDate.isAfter(bookingStart) &&
        timeDate.isBefore(bookingEnd)) {
      return true;
    }
  }
  return false;
}

final bookingRequestsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final isAdmin = ref.watch(isAdminProvider);
  if (isAdmin) {
    return await dataBaseService.getRequestsByCenter();
  } else {
    return await dataBaseService.getRequestsByUser(
      ref.watch(centerUserProvider).asData?.value?.id ?? "",
    );
  }
});
