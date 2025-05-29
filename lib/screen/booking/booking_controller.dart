import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/screen/home/booking_service.dart';
import 'package:youth_center/screen/home/home_booking_controller.dart';

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
      await BookingService().addBooking(booking);
      _ref.invalidate(bookingsProvider);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    state = const AsyncLoading();
    try {
      // Implement cancellation logic here
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
}
