import 'dart:developer';
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
import 'package:youth_center/models/tournament_model.dart';
import 'package:youth_center/screen/cup/logic/cups_controller.dart';
import 'package:youth_center/screen/cup/ui/widgets/form_controller.dart';
import 'package:youth_center/screen/cup/ui/widgets/group_card.dart';
import 'package:youth_center/screen/home/logic/home_controller.dart';
import 'package:youth_center/screen/home/ui/home_screen.dart';
import 'package:youth_center/screen/cup/ui/widgets/match_card.dart';

class NewCreateTournament extends ConsumerStatefulWidget {
  const NewCreateTournament({super.key, this.tournament});
  final TournamentModel? tournament;

  @override
  ConsumerState<NewCreateTournament> createState() =>
      _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends ConsumerState<NewCreateTournament> {
  static const _spacing = 16.0;
  static const _minTeams = 4;
  static const _maxTeams = 32;

  // Form and state management
  final _formKey = GlobalKey<FormState>();
  late S lang;
  int _currentStep = 0;
  bool _showPreview = false;
  bool _isInfoExpanded = false;
  bool _isFormatExpanded = false;
  bool _isRulesExpanded = false;
  bool _isTeamExpanded = false;
  bool _randomDistribution = false;
  bool _showGroups = false;
  bool _showMatches = false;

  // Form controllers
  final _controllers = FormControllers();
  final List<TextEditingController> _teamControllers = [];
  final List<String> _teams = [];
  final List<List<String>> _groups = [];
  final List<MatchModel> _matches = [];
  final List<Map<String, dynamic>> _jsonMatches = [];
  final List<bool> _ageGroups = [true, true, true, false];

  // Dropdown values
  late String _format;
  String _substitutionRules = '3 Substitutions';
  String _scheduling = 'Auto-generate schedule';
  String _breakBetweenMatches = '15 minutes';
  bool _offsideRule = true;
  bool _cardSystem = true;
  bool _extraTime = true;
  bool _penaltyShootout = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.tournament != null) {
      _initializeFromTournament(widget.tournament!);
    } else {
      _format = S.of(context).groupStageKnockout;
      _initializeTeamControllers();
    }
  }

  @override
  void dispose() {
    _controllers.dispose();
    for (var controller in _teamControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeTeamControllers() {
    _teamControllers.clear();
    final teamCount = int.tryParse(_controllers.teamsController.text) ?? 8;
    for (int i = 0; i < teamCount; i++) {
      _teamControllers.add(TextEditingController());
    }
  }

  void _initializeFromTournament(TournamentModel tournament) {
    _controllers.initFromTournament(tournament);
    _format = tournament.format ?? S.of(context).groupStageKnockout;
    _substitutionRules = tournament.substitutionRules ?? '3 Substitutions';
    _scheduling = tournament.scheduling ?? 'Auto-generate schedule';
    _breakBetweenMatches = tournament.breakBetweenMatches ?? '15 minutes';
    _offsideRule = tournament.offsideRule ?? true;
    _cardSystem = tournament.cardSystem ?? true;
    _extraTime = tournament.extraTime ?? true;
    _penaltyShootout = tournament.penaltyShootout ?? true;

    // Initialize age groups
    if (tournament.ageGroups != null) {
      _ageGroups[0] = tournament.ageGroups!.contains('U12');
      _ageGroups[1] = tournament.ageGroups!.contains('U14');
      _ageGroups[2] = tournament.ageGroups!.contains('U16');
      _ageGroups[3] = tournament.ageGroups!.contains('U18');
    }

    // Initialize teams
    _teams.clear();
    if (tournament.teams != null) {
      _teams.addAll(List<String>.from(tournament.teams!));
      _teamControllers.clear();
      for (var team in _teams) {
        _teamControllers.add(TextEditingController(text: team));
      }
      while (_teamControllers.length <
          (int.tryParse(_controllers.teamsController.text) ?? 8)) {
        _teamControllers.add(TextEditingController());
      }
      if (_teams.isNotEmpty) {
        _distributeTeams();
        _showGroups = true;
        if (tournament.matches != null && tournament.matches!.isNotEmpty) {
          _matches.addAll(HelperMethods.parseMatches(tournament.matches!));
          _jsonMatches.addAll(tournament.matches!.cast<Map<String, dynamic>>());
          _showMatches = true;
        }
      }
    } else {
      _initializeTeamControllers();
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: MyConstants.dateFormat.parse(controller.text),
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
    final currentCount = int.tryParse(_controllers.teamsController.text) ?? 8;
    final newCount = (currentCount + change).clamp(_minTeams, _maxTeams);
    setState(() {
      _controllers.teamsController.text = newCount.toString();
      _initializeTeamControllers();
      _resetTeamsAndMatches();
    });
  }

  void _resetTeamsAndMatches() {
    _teams.clear();
    _groups.clear();
    _matches.clear();
    _jsonMatches.clear();
    _showGroups = false;
    _showMatches = false;
  }

  void _toggleDistributionMode() {
    setState(() => _randomDistribution = !_randomDistribution);
  }

  bool _collectTeams() {
    _teams.clear();
    for (var controller in _teamControllers) {
      if (controller.text.trim().isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(lang.enterNames)));
        return false;
      }
      _teams.add(controller.text.trim());
    }
    _distributeTeams();
    setState(() => _showGroups = true);
    return true;
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
    final startDate = DateTime.parse(_controllers.startDateController.text);
    for (var group in _groups) {
      final groupIndex = _groups.indexOf(group) + 1;
      for (int i = 0; i < group.length; i++) {
        for (int j = i + 1; j < group.length; j++) {
          final match = MatchModel(
            team1: group[i],
            team2: group[j],
            matchTime: startDate,
            teem1Score: 0,
            teem2Score: 0,
            cupName: _controllers.nameController.text,
            cupGroup: '${lang.group} $groupIndex',
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
      if (widget.tournament != null) {
        _initializeFromTournament(widget.tournament!);
      } else {
        _controllers.reset();
        _teams.clear();
        _groups.clear();
        _matches.clear();
        _jsonMatches.clear();
        _showGroups = false;
        _showMatches = false;
        _initializeTeamControllers();
      }
    });
  }

  Future<void> _handleNextStep() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_showGroups) {
      if (_collectTeams()) _currentStep++;
    } else if (!_showMatches) {
      _generateMatches();
      _currentStep++;
    } else {
      _resetForm();
      _currentStep = 0;
    }
  }

  Future<void> _saveTournament({bool isPublished = false}) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final tournament = _buildTournamentModel(isPublished);
      final cupsController = ref.read(cupsControllerProvider);

      if (widget.tournament != null) {
        await cupsController.updateCup(tournament);
      } else {
        await cupsController.createCup(tournament);
      }

      _showSuccessDialog();
      _invalidateProviders();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  TournamentModel _buildTournamentModel(bool isPublished) {
    if (_matches.isNotEmpty && _jsonMatches.isEmpty) {
      log("Converting matches to JSON");
      _jsonMatches.addAll(
        _matches.map((m) => m.toJson() as Map<String, dynamic>).toList(),
      );
    }

    return TournamentModel(
      id:
          widget.tournament?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _controllers.nameController.text,
      description: _controllers.descriptionController.text,
      logoUrl: null,
      startDate: MyConstants.dateFormat.parse(
        _controllers.startDateController.text,
      ),
      endDate: MyConstants.dateFormat.parse(
        _controllers.endDateController.text,
      ),
      registrationDeadline: MyConstants.dateFormat.parse(
        _controllers.regDeadlineController.text,
      ),
      location: MyConstants.centerUser!.youthCenterName,
      numberOfTeams: int.parse(_controllers.teamsController.text),
      format: _format,
      minutesPerHalf: int.parse(_controllers.halfDurationController.text),
      halftimeMinutes: int.parse(_controllers.halftimeController.text),
      winPoints: int.parse(_controllers.winPointsController.text),
      drawPoints: int.parse(_controllers.drawPointsController.text),
      lossPoints: int.parse(_controllers.lossPointsController.text),
      minPlayers: int.parse(_controllers.minPlayersController.text),
      maxPlayers: int.parse(_controllers.maxPlayersController.text),
      substitutionRules: _substitutionRules,
      offsideRule: _offsideRule,
      cardSystem: _cardSystem,
      extraTime: _extraTime,
      penaltyShootout: _penaltyShootout,
      customRules: _controllers.customRulesController.text,
      scheduling: _scheduling,
      breakBetweenMatches: _breakBetweenMatches,
      createdAt: DateTime.now(),
      createdBy: MyConstants.centerUser!.id!,
      isPublished: isPublished,
      teams: _teams,
      matches: _jsonMatches,
      ageGroups: _getSelectedAgeGroups().split(', '),
    );
  }

  void _invalidateProviders() {
    ref.invalidate(cupsControllerProvider);
    ref.invalidate(activeCupsProvider);
    ref.invalidate(cupsProvider);
    ref.invalidate(matchesProvider);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
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
                  onPressed:
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return HomeScreen();
                          },
                        ),
                      ),
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
  }

  @override
  Widget build(BuildContext context) {
    lang = S.of(context);
    return Scaffold(
      body: GradientContainer(
        child: SingleChildScrollView(
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
                        HelperMethods.verticalSpace(0.03),
                        _buildBasicInfoSection(),
                        HelperMethods.verticalSpace(0.01),
                        _buildFormatSection(),
                        HelperMethods.verticalSpace(0.01),
                        _buildRulesSection(),
                        HelperMethods.verticalSpace(0.01),
                        _buildTeamConfigurationSection(),
                        HelperMethods.verticalSpace(0.01),
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
      children:
          List.generate(
            5,
            (index) => [
              _buildProgressStep(index + 1, _currentStep >= index),
              if (index < 4) _buildProgressLine(_currentStep > index),
            ],
          ).expand((e) => e).toList(),
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
    return _buildExpansionPanel(
      title: lang.basicInformation,
      isExpanded: _isInfoExpanded,
      onExpansionChanged: (v) => setState(() => _isInfoExpanded = v),
      children: [
        _buildTextField(
          controller: _controllers.nameController,
          label: lang.cupName,
          icon: Icons.emoji_events,
          validator: (v) => v?.isEmpty ?? true ? lang.enterCupName : null,
        ),
        const SizedBox(height: _spacing),
        _buildLogoUpload(),
        const SizedBox(height: _spacing),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                controller: _controllers.startDateController,
                label: lang.startDate,
                validator:
                    (v) => v?.isEmpty ?? true ? lang.enterStartTime : null,
              ),
            ),
            const SizedBox(width: _spacing),
            Expanded(
              child: _buildDateField(
                controller: _controllers.endDateController,
                label: lang.endDate,
                validator: (v) => v?.isEmpty ?? true ? lang.enterEndTime : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: _spacing),
        _buildDateField(
          controller: _controllers.regDeadlineController,
          label: lang.registrationDeadline,
          validator:
              (v) => v?.isEmpty ?? true ? lang.registrationDeadline : null,
        ),
        const SizedBox(height: _spacing),
        _buildTextField(
          controller: _controllers.descriptionController,
          label: lang.description,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildLogoUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildFormatSection() {
    return _buildExpansionPanel(
      title: lang.tournamentFormat,
      isExpanded: _isFormatExpanded,
      onExpansionChanged: (v) => setState(() => _isFormatExpanded = v),
      children: [
        _buildTextField(
          controller: _controllers.teamsController,
          label: lang.numberOfTeams,
          keyboardType: TextInputType.number,
          validator: (v) => v?.isEmpty ?? true ? lang.enterNumberOfTeams : null,
          onChanged: (_) => setState(_resetTeamsAndMatches),
        ),
        const SizedBox(height: _spacing),
        _buildAgeGroupsSelector(),
        const SizedBox(height: _spacing),
        _buildDropdown<String>(
          value: _format,
          label: lang.tournamentFormat,
          items: [
            lang.groupStageKnockout,
            lang.knockoutOnly,
            lang.leagueFormat,
            lang.roundRobin,
          ],
          onChanged: (v) => setState(() => _format = v!),
          validator: (v) => v?.isEmpty ?? true ? lang.selectFormat : null,
        ),
        const SizedBox(height: _spacing),
        _buildSectionTitle(lang.matchDuration),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _controllers.halfDurationController,
                label: lang.minutesPerHalf,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: _spacing),
            Expanded(
              child: _buildTextField(
                controller: _controllers.halftimeController,
                label: lang.halftimeMinutes,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: _spacing),
        _buildSectionTitle(lang.pointsSystem),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _controllers.winPointsController,
                label: lang.win,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: _spacing),
            Expanded(
              child: _buildTextField(
                controller: _controllers.drawPointsController,
                label: lang.draw,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: _spacing),
            Expanded(
              child: _buildTextField(
                controller: _controllers.lossPointsController,
                label: lang.loss,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgeGroupsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(lang.ageGroups),
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
              (v) => setState(() => _ageGroups[0] = v!),
            ),
            _buildCheckboxTile(
              'Under 14',
              _ageGroups[1],
              (v) => setState(() => _ageGroups[1] = v!),
            ),
            _buildCheckboxTile(
              'Under 16',
              _ageGroups[2],
              (v) => setState(() => _ageGroups[2] = v!),
            ),
            _buildCheckboxTile(
              'Under 18',
              _ageGroups[3],
              (v) => setState(() => _ageGroups[3] = v!),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRulesSection() {
    return _buildExpansionPanel(
      title: lang.rulesSettings,
      isExpanded: _isRulesExpanded,
      onExpansionChanged: (v) => setState(() => _isRulesExpanded = v),
      children: [
        _buildSectionTitle(lang.teamSizeLimits),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _controllers.minPlayersController,
                label: lang.minPlayers,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: _spacing),
            Expanded(
              child: _buildTextField(
                controller: _controllers.maxPlayersController,
                label: lang.maxPlayers,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: _spacing),
        _buildDropdown<String>(
          value: _substitutionRules,
          label: lang.substitutionRules,
          items: [
            lang.threeSubstitutions,
            lang.fiveSubstitutions,
            lang.rollingSubstitutions,
            lang.unlimitedSubstitutions,
          ],
          onChanged: (v) => setState(() => _substitutionRules = v!),
        ),
        const SizedBox(height: _spacing),
        _buildSectionTitle(lang.matchRules),
        const SizedBox(height: 8),
        Column(
          children: [
            _buildCheckboxTile(
              lang.offsideRule,
              _offsideRule,
              (v) => setState(() => _offsideRule = v!),
            ),
            _buildCheckboxTile(
              lang.cardSystem,
              _cardSystem,
              (v) => setState(() => _cardSystem = v!),
            ),
            _buildCheckboxTile(
              lang.extraTime,
              _extraTime,
              (v) => setState(() => _extraTime = v!),
            ),
            _buildCheckboxTile(
              lang.penaltyShootout,
              _penaltyShootout,
              (v) => setState(() => _penaltyShootout = v!),
            ),
          ],
        ),
        const SizedBox(height: _spacing),
        _buildTextField(
          controller: _controllers.customRulesController,
          label: lang.customRules,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildTeamConfigurationSection() {
    return _buildExpansionPanel(
      title: lang.teamConfiguration,
      isExpanded: _isTeamExpanded,
      onExpansionChanged: (v) => setState(() => _isTeamExpanded = v),
      children: [
        _buildTeamCountSelector(),
        HelperMethods.verticalSpace(0.02),
        _buildDistributionToggle(),
        HelperMethods.verticalSpace(0.02),
        if (!_showGroups) _buildTeamInputs(),
        if (_showGroups || _teams.isNotEmpty) _buildGroupsDisplay(),
        if (_showMatches || _matches.isNotEmpty) _buildMatchesDisplay(),
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
            Text(_controllers.teamsController.text),
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
        const SizedBox(height: _spacing),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: _spacing,
            mainAxisSpacing: _spacing,
          ),
          itemCount: int.parse(_controllers.teamsController.text),
          itemBuilder:
              (_, index) => _buildTextField(
                controller: _teamControllers[index],
                label: "${lang.team} ${index + 1}",
                validator:
                    _isTeamExpanded
                        ? (v) => v?.isEmpty ?? true ? lang.required : null
                        : null,
                border: const OutlineInputBorder(),
              ),
        ),
      ],
    );
  }

  Widget _buildGroupsDisplay() {
    return GroupsDisplayCard(
      title: lang.groupsDistribution,
      groups: _groups,
      groupCardBuilder: (index, group) => _buildGroupCard(index, group),
    );
  }

  Widget _buildGroupCard(int index, List<String> teams) {
    return Container(
      width: SizeConfig.screenWidth! * 0.3,
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
        padding: const EdgeInsets.all(_spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.generatedMatches,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: _spacing),
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
              padding: const EdgeInsets.all(_spacing),
              child: Container(
                padding: const EdgeInsets.all(_spacing),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildPreviewHeader(),
                    const SizedBox(height: _spacing),
                    _buildPreviewInfoGrid(),
                    const SizedBox(height: _spacing),
                    _buildPreviewFormatCard(),
                    const SizedBox(height: _spacing),
                    _buildPreviewDescriptionCard(),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreviewHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF1E40AF),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(Icons.emoji_events, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _controllers.nameController.text,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              '${DateFormat('MMM d, yyyy').format(DateTime.parse(_controllers.startDateController.text))} - '
              '${DateFormat('MMM d, yyyy').format(DateTime.parse(_controllers.endDateController.text))}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreviewInfoGrid() {
    return GridView.count(
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
          ).format(DateTime.parse(_controllers.regDeadlineController.text)),
        ),
        _buildPreviewInfo(
          lang.teams,
          '${_controllers.teamsController.text} ${lang.teams}',
        ),
        _buildPreviewInfo(lang.ageGroups, _getSelectedAgeGroups()),
        _buildPreviewInfo(lang.group, _groups.length.toString()),
      ],
    );
  }

  Widget _buildPreviewFormatCard() {
    return Container(
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
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(_format, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPreviewChip(
                lang.minHalves(_controllers.halftimeController.text),
              ),
              _buildPreviewChip(
                lang.ptsWin(_controllers.winPointsController.text),
              ),
              _buildPreviewChip(
                lang.players(_controllers.maxPlayersController.text),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewDescriptionCard() {
    return Container(
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
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            _controllers.descriptionController.text,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(_spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _handleNextStep,
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

          HelperMethods.horizintalSpace(.01),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _saveTournament(),
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

  Widget _buildExpansionPanel({
    required String title,
    required bool isExpanded,
    required ValueChanged<bool> onExpansionChanged,
    required List<Widget> children,
  }) {
    return ExpansionPanelList(
      expansionCallback: (_, __) => onExpansionChanged(!isExpanded),
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      children: [
        ExpansionPanel(
          headerBuilder:
              (_, __) => ListTile(
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _spacing),
            child: Column(children: children),
          ),
          isExpanded: isExpanded,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines,
    ValueChanged<String?>? onChanged,
    InputBorder? border,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        prefixIcon: icon != null ? Icon(icon) : null,
        border: border,
        alignLabelWithHint: maxLines != null,
      ),
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      onChanged: onChanged,
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: '$label*',
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () => _selectDate(controller),
      validator: validator,
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required String label,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: '$label*',
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
      ),
      items:
          items
              .map(
                (item) =>
                    DropdownMenuItem(value: item, child: Text(item.toString())),
              )
              .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildCheckboxTile(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return CheckboxListTile(
      title: Text(label),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
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

  String _getSelectedAgeGroups() {
    final List<String> selected = [];
    if (_ageGroups[0]) selected.add('YesU12');
    if (_ageGroups[1]) selected.add('YesU14');
    if (_ageGroups[2]) selected.add('YesU16');
    if (_ageGroups[3]) selected.add('YesU18');
    return selected.join(', ');
  }
}
