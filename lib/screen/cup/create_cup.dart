// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:youth_center/core/helper/size_config.dart';
// import 'package:youth_center/core/themes/colors.dart';
// import 'package:youth_center/core/themes/text_styles.dart';
// import 'package:youth_center/core/widgets/body_container.dart';
// import 'package:youth_center/core/widgets/grediant_container.dart';
// import 'package:youth_center/core/widgets/header.dart';
// import 'package:youth_center/generated/l10n.dart';
// import 'package:youth_center/models/match_model.dart';
// import 'package:youth_center/models/tournament.dart';
// import 'package:youth_center/screen/cup/cups_controller.dart';
// import 'package:youth_center/screen/cup/group_card.dart';
// import 'package:youth_center/screen/home/home_controller.dart';
// import 'package:youth_center/screen/home/match_card.dart';

// class GenerateMatchesScreen extends ConsumerStatefulWidget {
//   const GenerateMatchesScreen(this.tournament, {super.key});
//   final Tournament tournament;

//   @override
//   ConsumerState<GenerateMatchesScreen> createState() =>
//       _GenerateMatchesScreenState();
// }

// class _GenerateMatchesScreenState extends ConsumerState<GenerateMatchesScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   DateTime _selectedDate = DateTime.now();
//   final FirebaseFirestore db = FirebaseFirestore.instance;

//   int _teamCount = 8;
//   bool _randomDistribution = false;
//   bool _showGroups = false;
//   bool _showMatches = false;

//   final List<TextEditingController> _teamControllers = [];
//   final List<String> _teams = [];
//   final List<List<String>> _groups = [];
//   final List<dynamic> _matches = [];
//   final List<dynamic> _jsonMatches = [];

//   final double _spacing = 16.0;

//   @override
//   void initState() {
//     super.initState();
//     _nameController.text = widget.tournament.name.toString();

//     _initializeTeamControllers();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     for (var controller in _teamControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   void _initializeTeamControllers() {
//     _teamControllers.clear();
//     for (int i = 0; i < _teamCount; i++) {
//       _teamControllers.add(TextEditingController());
//     }
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() => _selectedDate = picked);
//     }
//   }

//   void _updateTeamCount(int change) {
//     final updatedCount = _teamCount + change;
//     if (updatedCount >= 4 && updatedCount <= 32) {
//       setState(() {
//         _teamCount = updatedCount;
//         _initializeTeamControllers();
//         _teams.clear();
//         _groups.clear();
//         _showGroups = false;
//         _showMatches = false;
//       });
//     }
//   }

//   void _toggleDistributionMode() {
//     setState(() => _randomDistribution = !_randomDistribution);
//   }

//   void _validateAndProceed() {
//     if (!_formKey.currentState!.validate()) return;

//     if (!_showGroups && !_showMatches) {
//       _collectTeams();
//     } else if (_showGroups && !_showMatches) {
//       _generateMatches();
//     } else {
//       _saveTournament();
//     }
//   }

//   void _collectTeams() {
//     _teams.clear();
//     for (var controller in _teamControllers) {
//       if (controller.text.isEmpty) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(S.of(context).enterNames)));
//         return;
//       }
//       _teams.add(controller.text.trim());
//     }
//     _distributeTeams();
//     setState(() => _showGroups = true);
//   }

//   void _distributeTeams() {
//     _groups.clear();
//     final teams = List<String>.from(_teams);
//     if (_randomDistribution) teams.shuffle();
//     for (int i = 0; i < teams.length; i += 4) {
//       _groups.add(
//         teams.sublist(i, (i + 4 < teams.length) ? i + 4 : teams.length),
//       );
//     }
//   }

//   void _generateMatches() {
//     _matches.clear();
//     _jsonMatches.clear();
//     for (var group in _groups) {
//       for (int i = 0; i < group.length; i++) {
//         for (int j = i + 1; j < group.length; j++) {
//           _matches.add(
//             MatchModel(
//               team1: group[i],
//               team2: group[j],
//               cupStartDate: Timestamp.fromDate(_selectedDate),
//               teem1Score: 0,
//               teem2Score: 0,
//               cupName: _nameController.text,
//               cupGroup: '${S.of(context).group} ${_groups.indexOf(group) + 1}',
//             ),
//           );
//           _jsonMatches.add(
//             MatchModel(
//               team1: group[i],
//               team2: group[j],
//               cupStartDate: Timestamp.fromDate(_selectedDate),
//               teem1Score: 0,
//               teem2Score: 0,
//               cupName: _nameController.text,
//               cupGroup: '${S.of(context).group} ${_groups.indexOf(group) + 1}',
//             ).toJson(),
//           );
//         }
//       }
//     }
//     setState(() => _showMatches = true);
//   }

//   Future<void> _saveTournament() async {
//     widget.tournament.teams = _teams;
//     widget.tournament.matches = _matches;
//     ref.read(cupsControllerProvider).updateCup(widget.tournament);

//     ref
//         .read(cupsControllerProvider)
//         .createCup(widget.tournament)
//         .then((_) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(S.of(context).successSave),
//               backgroundColor: Colors.green,
//               elevation: 10,
//             ),
//           );
//           _resetForm();
//         })
//         .catchError((error) {
//           log('Error saving cup: $error');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(error.toString()),
//               backgroundColor: Colors.redAccent,
//               elevation: 10,
//             ),
//           );
//         });
//   }

//   void _resetForm() {
//     setState(() {
//       if (_showMatches) {
//         _matches.clear();
//         _jsonMatches.clear();
//         _showMatches = false;
//       } else if (_showGroups) {
//         _groups.clear();
//         _showGroups = false;
//       } else {
//         _teams.clear();
//         _teamCount = 8;
//         _initializeTeamControllers();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GradientContainer(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Header(title: S.of(context).createCup),
//               BodyContainer(
//                 height: SizeConfig.screenHeight! * .85,
//                 child: SingleChildScrollView(
//                   padding: EdgeInsets.all(_spacing),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         _buildTournamentInfoSection(),
//                         SizedBox(height: _spacing),
//                         _buildTeamConfigurationSection(),
//                         SizedBox(height: _spacing),
//                         if (_showGroups) _buildGroupsDisplay(),
//                         if (_showMatches) _buildMatchesDisplay(),
//                         _buildActionButtons(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Reusable Widget Builders
//   Widget _buildTournamentInfoSection() => Card(
//     child: Padding(
//       padding: EdgeInsets.all(_spacing),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           TextFormField(
//             enabled: false,
//             controller: _nameController,
//             decoration: InputDecoration(
//               labelText: S.of(context).tournament,
//               border: OutlineInputBorder(),
//               prefixIcon: Icon(Icons.emoji_events),
//             ),
//             validator:
//                 (value) =>
//                     value?.isEmpty ?? true ? S.of(context).enterCupName : null,
//           ),
//           SizedBox(height: _spacing),
//           ListTile(
//             leading: Icon(Icons.calendar_today),
//             title: Text(S.of(context).startDate),
//             subtitle: Text(DateFormat('yyyy/MM/dd').format(_selectedDate)),
//             trailing: Icon(Icons.edit),
//             onTap: () => _selectDate(context),
//           ),
//         ],
//       ),
//     ),
//   );

//   Widget _buildTeamConfigurationSection() => Card(
//     child: Padding(
//       padding: EdgeInsets.all(_spacing),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Text(
//             S.of(context).teamConfiguration,
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//           SizedBox(height: _spacing),
//           _buildTeamCountSelector(),
//           SizedBox(height: _spacing),
//           _buildDistributionToggle(),
//           SizedBox(height: _spacing),
//           if (!_showGroups) _buildTeamInputs(),
//         ],
//       ),
//     ),
//   );

//   Widget _buildTeamCountSelector() => Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Text(S.of(context).numberOfTeams),
//       Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.remove),
//             onPressed: () => _updateTeamCount(-4),
//           ),
//           Text('$_teamCount'),
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () => _updateTeamCount(4),
//           ),
//         ],
//       ),
//     ],
//   );

//   Widget _buildDistributionToggle() => Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Text(S.of(context).distributionMode),
//       ToggleButtons(
//         isSelected: [_randomDistribution, !_randomDistribution],
//         onPressed: (_) => _toggleDistributionMode(),
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: Text(S.of(context).random),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: Text(S.of(context).manual),
//           ),
//         ],
//       ),
//     ],
//   );

//   Widget _buildTeamInputs() => Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(S.of(context).enterNames),
//       SizedBox(height: _spacing),
//       GridView.builder(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 3,
//           crossAxisSpacing: _spacing,
//           mainAxisSpacing: _spacing,
//         ),
//         itemCount: _teamCount,
//         itemBuilder:
//             (_, index) => TextFormField(
//               controller: _teamControllers[index],
//               decoration: InputDecoration(
//                 labelText: "${S.of(context).team} ${index + 1}",
//                 border: OutlineInputBorder(),
//               ),
//               validator:
//                   (value) =>
//                       value?.isEmpty ?? true ? S.of(context).required : null,
//             ),
//       ),
//     ],
//   );

//   Widget _buildGroupsDisplay() {
//     return GroupsDisplayCard(
//       title: S.of(context).groupsDistribution,
//       groups: _groups,
//       groupCardBuilder:
//           (index, List<String> group) => _buildGroupCard(index, group),
//     );
//   }

//   Widget _buildGroupCard(int index, List<String> teams) => Container(
//     width: SizeConfig.screenWidth! * .3,
//     decoration: BoxDecoration(
//       color: Colors.blue[50],
//       borderRadius: BorderRadius.circular(8),
//       border: Border.all(color: Colors.blue),
//     ),
//     child: Column(
//       children: [
//         Container(
//           padding: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.blue,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
//           ),
//           child: Text(
//             "${S.of(context).group} ${index + 1}",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         ...teams.map(
//           (team) => Padding(padding: EdgeInsets.all(8), child: Text(team)),
//         ),
//       ],
//     ),
//   );

//   Widget _buildMatchesDisplay() => Card(
//     child: Padding(
//       padding: EdgeInsets.all(_spacing),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             S.of(context).generatedMatches,
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//           SizedBox(height: _spacing),
//           _matches.isEmpty
//               ? Text(S.of(context).NoMatches)
//               : ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: _matches.length,
//                 itemBuilder:
//                     (_, index) => _buildMatchCard(
//                       _matches[index],
//                       ref.watch(isAdminProvider),
//                     ),
//               ),
//         ],
//       ),
//     ),
//   );

//   Widget _buildMatchCard(MatchModel match, bool isAdmin) =>
//       InteractiveMatchCard(match: match, isAdmin: isAdmin, canUpdate: true);

//   Widget _buildActionButtons() => Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: ColorManger.redButtonColor,
//         ),
//         onPressed: _resetForm,
//         child: Text(
//           S.of(context).reset,
//           style: TextStyles.whiteBoldStyle(SizeConfig.fontSize3!),
//         ),
//       ),
//       ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: ColorManger.buttonGreen,
//         ),
//         onPressed: _validateAndProceed,
//         child: Text(
//           _showMatches
//               ? S.of(context).saveTournament
//               : _showGroups
//               ? S.of(context).generateMatches
//               : S.of(context).distributeTeams,
//           style: TextStyles.whiteBoldStyle(SizeConfig.fontSize3!),
//         ),
//       ),
//     ],
//   );
// }
