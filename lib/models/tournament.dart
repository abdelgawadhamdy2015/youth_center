import 'package:cloud_firestore/cloud_firestore.dart';

class Tournament {
  final String? id;
  final String? name;
  final String? description;
  final String? logoUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? registrationDeadline;
  final String? location;
  final int? numberOfTeams;
  final List<String>? ageGroups;
  final String? format;
  final int? minutesPerHalf;
  final int? halftimeMinutes;
  final int? winPoints;
  final int? drawPoints;
  final int? lossPoints;
  final int? minPlayers;
  final int? maxPlayers;
  final String? substitutionRules;
  final bool? offsideRule;
  final bool? cardSystem;
  final bool? extraTime;
  final bool? penaltyShootout;
  final String? customRules;
  final String? scheduling;
  final List<String>? timeSlots;
  final List<String>? venues;
  final String? breakBetweenMatches;
  final DateTime? createdAt;
  final String? createdBy;
  final bool? isPublished;
  final List? teems;
  final List<dynamic>? matches;

  Tournament({
    this.id,
    this.name,
    this.description,
    this.logoUrl,
    this.startDate,
    this.endDate,
    this.registrationDeadline,
    this.location,
    this.numberOfTeams,
    this.ageGroups,
    this.format,
    this.minutesPerHalf,
    this.halftimeMinutes,
    this.winPoints,
    this.drawPoints,
    this.lossPoints,
    this.minPlayers,
    this.maxPlayers,
    this.substitutionRules,
    this.offsideRule,
    this.cardSystem,
    this.extraTime,
    this.penaltyShootout,
    this.customRules,
    this.scheduling,
    this.timeSlots,
    this.venues,
    this.breakBetweenMatches,
    this.createdAt,
    this.createdBy,
    this.isPublished,
    this.teems,
    this.matches,
  });

  // add from snapshot factory 
  factory Tournament.fromSnapshot( DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Tournament(
      id: snapshot.id,
      name: data['name'],
      description: data['description'],
      logoUrl: data['logoUrl'],
      startDate: data['startDate'] != null ? DateTime.parse(data['startDate']) : null,
      endDate: data['endDate'] != null ? DateTime.parse(data['endDate']) : null,
      registrationDeadline: data['registrationDeadline'] != null ? DateTime.parse(data['registrationDeadline']) : null,
      location: data['location'],
      numberOfTeams: data['numberOfTeams'],
      ageGroups: data['ageGroups'] != null ? List<String>.from(data['ageGroups']) : null,
      format: data['format'],
      minutesPerHalf: data['minutesPerHalf'],
      halftimeMinutes: data['halftimeMinutes'],
      winPoints: data['winPoints'],
      drawPoints: data['drawPoints'],
      lossPoints: data['lossPoints'],
      minPlayers: data['minPlayers'],
      maxPlayers: data['maxPlayers'],
      substitutionRules: data['substitutionRules'],
      offsideRule: data['offsideRule'],
      cardSystem: data['cardSystem'],
      extraTime: data['extraTime'],
      penaltyShootout: data['penaltyShootout'],
      customRules: data['customRules'],
      scheduling: data['scheduling'],
      timeSlots: data['timeSlots'] != null ? List<String>.from(data['timeSlots']) : null,
      venues: data['venues'] != null ? List<String>.from(data['venues']) : null,
      breakBetweenMatches: data['breakBetweenMatches'],
      createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      createdBy: data['createdBy'],
      isPublished: data['isPublished'],
      matches: data['matches'],
      teems: data['teems'],
    );
  }
  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'registrationDeadline': registrationDeadline?.toIso8601String(),
      'location': location,
      'numberOfTeams': numberOfTeams,
      'ageGroups': ageGroups,
      'format': format,
      'minutesPerHalf': minutesPerHalf,
      'halftimeMinutes': halftimeMinutes,
      'winPoints': winPoints,
      'drawPoints': drawPoints,
      'lossPoints': lossPoints,
      'minPlayers': minPlayers,
      'maxPlayers': maxPlayers,
      'substitutionRules': substitutionRules,
      'offsideRule': offsideRule,
      'cardSystem': cardSystem,
      'extraTime': extraTime,
      'penaltyShootout': penaltyShootout,
      'customRules': customRules,
      'scheduling': scheduling,
      'timeSlots': timeSlots,
      'venues': venues,
      'breakBetweenMatches': breakBetweenMatches,
      'createdAt': createdAt?.toIso8601String(),
      'createdBy': createdBy,
      'isPublished': isPublished,
      "matches": matches,
      "teems": teems,
    };
  }

  // Create from Firestore document
  factory Tournament.fromMap(Map<String, dynamic> map) {
    return Tournament(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      logoUrl: map['logoUrl'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      registrationDeadline: DateTime.parse(map['registrationDeadline']),
      location: map['location'],
      numberOfTeams: map['numberOfTeams'],
      ageGroups: List<String>.from(map['ageGroups']),
      format: map['format'],
      minutesPerHalf: map['minutesPerHalf'],
      halftimeMinutes: map['halftimeMinutes'],
      winPoints: map['winPoints'],
      drawPoints: map['drawPoints'],
      lossPoints: map['lossPoints'],
      minPlayers: map['minPlayers'],
      maxPlayers: map['maxPlayers'],
      substitutionRules: map['substitutionRules'],
      offsideRule: map['offsideRule'],
      cardSystem: map['cardSystem'],
      extraTime: map['extraTime'],
      penaltyShootout: map['penaltyShootout'],
      customRules: map['customRules'],
      scheduling: map['scheduling'],
      timeSlots: List<String>.from(map['timeSlots']),
      venues: List<String>.from(map['venues']),
      breakBetweenMatches: map['breakBetweenMatches'],
      createdAt: DateTime.parse(map['createdAt']),
      createdBy: map['createdBy'],
      isPublished: map['isPublished'],
      matches: map['matches'],
      teems: map['teams'],
    );
  }
}
