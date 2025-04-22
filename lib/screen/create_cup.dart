import 'package:flutter/material.dart';
import 'package:youth_center/core/colors.dart';
import 'package:youth_center/models/user_model.dart';

class AddCupScreen extends StatefulWidget {
  final CenterUser center;

  const AddCupScreen({super.key, required this.center});

  @override
  State<AddCupScreen> createState() => _AddCupScreenState();
}

class _AddCupScreenState extends State<AddCupScreen> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // Tournament configuration
  int _teamCount = 8;
  bool _randomDistribution = false;
  bool _showGroups = false;
  bool _showMatches = false;

  // Teams data
  final List<TextEditingController> _teamControllers = [];
  final List<String> _teams = [];
  final List<List<String>> _groups = [];

  // UI constants
  final double _spacing = 16.0;
  final double _groupCardWidth = 150.0;

  @override
  void initState() {
    super.initState();
    _initializeTeamControllers();
  }

  void _initializeTeamControllers() {
    _teamControllers.clear();
    for (int i = 0; i < _teamCount; i++) {
      _teamControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (var controller in _teamControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _updateTeamCount(int change) {
    if (_teamCount + change >= 4 && _teamCount + change <= 32) {
      setState(() {
        _teamCount += change;
        _initializeTeamControllers();
        _teams.clear();
        _groups.clear();
        _showGroups = false;
        _showMatches = false;
      });
    }
  }

  void _toggleDistributionMode() {
    setState(() {
      _randomDistribution = !_randomDistribution;
    });
  }

  void _validateAndProceed() {
    if (!_formKey.currentState!.validate()) return;

    if (!_showGroups && !_showMatches) {
      // Step 1: Collect team names
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

      // Step 2: Distribute teams into groups
      _distributeTeams();
      setState(() => _showGroups = true);
    } else if (_showGroups && !_showMatches) {
      // Step 3: Generate matches
      _generateMatches();
      setState(() => _showMatches = true);
    } else {
      // Step 4: Save tournament
      _saveTournament();
    }
  }

  void _distributeTeams() {
    _groups.clear();
    List<String> teamsToDistribute = List.from(_teams);

    if (_randomDistribution) {
      teamsToDistribute.shuffle();
    }

    // Distribute teams into groups of 4
    for (int i = 0; i < teamsToDistribute.length; i += 4) {
      int end =
          (i + 4 < teamsToDistribute.length) ? i + 4 : teamsToDistribute.length;
      _groups.add(teamsToDistribute.sublist(i, end));
    }
  }

  void _generateMatches() {
    // Implement your match generation logic here
    // This would create the round-robin matches for each group
  }

  Future<void> _saveTournament() async {
    // Implement your Firestore save logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tournament saved successfully')),
    );

    // Reset form after save
    _resetForm();
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
              // Tournament Info Section
              _buildTournamentInfoSection(),
              SizedBox(height: _spacing),

              // Team Configuration Section
              _buildTeamConfigurationSection(),
              SizedBox(height: _spacing),

              // Groups Display (when shown)
              if (_showGroups) _buildGroupsDisplay(),

              // Matches Display (when shown)
              if (_showMatches) _buildMatchesDisplay(),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTournamentInfoSection() {
    return Card(
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
              validator:
                  (value) =>
                      value?.isEmpty ?? true
                          ? 'Please enter a tournament name'
                          : null,
            ),
            SizedBox(height: _spacing),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Start Date'),
              subtitle: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
              trailing: Icon(Icons.edit),
              onTap: () => _selectDate(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamConfigurationSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(_spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Team Configuration',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: _spacing),

            // Team count selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Number of Teams:'),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => _updateTeamCount(-4),
                    ),
                    Text('$_teamCount'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _updateTeamCount(4),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: _spacing),

            // Distribution mode toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Distribution Mode:'),
                ToggleButtons(
                  isSelected: [_randomDistribution, !_randomDistribution],
                  onPressed: (index) => _toggleDistributionMode(),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Random'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Manual'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: _spacing),

            // Team name inputs
            if (!_showGroups) ...[
              Text('Enter Team Names:'),
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
                itemBuilder: (context, index) {
                  return TextFormField(
                    controller: _teamControllers[index],
                    decoration: InputDecoration(
                      labelText: 'Team ${index + 1}',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) => value?.isEmpty ?? true ? 'Required' : null,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsDisplay() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(_spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Groups Distribution',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: _spacing),

            Wrap(
              spacing: _spacing,
              runSpacing: _spacing,
              children:
                  _groups.asMap().entries.map((entry) {
                    int groupIndex = entry.key;
                    List<String> groupTeams = entry.value;

                    return Container(
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
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Group ${groupIndex + 1}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ...groupTeams.map(
                            (team) => Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(team),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchesDisplay() {
    // Implement your matches display here
    return Card(
      child: Padding(
        padding: EdgeInsets.all(_spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generated Matches',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: _spacing),
            Text('Match list would be displayed here'),
            // You would implement ListView.builder here to show matches
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
          ),
          onPressed: _resetForm,
          child: Text('Reset'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.primaryColor,
          ),
          onPressed: _validateAndProceed,
          child: Text(
            _showMatches
                ? 'Save Tournament'
                : _showGroups
                ? 'Generate Matches'
                : 'Distribute Teams',
          ),
        ),
      ],
    );
  }
}
