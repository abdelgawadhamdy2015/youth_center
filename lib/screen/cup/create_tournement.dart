import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  int _currentStep = 0;
  bool _showPreview = false;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Summer Youth Cup');
  final _descriptionController = TextEditingController(
    text: 'The Summer Youth Cup is an annual tournament designed to bring together young athletes from across the region...',
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
    text: '1. All players must wear shin guards.\n2. Teams must arrive 30 minutes before kickoff.\n3. Coaches must remain in designated technical area.',
  );

  // Dropdown values
  String _location = 'Main Field';
  String _format = 'Group Stage + Knockout';
  String _substitutionRules = '3 Substitutions';
  String _scheduling = 'Auto-generate schedule';
  String _breakBetweenMatches = '15 minutes';

  // Checkbox values
  bool _offsideRule = true;
  bool _cardSystem = true;
  bool _extraTime = true;
  bool _penaltyShootout = true;
  final List<bool> _ageGroups = [true, true, true, false];
  final List<bool> _timeSlots = [true, true, true, true];
  final List<bool> _venues = [true, true, true];

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text('Create Tournament'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Progress indicator
              _buildProgressIndicator(),
              const SizedBox(height: 24),
              
              // Form sections
              _buildBasicInfoSection(),
              const SizedBox(height: 16),
              _buildFormatSection(),
              const SizedBox(height: 16),
              _buildRulesSection(),
              const SizedBox(height: 16),
              _buildScheduleSection(),
              const SizedBox(height: 16),
              _buildPreviewSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
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
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: const Text(
                'Basic Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey[600],
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tournament Name*',
                    filled: true,
                    fillColor: Color(0xFFF3F4F6),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a tournament name';
                    }
                    return null;
                  },
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
                        decoration: const InputDecoration(
                          labelText: 'Start Date*',
                          filled: true,
                          fillColor: Color(0xFFF3F4F6),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context, _startDateController),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _endDateController,
                        decoration: const InputDecoration(
                          labelText: 'End Date*',
                          filled: true,
                          fillColor: Color(0xFFF3F4F6),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context, _endDateController),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _location,
                  decoration: const InputDecoration(
                    labelText: 'Location*',
                    filled: true,
                    fillColor: Color(0xFFF3F4F6),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Main Field', child: Text('Main Field')),
                    DropdownMenuItem(value: 'Indoor Court', child: Text('Indoor Court')),
                    DropdownMenuItem(value: 'Training Ground', child: Text('Training Ground')),
                    DropdownMenuItem(value: 'Multiple Venues', child: Text('Multiple Venues')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _location = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _regDeadlineController,
                  decoration: const InputDecoration(
                    labelText: 'Registration Deadline*',
                    filled: true,
                    fillColor: Color(0xFFF3F4F6),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, _regDeadlineController),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    filled: true,
                    fillColor: Color(0xFFF3F4F6),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _buildFormatSection() {
    return ExpansionPanelList(
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: const Text(
                'Tournament Format',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey[600],
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextFormField(
                  controller: _teamsController,
                  decoration: const InputDecoration(
                    labelText: 'Number of Teams*',
                    filled: true,
                    fillColor: Color(0xFFF3F4F6),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of teams';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Age Groups*',
                  style: TextStyle(
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
                    _buildCheckboxTile('Under 12', _ageGroups[0], (value) {
                      setState(() {
                        _ageGroups[0] = value!;
                      });
                    }),
                    _buildCheckboxTile('Under 14', _ageGroups[1], (value) {
                      setState(() {
                        _ageGroups[1] = value!;
                      });
                    }),
                    _buildCheckboxTile('Under 16', _ageGroups[2], (value) {
                      setState(() {
                        _ageGroups[2] = value!;
                      });
                    }),
                    _buildCheckboxTile('Under 18', _ageGroups[3], (value) {
                      setState(() {
                        _ageGroups[3] = value!;
                      });
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _format,
                  decoration: const InputDecoration(
                    labelText: 'Tournament Format*',
                    filled: true,
                    fillColor: Color(0xFFF3F4F6),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Group Stage + Knockout', child: Text('Group Stage + Knockout')),
                    DropdownMenuItem(value: 'Knockout Only', child: Text('Knockout Only')),
                    DropdownMenuItem(value: 'League Format', child: Text('League Format')),
                    DropdownMenuItem(value: 'Round Robin', child: Text('Round Robin')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _format = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a format';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Match Duration',
                  style: TextStyle(
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
                        decoration: const InputDecoration(
                          labelText: 'Minutes per Half',
                          filled: true,
                          fillColor: Color(0xFFF3F4F6),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _halftimeController,
                        decoration: const InputDecoration(
                          labelText: 'Halftime (minutes)',
                          filled: true,
                          fillColor: Color(0xFFF3F4F6),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Points System',
                  style: TextStyle(
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
                        decoration: const InputDecoration(
                          labelText: 'Win',
                          filled: true,
                          fillColor: Color(0xFFF3F4F6),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _drawPointsController,
                        decoration: const InputDecoration(
                          labelText: 'Draw',
                          filled: true,
                          fillColor: Color(0xFFF3F4F6),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _lossPointsController,
                        decoration: const InputDecoration(
                          labelText: 'Loss',
                          filled: true,
                          fillColor: Color(0xFFF3F4F6),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _buildRulesSection() {
    return ExpansionPanelList(
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: const Text(
                'Rules & Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey[600],
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const Text(
                  'Team Size Limits',
                  style: TextStyle(
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
                        decoration: const InputDecoration(
                          labelText: 'Min Players',
                          filled: true,
                          fillColor: Color(0xFFF3F4F6),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _maxPlayersController,
                        decoration: const InputDecoration(
                          labelText: 'Max Players',
                          filled: true,
                          fillColor: Color(0xFFF3F4F6),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _substitutionRules,
                  decoration: const InputDecoration(
                    labelText: 'Substitution Rules',
                    filled: true,
                    fillColor: Color(0xFFF3F4F6),
                  ),
                  items: const [
                    DropdownMenuItem(value: '3 Substitutions', child: Text('3 Substitutions')),
                    DropdownMenuItem(value: '5 Substitutions', child: Text('5 Substitutions')),
                    DropdownMenuItem(value: 'Rolling Substitutions', child: Text('Rolling Substitutions')),
                    DropdownMenuItem(value: 'Unlimited Substitutions', child: Text('Unlimited Substitutions')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _substitutionRules = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Match Rules',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    _buildCheckboxTile('Offside rule applies', _offsideRule, (value) {
                      setState(() {
                        _offsideRule = value!;
                      });
                    }),
                    _buildCheckboxTile('Yellow/red card system', _cardSystem, (value) {
                      setState(() {
                        _cardSystem = value!;
                      });
                    }),
                    _buildCheckboxTile('Extra time for knockout matches', _extraTime, (value) {
                      setState(() {
                        _extraTime = value!;
                      });
                    }),
                    _buildCheckboxTile('Penalty shootout if tied after extra time', _penaltyShootout, (value) {
                      setState(() {
                        _penaltyShootout = value!;
                      });
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _customRulesController,
                  decoration: const InputDecoration(
                    labelText: 'Custom Rules',
                    filled: true,
                    fillColor: Color(0xFFF3F4F6),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return ExpansionPanelList(
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: const Text(
                'Schedule Configuration',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey[600],
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _scheduling,
                  decoration: const InputDecoration(
                    labelText: 'Match Scheduling',
                    filled: true,
                    fillColor: Color(0xFFF3F4F6),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Auto-generate schedule', child: Text('Auto-generate schedule')),
                    DropdownMenuItem(value: 'Manual scheduling', child: Text('Manual scheduling')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _scheduling = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Available Time Slots',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    _buildCheckboxTile('Weekday Evenings (17:00 - 21:00)', _timeSlots[0], (value) {
                      setState(() {
                        _timeSlots[0] = value!;
                      });
                    }),
                    _buildCheckboxTile('Saturday Morning (09:00 - 13:00)', _timeSlots[1], (value) {
                      setState(() {
                        _timeSlots[1] = value!;
                      });
                    }),
                    _buildCheckboxTile('Saturday Afternoon (14:00 - 18:00)', _timeSlots[2], (value) {
                      setState(() {
                        _timeSlots[2] = value!;
                      });
                    }),
                    _buildCheckboxTile('Sunday (09:00 - 18:00)', _timeSlots[3], (value) {
                      setState(() {
                        _timeSlots[3] = value!;
                      });
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Venue Allocation',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    _buildCheckboxTile('Main Field', _venues[0], (value) {
                      setState(() {
                        _venues[0] = value!;
                      });
                    }),
                    _buildCheckboxTile('Indoor Court', _venues[1], (value) {
                      setState(() {
                        _venues[1] = value!;
                      });
                    }),
                    _buildCheckboxTile('Training Ground', _venues[2], (value) {
                      setState(() {
                        _venues[2] = value!;
                      });
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _breakBetweenMatches,
                  decoration: const InputDecoration(
                    labelText: 'Break Between Matches',
                    filled: true,
                    fillColor: Color(0xFFF3F4F6),
                  ),
                  items: const [
                    DropdownMenuItem(value: '15 minutes', child: Text('15 minutes')),
                    DropdownMenuItem(value: '30 minutes', child: Text('30 minutes')),
                    DropdownMenuItem(value: '45 minutes', child: Text('45 minutes')),
                    DropdownMenuItem(value: '60 minutes', child: Text('60 minutes')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _breakBetweenMatches = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _buildPreviewSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text(
              'Tournament Preview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                _showPreview ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: () {
                setState(() {
                  _showPreview = !_showPreview;
                });
              },
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
                          child: const Icon(Icons.emoji_events, color: Colors.white),
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
                        _buildPreviewInfo('Location', _location),
                        _buildPreviewInfo('Registration Deadline', 
                          DateFormat('MMM d, yyyy').format(DateTime.parse(_regDeadlineController.text))),
                        _buildPreviewInfo('Teams', '${_teamsController.text} teams'),
                        _buildPreviewInfo('Age Groups', _getSelectedAgeGroups()),
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
                          const Text(
                            'Format',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            _format,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildPreviewChip('${_halfDurationController.text} min halves'),
                              _buildPreviewChip('${_winPointsController.text} pts win'),
                              _buildPreviewChip('${_maxPlayersController.text} players'),
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
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            _descriptionController.text,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
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
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
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
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF1E40AF),
        ),
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
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                _saveAsDraft();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: const Text('Save as Draft'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _publishTournament();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E40AF),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Publish Tournament'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      dense: true,
      activeColor: const Color(0xFF1E40AF),
      tileColor: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
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

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(controller.text),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _saveAsDraft() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tournament saved as draft')),
      );
    }
  }

  void _publishTournament() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
                child: const Icon(Icons.check, color: Color(0xFF10B981), size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tournament Created!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your tournament has been successfully created and published.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to tournaments screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E40AF),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Go to Tournaments'),
              ),
            ],
          ),
        ),
      );
    }
  }
}