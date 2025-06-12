import 'package:flutter/material.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/models/tournament_model.dart';

class FormControllers {
  final nameController = TextEditingController(text: 'Summer Youth Cup');
  final descriptionController = TextEditingController(
    text:
        'The Summer Youth Cup is an annual tournament designed to bring together young athletes...',
  );
  final startDateController = TextEditingController(text: '2025-06-15');
  final endDateController = TextEditingController(text: '2025-07-15');
  final regDeadlineController = TextEditingController(text: '2025-06-10');
  final teamsController = TextEditingController(text: '16');
  final halfDurationController = TextEditingController(text: '30');
  final halftimeController = TextEditingController(text: '10');
  final winPointsController = TextEditingController(text: '3');
  final drawPointsController = TextEditingController(text: '1');
  final lossPointsController = TextEditingController(text: '0');
  final minPlayersController = TextEditingController(text: '7');
  final maxPlayersController = TextEditingController(text: '11');
  final customRulesController = TextEditingController(
    text:
        '1. All players must wear shin guards.\n2. Teams must arrive 15 minutes before kickoff.',
  );

  void initFromTournament(TournamentModel tournament) {
    nameController.text = tournament.name ?? '';
    descriptionController.text = tournament.description ?? '';
    startDateController.text = MyConstants.dateFormat.format(
      tournament.startDate ?? DateTime.now(),
    );
    endDateController.text = MyConstants.dateFormat.format(
      tournament.endDate ?? DateTime.now(),
    );
    regDeadlineController.text = MyConstants.dateFormat.format(
      tournament.registrationDeadline ?? DateTime.now(),
    );
    teamsController.text = tournament.numberOfTeams?.toString() ?? '16';
    halfDurationController.text = tournament.minutesPerHalf?.toString() ?? '30';
    halftimeController.text = tournament.halftimeMinutes?.toString() ?? '10';
    winPointsController.text = tournament.winPoints?.toString() ?? '3';
    drawPointsController.text = tournament.drawPoints?.toString() ?? '1';
    lossPointsController.text = tournament.lossPoints?.toString() ?? '0';
    minPlayersController.text = tournament.minPlayers?.toString() ?? '7';
    maxPlayersController.text = tournament.maxPlayers?.toString() ?? '11';
    customRulesController.text = tournament.customRules ?? '';
  }

  void reset() {
    nameController.clear();
    descriptionController.clear();
    startDateController.text = '2023-06-15';
    endDateController.text = '2023-07-15';
    regDeadlineController.text = '2023-06-10';
    teamsController.text = '16';
    halfDurationController.text = '30';
    halftimeController.text = '10';
    winPointsController.text = '3';
    drawPointsController.text = '1';
    lossPointsController.text = '0';
    minPlayersController.text = '7';
    maxPlayersController.text = '11';
    customRulesController.text =
        '1. All players must wear shin guards.\n2. Teams must arrive 15 minutes before kickoff.';
  }

  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    regDeadlineController.dispose();
    teamsController.dispose();
    halfDurationController.dispose();
    halftimeController.dispose();
    winPointsController.dispose();
    drawPointsController.dispose();
    lossPointsController.dispose();
    minPlayersController.dispose();
    maxPlayersController.dispose();
    customRulesController.dispose();
  }
}
