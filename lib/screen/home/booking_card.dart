// booking_card.dart
import 'package:flutter/material.dart';
import 'package:youth_center/models/booking_model.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onTap;

  const BookingCard({super.key, required this.booking, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: const Border.symmetric(
          vertical: BorderSide(color: Colors.blueAccent, width: 5),
          horizontal: BorderSide(color: Colors.purple, width: 5),
        ),
        color: Colors.deepOrangeAccent,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(booking.name),
              const SizedBox(width: 10),
              const Icon(Icons.sports_baseball),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text("from ${booking.timeStart}"),
                  Text("to ${booking.timeEnd}"),
                ],
              ),
              const SizedBox(width: 10),
              Text(booking.mobile.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
