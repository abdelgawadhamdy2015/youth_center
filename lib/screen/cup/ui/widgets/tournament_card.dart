import 'package:flutter/material.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/tournament_model.dart';
import 'package:youth_center/screen/cup/ui/widgets/create_tournament_screen.dart';

class TournamentCard extends StatelessWidget {
  final TournamentModel tournament;
  const TournamentCard({super.key, required this.tournament});

  @override
  Widget build(BuildContext context) {
    final statusData = _getStatus(context);
    final Color statusColor = statusData['color'] as Color;
    final String status = statusData['status'] as String;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tournament.name!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    MyConstants.dateFormat.format(tournament.startDate!),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.people_outline,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    getDeadLineMessage(context),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),

              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              NewCreateTournament(tournament: tournament),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF1E40AF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
                child: Text(
                  S.of(context).viewDetails,
                  style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, Object> _getStatus(BuildContext context) {
    if (tournament.startDate != null &&
        DateTime.now().isBefore(tournament.startDate!)) {
      return {
        'color': const Color(0xFF1E40AF),
        'status': S.of(context).upComming,
      };
    } else if (tournament.startDate != null &&
        DateTime.now().isAfter(tournament.startDate!) &&
        DateTime.now().isBefore(tournament.endDate!)) {
      return {
        'color': const Color(0xFF10B981),
        'status': S.of(context).onGoing,
      };
    } else if (tournament.endDate != null &&
        DateTime.now().isAfter(tournament.endDate!)) {
      return {
        'color': const Color(0xFF6B7280),
        'status': S.of(context).completed,
      };
    } else {
      return {'color': const Color(0xFF1E40AF), 'status': MyConstants.ongoing};
    }
  }

  getDeadLineMessage(BuildContext context) {
    if (tournament.registrationDeadline!.isAfter(DateTime.now())) {
      return '${S.of(context).registrationDeadline} : ${MyConstants.dateFormat.format(tournament.registrationDeadline ?? DateTime.now())}';
    }
    return S.of(context).registeredClosed;
  }
}
