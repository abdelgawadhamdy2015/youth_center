import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:youth_center/FetchData.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/models/match_model.dart';

class InteractiveMatchCard extends StatefulWidget {
  const InteractiveMatchCard({
    super.key,
    required this.match,
    required this.isAdmin,
    required this.canUpdate,
  });

  final MatchModel match;
  final bool isAdmin;
  final bool canUpdate;
  @override
  State<InteractiveMatchCard> createState() => _InteractiveMatchCardState();
}

class _InteractiveMatchCardState extends State<InteractiveMatchCard> {
  late DateTime iniDate;
  late DateTime dateTime;
  final fetchData = FetchData();
  @override
  void initState() {
    super.initState();
    iniDate = widget.match.cupStartDate;
    dateTime = widget.match.cupStartDate;
  }

  Future<void> _pickDateTime() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: iniDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate == null) return;

    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(iniDate),
    );
    if (newTime == null) return;

    iniDate = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      newTime.hour,
      newTime.minute,
    );

    setState(() {
      dateTime = iniDate;
      widget.match.setTime(dateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    final match = widget.match;
    final bool canUpdate = (widget.isAdmin && widget.canUpdate);
    return SwipeDetector(
      onSwipeRight:
          canUpdate ? (_) => setState(() => match.teem2Score--) : null,
      onSwipeLeft: canUpdate ? (_) => setState(() => match.teem1Score--) : null,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: ListTile(
          title: Center(
            child: Text(
              match.cupName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  onLongPress:
                      canUpdate
                          ? () => setState(() => match.teem1Score++)
                          : null,
                  child: Text(match.team1, textAlign: TextAlign.center),
                ),
              ),
              const Icon(Icons.sports_soccer),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: canUpdate ? _pickDateTime : null,
                    child: FittedBox(
                      child: Text(
                        fetchData.getDateTime(match.cupStartDate),
                        textAlign: TextAlign.center,
                        // style: const TextStyle(),
                      ),
                    ),
                  ),
                  HelperMethods.verticalSpace(.02),

                  Text("${match.teem1Score} : ${match.teem2Score}"),
                ],
              ),
              const Icon(Icons.sports_soccer),
              Expanded(
                child: GestureDetector(
                  onLongPress:
                      canUpdate
                          ? () => setState(() => match.teem2Score++)
                          : null,
                  child: Text(match.team2, textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
