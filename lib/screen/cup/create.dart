import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/core/widgets/body_container.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/core/widgets/header.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/match_model.dart';
import 'package:youth_center/models/tournament.dart';
import 'package:youth_center/screen/cup/cups_controller.dart';
import 'package:youth_center/screen/cup/cups_screen.dart';
import 'package:youth_center/screen/cup/group_card.dart';
import 'package:youth_center/screen/home/home_controller.dart';
import 'package:youth_center/screen/home/home_screen.dart';
import 'package:youth_center/screen/home/match_card.dart';

class CreateTournamentScreen extends ConsumerStatefulWidget {
  const CreateTournamentScreen({super.key, this.tournament});
  final Tournament? tournament;

  @override
  ConsumerState<CreateTournamentScreen> createState() =>
      _CreateTournamentScreenState();
}

class _CreateTournamentScreenState
    extends ConsumerState<CreateTournamentScreen> {
  int _currentStep = 0;
  bool _showPreview = false;
  S lang = S();

  final _formKey = GlobalKey<FormState>();
  bool isInfoExpanded = false;
  bool formatisExpanded = false;

  bool isTeamExpanded = false;

  bool isRoulesExpanded = false;

  // Form controllers from CreateTournamentScreen
  final _nameController = TextEditingController(text: 'Summer Youth Cup');
  final _descriptionController = TextEditingController(
    text:
        'The Summer Youth Cup is an annual tournament designed to bring together young athletes...',
  );
  final _startDateController = TextEditingController(text: '2025-06-15');
  final _endDateController = TextEditingController(text: '2025-07-15');
  final _regDeadlineController = TextEditingController(text: '2025-06-10');
  final _teamsController = TextEditingController(text: '16');
  final _halfDurationController = TextEditingController(text: '30');
  final _halftimeController = TextEditingController(text: '10');
  final _winPointsController = TextEditingController(text: '3');
  final _drawPointsController = TextEditingController(text: '1');
  final _lossPointsController = TextEditingController(text: '0');
  final _minPlayersController = TextEditingController(text: '7');
  final _maxPlayersController = TextEditingController(text: '11');
  final _customRulesController = TextEditingController(
    text:
        '1. All players must wear shin guards.\n2. Teams must arrive 30 minutes before kickoff.',
  );

  // Dropdown and checkbox values from CreateTournamentScreen
  late String _format;
  String _substitutionRules = '3 Substitutions';
  String _scheduling = 'Auto-generate schedule';
  String _breakBetweenMatches = '15 minutes';
  bool _offsideRule = true;
  bool _cardSystem = true;
  bool _extraTime = true;
  bool _penaltyShootout = true;
  final List<bool> _ageGroups = [true, true, true, false];
  List<List<String>> groupedTeams = List.generate(8, (_) => []);
  // Fields from AddCupScreen
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final List<TextEditingController> _teamControllers = [];
  final List<String> _teams = [];
  final List<List<String>> _groups = [];
  final List<dynamic> _matches = [];
  final List<dynamic> _jsonMatches = [];
  bool _randomDistribution = false;
  bool _showGroups = false;
  bool _showMatches = false;
  final double _spacing = 16.0;

  @override
  void initState() {
    super.initState();

    if (widget.tournament != null) {
      initData(widget.tournament!);
    } else {
      _initializeTeamControllers();
    }
  }

  initData(Tournament tournament) {
    _nameController.text = tournament.name!;
    _descriptionController.text = tournament.description ?? "";
    _startDateController.text = MyConstants.dateFormat.format(
      tournament.startDate ?? DateTime.now(),
    );
    _endDateController.text = MyConstants.dateFormat.format(
      tournament.endDate ?? DateTime.now(),
    );
    _regDeadlineController.text = MyConstants.dateFormat.format(
      tournament.registrationDeadline ?? DateTime.now(),
    );
    _teamsController.text = tournament.numberOfTeams?.toString() ?? '8';
    _halfDurationController.text =
        tournament.minutesPerHalf?.toString() ?? '30';
    _halftimeController.text = tournament.halftimeMinutes?.toString() ?? '10';
    _winPointsController.text = tournament.winPoints?.toString() ?? '3';
    _drawPointsController.text = tournament.drawPoints?.toString() ?? '1';
    _lossPointsController.text = tournament.lossPoints?.toString() ?? '0';
    _minPlayersController.text = tournament.minPlayers?.toString() ?? '7';
    _maxPlayersController.text = tournament.maxPlayers?.toString() ?? '11';
    _customRulesController.text = tournament.customRules ?? '';
    _format = tournament.format ?? lang.groupStageKnockout;
    _substitutionRules =
        tournament.substitutionRules ?? lang.threeSubstitutions;
    _offsideRule = tournament.offsideRule ?? true;
    _cardSystem = tournament.cardSystem ?? true;
    _extraTime = tournament.extraTime ?? true;
    _penaltyShootout = tournament.penaltyShootout ?? true;
    _scheduling = tournament.scheduling ?? 'Auto-generate schedule';
    _breakBetweenMatches = tournament.breakBetweenMatches ?? '15 minutes';
    // Age groups (assuming tournament has a List<String> ageGroups property)
    if (tournament.ageGroups != null) {
      _ageGroups[0] = tournament.ageGroups!.contains('U12');
      _ageGroups[1] = tournament.ageGroups!.contains('U14');
      _ageGroups[2] = tournament.ageGroups!.contains('U16');
      _ageGroups[3] = tournament.ageGroups!.contains('U18');
    }
    // Teams
    _teams.clear();
    if (tournament.teams != null) {
      _teams.addAll(List<String>.from(tournament.teams!));
      _teamControllers.clear();
      for (var team in _teams) {
        _teamControllers.add(TextEditingController(text: team));
      }
      // If less teams than controllers, fill up
      while (_teamControllers.length <
          (int.tryParse(_teamsController.text) ?? 8)) {
        _teamControllers.add(TextEditingController());
      }
      if (_teams.isNotEmpty) {
        _collectTeams();
        if (tournament.matches != null && tournament.matches!.isNotEmpty) {
          _generateMatches();
          _showMatches = true;
        }
      }
    } else {
      _initializeTeamControllers();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _regDeadlineController.dispose();
    _teamsController.dispose();
    _halfDurationController.dispose();
    _halftimeController.dispose();
    _winPointsController.dispose();
    _drawPointsController.dispose();
    _lossPointsController.dispose();
    _minPlayersController.dispose();
    _maxPlayersController.dispose();
    _customRulesController.dispose();
    for (var controller in _teamControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeTeamControllers() {
    _teamControllers.clear();
    final teamCount = int.tryParse(_teamsController.text) ?? 8;
    for (int i = 0; i < teamCount; i++) {
      _teamControllers.add(TextEditingController());
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(controller.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = MyConstants.dateFormat.format(picked);
      });
    }
  }

  void _updateTeamCount(int change) {
    final updatedCount = (int.tryParse(_teamsController.text) ?? 8) + change;
    if (updatedCount >= 4 && updatedCount <= 32) {
      setState(() {
        _teamsController.text = updatedCount.toString();
        _initializeTeamControllers();
        _teams.clear();
        _matches.clear();
        _groups.clear();
        _showGroups = false;
        _showMatches = false;
      });
    }
  }

  void _toggleDistributionMode() {
    setState(() => _randomDistribution = !_randomDistribution);
  }

  void _collectTeams() {
    _teams.clear();
    for (var controller in _teamControllers) {
      if (controller.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(lang.enterNames)));
        return;
      }
      _teams.add(controller.text.trim());
    }
    _distributeTeams();
    setState(() => _showGroups = true);
  }

  void _distributeTeams() {
    _groups.clear();
    final teams = List<String>.from(_teams);
    if (_randomDistribution) teams.shuffle();
    for (int i = 0; i < teams.length; i += 4) {
      _groups.add(
        teams.sublist(i, (i + 4 < teams.length) ? i + 4 : teams.length),
      );
    }
  }

  void _generateMatches() {
    _matches.clear();
    _jsonMatches.clear();
    for (var group in _groups) {
      for (int i = 0; i < group.length; i++) {
        for (int j = i + 1; j < group.length; j++) {
          final match = MatchModel(
            team1: group[i],
            team2: group[j],
            cupStartDate: 
              DateTime.parse(_startDateController.text),
            
            teem1Score: 0,
            teem2Score: 0,
            cupName: _nameController.text,
            cupGroup: '${lang.group} ${_groups.indexOf(group) + 1}',
          );
          _matches.add(match);
          _jsonMatches.add(match.toJson());
        }
      }
    }
    setState(() => _showMatches = true);
  }

  void _resetForm() {
    setState(() {
      if (_showMatches) {
        _matches.clear();
        _jsonMatches.clear();
        _showMatches = false;
      } else if (_showGroups) {
        _groups.clear();
        _showGroups = false;
      } else {
        _teams.clear();
        _teamsController.text = '8';
        _initializeTeamControllers();
        _nameController.clear();
        _descriptionController.clear();
        _startDateController.clear();
        _endDateController.clear();
        _regDeadlineController.clear();
      }
    });
  }

  Future<void> _publishTournament() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_showGroups) {
      _collectTeams();
      return;
    } else if (!_showMatches) {
      _generateMatches();
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final userId = MyConstants.centerUser!.id!;
      final tournament = Tournament(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        logoUrl: null,
        startDate: DateTime.parse(_startDateController.text),
        endDate: DateTime.parse(_endDateController.text),
        registrationDeadline: DateTime.parse(_regDeadlineController.text),
        location: MyConstants.centerUser!.youthCenterName,
        numberOfTeams: int.parse(_teamsController.text),
        format: _format,
        minutesPerHalf: int.parse(_halfDurationController.text),
        halftimeMinutes: int.parse(_halftimeController.text),
        winPoints: int.parse(_winPointsController.text),
        drawPoints: int.parse(_drawPointsController.text),
        lossPoints: int.parse(_lossPointsController.text),
        minPlayers: int.parse(_minPlayersController.text),
        maxPlayers: int.parse(_maxPlayersController.text),
        substitutionRules: _substitutionRules,
        offsideRule: _offsideRule,
        cardSystem: _cardSystem,
        extraTime: _extraTime,
        penaltyShootout: _penaltyShootout,
        customRules: _customRulesController.text,
        scheduling: _scheduling,
        breakBetweenMatches: _breakBetweenMatches,
        createdAt: DateTime.now(),
        createdBy: userId,
        isPublished: true,
        teams: _teams, // Added from AddCupScreen
        matches: _jsonMatches, // Added from AddCupScreen
      );

      await ref.read(cupsControllerProvider).createCup(tournament);

      Navigator.pop(context);

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Color(0xFF10B981),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    lang.tournamentCreated,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lang.tournamentCreatedMsg,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(lang.goToTournaments),
                  ),
                ],
              ),
            ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error publishing tournament: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _saveAsIncommingTournament() {
    log(widget.tournament!.id!);
    final tournament = Tournament(
      id:
          widget.tournament?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      description: _descriptionController.text,
      logoUrl: null,
      startDate: DateTime.parse(_startDateController.text),
      endDate: DateTime.parse(_endDateController.text),
      registrationDeadline: DateTime.parse(_regDeadlineController.text),
      location: MyConstants.centerUser!.youthCenterName,
      numberOfTeams: int.parse(_teamsController.text),
      format: _format,
      minutesPerHalf: int.parse(_halfDurationController.text),
      halftimeMinutes: int.parse(_halftimeController.text),
      winPoints: int.parse(_winPointsController.text),
      drawPoints: int.parse(_drawPointsController.text),
      lossPoints: int.parse(_lossPointsController.text),
      minPlayers: int.parse(_minPlayersController.text),
      maxPlayers: int.parse(_maxPlayersController.text),
      substitutionRules: _substitutionRules,
      offsideRule: _offsideRule,
      cardSystem: _cardSystem,
      extraTime: _extraTime,
      penaltyShootout: _penaltyShootout,
      customRules: _customRulesController.text,
      scheduling: _scheduling,
      breakBetweenMatches: _breakBetweenMatches,
      createdAt: DateTime.now(),
      createdBy: MyConstants.centerUser!.id!,
      isPublished: false,
      teams: _teams,
      matches: _jsonMatches,
    );
    if (_formKey.currentState!.validate()) {
      if (widget.tournament != null) {
        ref
            .read(cupsControllerProvider)
            .updateCup(tournament)
            .then((tournament) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(lang.tournamentCreatedMsg)),
              );
              ref.invalidate(cupsControllerProvider);
              ref.invalidate(activeCupsProvider);
              ref.invalidate(cupsProvider);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return HomeScreen();
                  },
                ),
              );
            })
            .catchError((error) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(error.toString())));
            });
      } else {
        ref
            .read(cupsControllerProvider)
            .createCup(tournament)
            .then((tournament) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(lang.tournamentCreatedMsg)),
              );
            })
            .catchError((error) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(error.toString())));
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    lang = S.of(context);
    _format = lang.groupStageKnockout;

    return Scaffold(
      body: GradientContainer(
        child: SingleChildScrollView(
          // padding: EdgeInsets.only(bottom: SizeConfig.screenHeight! * .2),
          child: Column(
            children: [
              Header(
                title:
                    widget.tournament != null
                        ? lang.tournamentPreview
                        : lang.createCup,
              ),
              BodyContainer(
                height: SizeConfig.screenHeight! * .7,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildProgressIndicator(),
                        HelperMethods.verticalSpace(.03),
                        _buildBasicInfoSection(),
                        HelperMethods.verticalSpace(.01),
                        _buildFormatSection(),
                        HelperMethods.verticalSpace(.01),
                        _buildRulesSection(),
                        HelperMethods.verticalSpace(.01),
                        _buildTeamConfigurationSection(),
                        HelperMethods.verticalSpace(.01),
                        _buildPreviewSection(),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _buildProgressStep(1, _currentStep >= 0),
        _buildProgressLine(_currentStep >= 1),
        _buildProgressStep(2, _currentStep >= 1),
        _buildProgressLine(_currentStep >= 2),
        _buildProgressStep(3, _currentStep >= 2),
        _buildProgressLine(_currentStep >= 3),
        _buildProgressStep(4, _currentStep >= 3),
        _buildProgressLine(_currentStep >= 4),
        _buildProgressStep(5, _currentStep >= 4),
      ],
    );
  }

  Widget _buildProgressStep(int step, bool isActive) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1E40AF) : Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? const Color(0xFF1E40AF) : Colors.grey[300],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          isInfoExpanded = isExpanded;
        });
      },
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(
                lang.basicInformation,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // trailing: Icon(
              //   isExpanded ? Icons.expand_less : Icons.expand_more,
              //   color: Colors.grey[600],
              // ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: ' ${lang.cupName}*',
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    prefixIcon: const Icon(Icons.emoji_events),
                  ),
                  validator:
                      (value) =>
                          value?.isEmpty ?? true ? lang.enterCupName : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.grey[800],
                        elevation: 0,
                      ),
                      child: const Text('Upload Logo'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Recommended size: 200x200px, Max: 2MB',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _startDateController,
                        decoration: InputDecoration(
                          labelText: ' ${lang.startDate}*',
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context, _startDateController),
                        validator:
                            (value) =>
                                value?.isEmpty ?? true
                                    ? lang.enterStartTime
                                    : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _endDateController,
                        decoration: InputDecoration(
                          labelText: '${lang.endDate}*',
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context, _endDateController),
                        validator:
                            (value) =>
                                value?.isEmpty ?? true
                                    ? lang.enterEndTime
                                    : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _regDeadlineController,
                  decoration: InputDecoration(
                    labelText: '${lang.registrationDeadline}*',
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, _regDeadlineController),
                  validator:
                      (value) =>
                          value?.isEmpty ?? true
                              ? lang.registrationDeadline
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: lang.description,
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
          isExpanded: isInfoExpanded,
        ),
      ],
    );
  }

  Widget _buildFormatSection() {
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          formatisExpanded = isExpanded;
        });
      },
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(
                lang.tournamentFormat,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextFormField(
                  controller: _teamsController,
                  decoration: InputDecoration(
                    labelText: '${lang.numberOfTeams}*',
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                  ),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value?.isEmpty ?? true
                              ? lang.enterNumberOfTeams
                              : null,
                  onChanged: (value) {
                    setState(() {
                      _initializeTeamControllers();
                      _teams.clear();
                      _groups.clear();
                      _showGroups = false;
                      _showMatches = false;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  '${lang.ageGroups}*',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3,
                  children: [
                    _buildCheckboxTile(
                      'Under 12',
                      _ageGroups[0],
                      (value) => setState(() => _ageGroups[0] = value!),
                    ),
                    _buildCheckboxTile(
                      'Under 14',
                      _ageGroups[1],
                      (value) => setState(() => _ageGroups[1] = value!),
                    ),
                    _buildCheckboxTile(
                      'Under 16',
                      _ageGroups[2],
                      (value) => setState(() => _ageGroups[2] = value!),
                    ),
                    _buildCheckboxTile(
                      'Under 18',
                      _ageGroups[3],
                      (value) => setState(() => _ageGroups[3] = value!),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _format,
                  decoration: InputDecoration(
                    labelText: '${lang.tournamentFormat}*',
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: lang.groupStageKnockout,
                      child: Text(lang.groupStageKnockout),
                    ),
                    DropdownMenuItem(
                      value: lang.knockoutOnly,
                      child: Text(lang.knockoutOnly),
                    ),
                    DropdownMenuItem(
                      value: lang.leagueFormat,
                      child: Text(lang.leagueFormat),
                    ),
                    DropdownMenuItem(
                      value: lang.roundRobin,
                      child: Text(lang.roundRobin),
                    ),
                  ],
                  onChanged: (value) => setState(() => _format = value!),
                  validator:
                      (value) =>
                          value?.isEmpty ?? true ? lang.selectFormat : null,
                ),
                const SizedBox(height: 16),
                Text(
                  lang.matchDuration,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _halfDurationController,
                        decoration: InputDecoration(
                          labelText: lang.minutesPerHalf,
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _halftimeController,
                        decoration: InputDecoration(
                          labelText: lang.halftimeMinutes,
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  lang.pointsSystem,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _winPointsController,
                        decoration: InputDecoration(
                          labelText: lang.win,
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _drawPointsController,
                        decoration: InputDecoration(
                          labelText: lang.draw,
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _lossPointsController,
                        decoration: InputDecoration(
                          labelText: lang.loss,
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          isExpanded: formatisExpanded,
        ),
      ],
    );
  }

  Widget _buildRulesSection() {
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          isRoulesExpanded = isExpanded;
        });
      },
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(
                lang.rulesSettings,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  lang.teamSizeLimits,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _minPlayersController,
                        decoration: InputDecoration(
                          labelText: lang.minPlayers,
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _maxPlayersController,
                        decoration: InputDecoration(
                          labelText: lang.maxPlayers,
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _substitutionRules,
                  decoration: InputDecoration(
                    labelText: lang.substitutionRules,
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: lang.threeSubstitutions,
                      child: Text(lang.threeSubstitutions),
                    ),
                    DropdownMenuItem(
                      value: lang.fiveSubstitutions,
                      child: Text(lang.fiveSubstitutions),
                    ),
                    DropdownMenuItem(
                      value: lang.rollingSubstitutions,
                      child: Text(lang.rollingSubstitutions),
                    ),
                    DropdownMenuItem(
                      value: lang.unlimitedSubstitutions,
                      child: Text(lang.unlimitedSubstitutions),
                    ),
                  ],
                  onChanged:
                      (value) => setState(() => _substitutionRules = value!),
                ),
                const SizedBox(height: 16),
                Text(
                  lang.matchRules,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    _buildCheckboxTile(
                      lang.offsideRule,
                      _offsideRule,
                      (value) => setState(() => _offsideRule = value!),
                    ),
                    _buildCheckboxTile(
                      lang.cardSystem,
                      _cardSystem,
                      (value) => setState(() => _cardSystem = value!),
                    ),
                    _buildCheckboxTile(
                      lang.extraTime,
                      _extraTime,
                      (value) => setState(() => _extraTime = value!),
                    ),
                    _buildCheckboxTile(
                      lang.penaltyShootout,
                      _penaltyShootout,
                      (value) => setState(() => _penaltyShootout = value!),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _customRulesController,
                  decoration: InputDecoration(
                    labelText: lang.customRules,
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
          isExpanded: isRoulesExpanded,
        ),
      ],
    );
  }

  Widget _buildTeamConfigurationSection() {
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          isTeamExpanded = isExpanded;
        });
      },
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(
                lang.teamConfiguration,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
          body: Padding(
            padding: EdgeInsets.all(_spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTeamCountSelector(),
                HelperMethods.verticalSpace(.02),
                _buildDistributionToggle(),
                HelperMethods.verticalSpace(.02),
                if (!_showGroups) _buildTeamInputs(),
                if (_showGroups || (_teams.isNotEmpty)) _buildGroupsDisplay(),
                if (_showMatches || (_matches.isNotEmpty))
                  _buildMatchesDisplay(),
              ],
            ),
          ),
          isExpanded: isTeamExpanded,
        ),
      ],
    );
  }

  Widget _buildTeamCountSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(lang.numberOfTeams),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => _updateTeamCount(-4),
            ),
            Text(_teamsController.text),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _updateTeamCount(4),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDistributionToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(lang.distributionMode),
        ToggleButtons(
          isSelected: [_randomDistribution, !_randomDistribution],
          onPressed: (_) => _toggleDistributionMode(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(lang.random),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(lang.manual),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTeamInputs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lang.enterNames),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: int.tryParse(_teamsController.text) ?? 8,
          itemBuilder:
              (_, index) => TextFormField(
                controller: _teamControllers[index],
                decoration: InputDecoration(
                  labelText: "${lang.team} ${index + 1}",
                  border: const OutlineInputBorder(),
                ),
                validator:
                    (value) => value?.isEmpty ?? true ? lang.required : null,
              ),
        ),
      ],
    );
  }

  Widget _buildGroupsDisplay() {
    return GroupsDisplayCard(
      title: lang.groupsDistribution,
      groups: _groups,
      groupCardBuilder:
          (index, List<String> group) => _buildGroupCard(index, group),
    );
  }

  Widget _buildGroupCard(int index, List<String> teams) {
    return Container(
      width: SizeConfig.screenWidth! * .3,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Text(
              "${lang.group} ${index + 1}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          ...teams.map(
            (team) =>
                Padding(padding: const EdgeInsets.all(8), child: Text(team)),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesDisplay() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(_spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.generatedMatches,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _matches.isEmpty
                ? Text(lang.NoMatches)
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _matches.length,
                  itemBuilder:
                      (_, index) => InteractiveMatchCard(
                        match: _matches[index],
                        isAdmin: ref.watch(isAdminProvider),
                        canUpdate: true,
                      ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              lang.tournamentPreview,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            trailing: IconButton(
              icon: Icon(
                _showPreview ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: () => setState(() => _showPreview = !_showPreview),
            ),
          ),
          if (_showPreview) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E40AF),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nameController.text,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${DateFormat('MMM d, yyyy').format(DateTime.parse(_startDateController.text))} - ${DateFormat('MMM d, yyyy').format(DateTime.parse(_endDateController.text))}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2.5,
                      children: [
                        _buildPreviewInfo(
                          lang.registrationDeadline,
                          DateFormat(
                            'MMM d, yyyy',
                          ).format(DateTime.parse(_regDeadlineController.text)),
                        ),
                        _buildPreviewInfo(
                          lang.teams,
                          '${_teamsController.text} ${lang.teams}',
                        ),
                        _buildPreviewInfo(
                          lang.ageGroups,
                          _getSelectedAgeGroups(),
                        ),
                        _buildPreviewInfo(
                          lang.group,
                          _groups.length.toString(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.format,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            _format,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildPreviewChip(
                                lang.minHalves(_halfDurationController.text),
                              ),
                              _buildPreviewChip(
                                lang.ptsWin(_winPointsController.text),
                              ),
                              _buildPreviewChip(
                                lang.players(_maxPlayersController.text),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            _descriptionController.text,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreviewInfo(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPreviewChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDBEAFE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Color(0xFF1E40AF)),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _publishTournament,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManger.buttonGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _showMatches
                    ? lang.reset
                    : _showGroups
                    ? lang.generateMatches
                    : lang.distributeTeams,
                style: TextStyles.whiteBoldStyle(SizeConfig.fontSize3!),
              ),
            ),
          ),
          HelperMethods.horizintalSpace(.1),
          Expanded(
            child: OutlinedButton(
              onPressed: _saveAsIncommingTournament,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey[300]!),
                backgroundColor: ColorManger.mainBlue,
              ),
              child: Text(
                lang.saveTournament,
                style: TextStyles.whiteBoldStyle(SizeConfig.fontSize3!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile(
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      dense: true,
      activeColor: const Color(0xFF1E40AF),
      tileColor: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  String _getSelectedAgeGroups() {
    List<String> selected = [];
    if (_ageGroups[0]) selected.add('U12');
    if (_ageGroups[1]) selected.add('U14');
    if (_ageGroups[2]) selected.add('U16');
    if (_ageGroups[3]) selected.add('U18');
    return selected.join(', ');
  }
}
