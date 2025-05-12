import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/models/cup_model.dart';
import 'package:youth_center/models/user_model.dart';

class AddCupScreen extends StatefulWidget {
  final CenterUser center;
  const AddCupScreen({super.key, required this.center});

  @override
  State<AddCupScreen> createState() => _AddCupScreenState();
}

class _AddCupScreenState extends State<AddCupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  int _teamCount = 8;
  bool _randomDistribution = false;
  bool _showGroups = false;
  bool _showMatches = false;

  final List<TextEditingController> _teamControllers = [];
  final List<String> _teams = [];
  final List<List<String>> _groups = [];
  final List<Map<String, dynamic>> _matches = [];

  final double _spacing = 16.0;
  final double _groupCardWidth = 150.0;

  @override
  void initState() {
    super.initState();
    _initializeTeamControllers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (var controller in _teamControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeTeamControllers() {
    _teamControllers.clear();
    for (int i = 0; i < _teamCount; i++) {
      _teamControllers.add(TextEditingController());
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _updateTeamCount(int change) {
    final updatedCount = _teamCount + change;
    if (updatedCount >= 4 && updatedCount <= 32) {
      setState(() {
        _teamCount = updatedCount;
        _initializeTeamControllers();
        _teams.clear();
        _groups.clear();
        _showGroups = false;
        _showMatches = false;
      });
    }
  }

  void _toggleDistributionMode() {
    setState(() => _randomDistribution = !_randomDistribution);
  }

  void _validateAndProceed() {
    if (!_formKey.currentState!.validate()) return;

    if (!_showGroups && !_showMatches) {
      _collectTeams();
    } else if (_showGroups && !_showMatches) {
      _generateMatches();
    } else {
      _saveTournament();
    }
  }

  void _collectTeams() {
    _teams.clear();
    for (var controller in _teamControllers) {
      if (controller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter all team names')),
        );
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
      _groups.add(teams.sublist(i, (i + 4 < teams.length) ? i + 4 : teams.length));
    }
  }

  void _generateMatches() {
    _matches.clear();
    for (var group in _groups) {
      for (int i = 0; i < group.length; i++) {
        for (int j = i + 1; j < group.length; j++) {
          _matches.add({
            MyConstants.team1: group[i],
            MyConstants.team2: group[j],
            MyConstants.cupGroup: 'Group ${_groups.indexOf(group) + 1}',
            MyConstants.cupStartDate: Timestamp.fromDate(_selectedDate),
            MyConstants.team1Score: 0,
            MyConstants.team2Score: 0,
            MyConstants.cupName: _nameController.text,
          });
        }
      }
    }
    setState(() => _showMatches = true);
  }

  Future<void> _saveTournament() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a tournament name')),
      );
      return;
    }
    final cup = CupModel(
      id: _nameController.text.trim(),
      name: _nameController.text,
      teems: _teams,
      timeStart: Timestamp.fromDate(_selectedDate),
      youthCenterId: widget.center.youthCenterName,
      matches: _matches,
      finished: false,
    );
    await db
        .collection(MyConstants.cupCollection)
        .doc(cup.id)
        .set(cup.toJson())
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tournament saved successfully'), backgroundColor: Colors.green, elevation: 10),
          );
          _resetForm();
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString()), backgroundColor: Colors.redAccent, elevation: 10),
          );
        });
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _teamCount = 8;
      _initializeTeamControllers();
      _teams.clear();
      _groups.clear();
      _showGroups = false;
      _showMatches = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Tournament'),
        backgroundColor: MyColors.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_spacing),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTournamentInfoSection(),
              SizedBox(height: _spacing),
              _buildTeamConfigurationSection(),
              SizedBox(height: _spacing),
              if (_showGroups) _buildGroupsDisplay(),
              if (_showMatches) _buildMatchesDisplay(),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Widget Builders
  Widget _buildTournamentInfoSection() => Card(
    child: Padding(
      padding: EdgeInsets.all(_spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Tournament Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.emoji_events),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Please enter a tournament name' : null,
          ),
          SizedBox(height: _spacing),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Start Date'),
            subtitle: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
            trailing: Icon(Icons.edit),
            onTap: () => _selectDate(context),
          ),
        ],
      ),
    ),
  );

  Widget _buildTeamConfigurationSection() => Card(
    child: Padding(
      padding: EdgeInsets.all(_spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Team Configuration', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: _spacing),
          _buildTeamCountSelector(),
          SizedBox(height: _spacing),
          _buildDistributionToggle(),
          SizedBox(height: _spacing),
          if (!_showGroups) _buildTeamInputs(),
        ],
      ),
    ),
  );

  Widget _buildTeamCountSelector() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text('Number of Teams:'),
      Row(
        children: [
          IconButton(icon: const Icon(Icons.remove), onPressed: () => _updateTeamCount(-4)),
          Text('$_teamCount'),
          IconButton(icon: const Icon(Icons.add), onPressed: () => _updateTeamCount(4)),
        ],
      ),
    ],
  );

  Widget _buildDistributionToggle() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text('Distribution Mode:'),
      ToggleButtons(
        isSelected: [_randomDistribution, !_randomDistribution],
        onPressed: (_) => _toggleDistributionMode(),
        children: const [
          Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Random')),
          Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Manual')),
        ],
      ),
    ],
  );

  Widget _buildTeamInputs() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Enter Team Names:'),
      SizedBox(height: _spacing),
      GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3,
          crossAxisSpacing: _spacing,
          mainAxisSpacing: _spacing,
        ),
        itemCount: _teamCount,
        itemBuilder: (_, index) => TextFormField(
          controller: _teamControllers[index],
          decoration: InputDecoration(
            labelText: 'Team ${index + 1}',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ),
    ],
  );

  Widget _buildGroupsDisplay() => Card(
    child: Padding(
      padding: EdgeInsets.all(_spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Groups Distribution', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: _spacing),
          Wrap(
            spacing: _spacing,
            runSpacing: _spacing,
            children: _groups.asMap().entries.map((entry) => _buildGroupCard(entry.key, entry.value)).toList(),
          ),
        ],
      ),
    ),
  );

  Widget _buildGroupCard(int index, List<String> teams) => Container(
    width: _groupCardWidth,
    decoration: BoxDecoration(
      color: Colors.blue[50],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.blue),
    ),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Text('Group ${index + 1}', style: TextStyle(color: Colors.white)),
        ),
        ...teams.map((team) => Padding(padding: EdgeInsets.all(8), child: Text(team))),
      ],
    ),
  );

  Widget _buildMatchesDisplay() => Card(
    child: Padding(
      padding: EdgeInsets.all(_spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Generated Matches', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: _spacing),
          _matches.isEmpty
              ? const Text('No matches generated yet')
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _matches.length,
                  itemBuilder: (_, index) => _buildMatchCard(_matches[index]),
                ),
        ],
      ),
    ),
  );

  Widget _buildMatchCard(Map<String, dynamic> match) => Card(
    margin: EdgeInsets.only(bottom: _spacing),
    child: Padding(
      padding: EdgeInsets.all(_spacing),
      child: Column(
        children: [
          Text(match[MyConstants.cupGroup], style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: _spacing / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(match[MyConstants.team1]),
              const Text('vs'),
              Text(match[MyConstants.team2]),
            ],
          ),
          SizedBox(height: _spacing / 2),
          Text(DateFormat('dd/MM/yyyy').format(match[MyConstants.cupStartDate].toDate()), style: TextStyle(color: Colors.grey)),
        ],
      ),
    ),
  );

  Widget _buildActionButtons() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300], foregroundColor: Colors.black),
        onPressed: _resetForm,
        child: const Text('Reset'),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: MyColors.primaryColor),
        onPressed: _validateAndProceed,
        child: Text(_showMatches ? 'Save Tournament' : _showGroups ? 'Generate Matches' : 'Distribute Teams'),
      ),
    ],
  );
}
