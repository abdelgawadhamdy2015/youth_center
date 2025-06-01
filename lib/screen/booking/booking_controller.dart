import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/core/service/data_base_service.dart';
import 'package:youth_center/screen/home/home_controller.dart';

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
      await DataBaseService().addBooking(booking);
      _ref.invalidate(bookingsProvider);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    state = const AsyncLoading();
    try {
      await DataBaseService().deleteBooking(bookingId);
      _ref.invalidate(bookingsProvider);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> updateBooking(BookingModel booking) async {
    state = const AsyncLoading();
    try {
      await DataBaseService().updateBooking(booking);
      _ref.invalidate(bookingsProvider);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> requestBooking(BookingModel booking) async {
    state = const AsyncLoading();
    try {
      await DataBaseService().requestBooking(booking);
      _ref.invalidate(bookingsProvider);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

}

final availableTimesProvider = FutureProvider.family<List<String>, (String centerName, String day)>((ref, args) async {
  final (centerName, day) = args;

  final bookings = await DataBaseService().getBookingsByCenter(centerName);
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
    if (bookingStart != null && bookingEnd != null && timeDate != null && timeDate.isAfter(bookingStart) && timeDate.isBefore(bookingEnd)) {
      return true;
    }
  }
  return false;
}

  

