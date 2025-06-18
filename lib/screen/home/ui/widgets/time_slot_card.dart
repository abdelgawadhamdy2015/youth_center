import 'package:flutter/material.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/booking_model.dart';

class TimeSlotCard extends StatelessWidget {
  final BookingModel bookingModel;
  final bool? isAvailable;
  const TimeSlotCard({super.key, required this.bookingModel, this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              (isAvailable ?? false)
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${bookingModel.timeStart} - ${bookingModel.timeEnd}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      (isAvailable ?? false)
                          ? const Color(0xFFD1FAE5)
                          : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  S.of(context).booked,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        (isAvailable ?? false)
                            ? const Color(0xFF065F46)
                            : const Color(0xFFB91C1C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            bookingModel.youthCenterId,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

          Text(
            '${S.of(context).bookedBy} ${bookingModel.name}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
