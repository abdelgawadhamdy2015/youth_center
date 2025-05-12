// booking_card.dart
import 'package:flutter/material.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youth_center/screen/booking/update_booking.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onTap;

  const BookingCard({super.key, required this.booking, this.onTap});
  onClick(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return UpdateBooking(booking: booking);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lang =S.of(context);
    return GestureDetector(
      onTap: () => onClick(context),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.name,
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${lang.from} ${booking.timeStart} ${lang.to} ${booking.timeEnd}",
                    style: GoogleFonts.tajawal(),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.sports_soccer, size: 30, color: Colors.blueGrey),
                  Text(
                    booking.mobile,
                    style: GoogleFonts.tajawal(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
