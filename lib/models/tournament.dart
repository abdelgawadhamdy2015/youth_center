import 'package:cloud_firestore/cloud_firestore.dart';

class Tournament {
    String? id;
    String? name;
    String? description;
    String? logoUrl;
    DateTime? startDate;
    DateTime? endDate;
    DateTime? registrationDeadline;
    String? location;
    int? numberOfTeams;
    List<String>? ageGroups;
    String? format;
    int? minutesPerHalf;
    int? halftimeMinutes;
    int? winPoints;
    int? drawPoints;
    int? lossPoints;
    int? minPlayers;
    int? maxPlayers;
    String? substitutionRules;
    bool? offsideRule;
    bool? cardSystem;
    bool? extraTime;
    bool? penaltyShootout;
    String? customRules;
    String? scheduling;
    List<String>? timeSlots;
    List<String>? venues;
    String? breakBetweenMatches;
    DateTime? createdAt;
    String? createdBy;
    bool? isPublished;
    List? teams;
    List<dynamic>? matches;
 

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
    this.teams,
    this.matches,
  });

  // add from snapshot factory
  factory Tournament.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Tournament(
      id: snapshot.id,
      name: data['name'],
      description: data['description'],
      logoUrl: data['logoUrl'],
      startDate:
          data['startDate'] != null ? DateTime.parse(data['startDate']) : null,
      endDate: data['endDate'] != null ? DateTime.parse(data['endDate']) : null,
      registrationDeadline:
          data['registrationDeadline'] != null
              ? DateTime.parse(data['registrationDeadline'])
              : null,
      location: data['location'],
      numberOfTeams: data['numberOfTeams'],
      ageGroups:
          data['ageGroups'] != null
              ? List<String>.from(data['ageGroups'])
              : null,
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
      timeSlots:
          data['timeSlots'] != null
              ? List<String>.from(data['timeSlots'])
              : null,
      venues: data['venues'] != null ? List<String>.from(data['venues']) : null,
      breakBetweenMatches: data['breakBetweenMatches'],
      createdAt:
          data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      createdBy: data['createdBy'],
      isPublished: data['isPublished'],
      matches: data['matches'],
      teams: data['teams'],
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
      "teams": teams,
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
      teams: map['teams'],
    );
  }

  Map<String, dynamic> toJson() {
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
      'matches': matches,
      'teams': teams,
    };
  }
}
