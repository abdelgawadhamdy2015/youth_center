import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/models/youth_center_model.dart';


class BookingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<BookingModel>> getAllBookings() async {
    final snapshot = await _db.collection("Bookings").get();
    return snapshot.docs.map((e) => BookingModel.fromSnapshot(e)).toList();
  }

  Future<List<BookingModel>> getBookingsByCenter(String centerName) async {
    final snapshot = await _db
        .collection("Bookings")
        .where("youthCenterId", isEqualTo: centerName)
        .get();
    return snapshot.docs.map((e) => BookingModel.fromSnapshot(e)).toList();
  }

  Future<List<YouthCenterModel>> getAllCenters() async {
    final snapshot = await _db.collection("youthCenters").get();
    return snapshot.docs.map((e) => YouthCenterModel.fromSnapshot(e)).toList();
  }
}
