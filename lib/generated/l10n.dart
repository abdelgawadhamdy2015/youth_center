// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Group `
  String get group {
    return Intl.message('Group ', name: 'group', desc: '', args: []);
  }

  /// `Group 1`
  String get group1 {
    return Intl.message('Group 1', name: 'group1', desc: '', args: []);
  }

  /// `Group 2`
  String get group2 {
    return Intl.message('Group 2', name: 'group2', desc: '', args: []);
  }

  /// `Group 3`
  String get group3 {
    return Intl.message('Group 3', name: 'group3', desc: '', args: []);
  }

  /// `Group 4`
  String get group4 {
    return Intl.message('Group 4', name: 'group4', desc: '', args: []);
  }

  /// `Group 5`
  String get group5 {
    return Intl.message('Group 5', name: 'group5', desc: '', args: []);
  }

  /// `Group 6`
  String get group6 {
    return Intl.message('Group 6', name: 'group6', desc: '', args: []);
  }

  /// `Group 7`
  String get group7 {
    return Intl.message('Group 7', name: 'group7', desc: '', args: []);
  }

  /// `Group 8`
  String get group8 {
    return Intl.message('Group 8', name: 'group8', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Finished`
  String get finished {
    return Intl.message('Finished', name: 'finished', desc: '', args: []);
  }

  /// `active`
  String get active {
    return Intl.message('active', name: 'active', desc: '', args: []);
  }

  /// `Tournament Name`
  String get cupName {
    return Intl.message('Tournament Name', name: 'cupName', desc: '', args: []);
  }

  /// `Youth Center`
  String get appName {
    return Intl.message('Youth Center', name: 'appName', desc: '', args: []);
  }

  /// ` saved successfully`
  String get successSave {
    return Intl.message(
      ' saved successfully',
      name: 'successSave',
      desc: '',
      args: [],
    );
  }

  /// `no elements`
  String get noElemnts {
    return Intl.message('no elements', name: 'noElemnts', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Enter Password`
  String get enterPassword {
    return Intl.message(
      'Enter Password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get username {
    return Intl.message('User Name', name: 'username', desc: '', args: []);
  }

  /// `Enter User Name`
  String get enterUsername {
    return Intl.message(
      'Enter User Name',
      name: 'enterUsername',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Sign Up`
  String get signup {
    return Intl.message('Sign Up', name: 'signup', desc: '', args: []);
  }

  /// `Please enter all team names`
  String get enterNames {
    return Intl.message(
      'Please enter all team names',
      name: 'enterNames',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a tournament name`
  String get enterCupName {
    return Intl.message(
      'Please enter a tournament name',
      name: 'enterCupName',
      desc: '',
      args: [],
    );
  }

  /// `Create Tournament`
  String get createCup {
    return Intl.message(
      'Create Tournament',
      name: 'createCup',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get entername {
    return Intl.message('Name', name: 'entername', desc: '', args: []);
  }

  /// `Mobile`
  String get enterMobile {
    return Intl.message('Mobile', name: 'enterMobile', desc: '', args: []);
  }

  /// `Start Time`
  String get enterStartTime {
    return Intl.message(
      'Start Time',
      name: 'enterStartTime',
      desc: '',
      args: [],
    );
  }

  /// `End Time`
  String get enterEndTime {
    return Intl.message('End Time', name: 'enterEndTime', desc: '', args: []);
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Tournament`
  String get tournament {
    return Intl.message('Tournament', name: 'tournament', desc: '', args: []);
  }

  /// `Start Date`
  String get startDate {
    return Intl.message('Start Date', name: 'startDate', desc: '', args: []);
  }

  /// `Team Configuration`
  String get teamConfiguration {
    return Intl.message(
      'Team Configuration',
      name: 'teamConfiguration',
      desc: '',
      args: [],
    );
  }

  /// `Number of Teams`
  String get numberOfTeams {
    return Intl.message(
      'Number of Teams',
      name: 'numberOfTeams',
      desc: '',
      args: [],
    );
  }

  /// `Distribution Mode: `
  String get distributionMode {
    return Intl.message(
      'Distribution Mode: ',
      name: 'distributionMode',
      desc: '',
      args: [],
    );
  }

  /// `Random`
  String get random {
    return Intl.message('Random', name: 'random', desc: '', args: []);
  }

  /// `Manual`
  String get manual {
    return Intl.message('Manual', name: 'manual', desc: '', args: []);
  }

  /// `Team`
  String get team {
    return Intl.message('Team', name: 'team', desc: '', args: []);
  }

  /// `Required`
  String get required {
    return Intl.message('Required', name: 'required', desc: '', args: []);
  }

  /// `Groups Distribution`
  String get groupsDistribution {
    return Intl.message(
      'Groups Distribution',
      name: 'groupsDistribution',
      desc: '',
      args: [],
    );
  }

  /// `Generated Matches`
  String get generatedMatches {
    return Intl.message(
      'Generated Matches',
      name: 'generatedMatches',
      desc: '',
      args: [],
    );
  }

  /// `No matches generated yet`
  String get NoMatches {
    return Intl.message(
      'No matches generated yet',
      name: 'NoMatches',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message('Reset', name: 'reset', desc: '', args: []);
  }

  /// `Save Tournament`
  String get saveTournament {
    return Intl.message(
      'Save Tournament',
      name: 'saveTournament',
      desc: '',
      args: [],
    );
  }

  /// `Generate Matches`
  String get generateMatches {
    return Intl.message(
      'Generate Matches',
      name: 'generateMatches',
      desc: '',
      args: [],
    );
  }

  /// `Distribute Teams`
  String get distributeTeams {
    return Intl.message(
      'Distribute Teams',
      name: 'distributeTeams',
      desc: '',
      args: [],
    );
  }

  /// `No data`
  String get noData {
    return Intl.message('No data', name: 'noData', desc: '', args: []);
  }

  /// `Some thing went wrong`
  String get wrong {
    return Intl.message(
      'Some thing went wrong',
      name: 'wrong',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message('From', name: 'from', desc: '', args: []);
  }

  /// `To`
  String get to {
    return Intl.message('To', name: 'to', desc: '', args: []);
  }

  /// `Bookings`
  String get bookings {
    return Intl.message('Bookings', name: 'bookings', desc: '', args: []);
  }

  /// `Tournaments`
  String get tournaments {
    return Intl.message('Tournaments', name: 'tournaments', desc: '', args: []);
  }

  /// `My Account`
  String get myAccount {
    return Intl.message('My Account', name: 'myAccount', desc: '', args: []);
  }

  /// `Add Booking`
  String get addBooking {
    return Intl.message('Add Booking', name: 'addBooking', desc: '', args: []);
  }

  /// `LogOut`
  String get logOut {
    return Intl.message('LogOut', name: 'logOut', desc: '', args: []);
  }

  /// `LogIn`
  String get login {
    return Intl.message('LogIn', name: 'login', desc: '', args: []);
  }

  /// `Active Cup Matches`
  String get activeCupMatches {
    return Intl.message(
      'Active Cup Matches',
      name: 'activeCupMatches',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? Sign Up`
  String get DonotHaveAccount {
    return Intl.message(
      'Don\'t have an account? Sign Up',
      name: 'DonotHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `user registered successfully `
  String get userRegistered {
    return Intl.message(
      'user registered successfully ',
      name: 'userRegistered',
      desc: '',
      args: [],
    );
  }

  /// `already have account? `
  String get alreadyHaveAccount {
    return Intl.message(
      'already have account? ',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `SignIn`
  String get signIn {
    return Intl.message('SignIn', name: 'signIn', desc: '', args: []);
  }

  /// `Home Page`
  String get homePage {
    return Intl.message('Home Page', name: 'homePage', desc: '', args: []);
  }

  /// `Profile updated successfully`
  String get profileUpdated {
    return Intl.message(
      'Profile updated successfully',
      name: 'profileUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Please Fill all fields`
  String get pleaseFill {
    return Intl.message(
      'Please Fill all fields',
      name: 'pleaseFill',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get monday {
    return Intl.message('Monday', name: 'monday', desc: '', args: []);
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message('Tuesday', name: 'tuesday', desc: '', args: []);
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message('Wednesday', name: 'wednesday', desc: '', args: []);
  }

  /// `Thursday`
  String get thursday {
    return Intl.message('Thursday', name: 'thursday', desc: '', args: []);
  }

  /// `Friday`
  String get friday {
    return Intl.message('Friday', name: 'friday', desc: '', args: []);
  }

  /// `Saturday`
  String get saturday {
    return Intl.message('Saturday', name: 'saturday', desc: '', args: []);
  }

  /// `Sunday`
  String get sunday {
    return Intl.message('Sunday', name: 'sunday', desc: '', args: []);
  }

  /// `Select a day`
  String get selectDay {
    return Intl.message('Select a day', name: 'selectDay', desc: '', args: []);
  }

  /// `Select a center`
  String get selectCenter {
    return Intl.message(
      'Select a center',
      name: 'selectCenter',
      desc: '',
      args: [],
    );
  }

  /// `Mobile`
  String get mobile {
    return Intl.message('Mobile', name: 'mobile', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Request Booking`
  String get requestBooking {
    return Intl.message(
      'Request Booking',
      name: 'requestBooking',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get enterValidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'enterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid mobile number`
  String get enterValidMobile {
    return Intl.message(
      'Please enter a valid mobile number',
      name: 'enterValidMobile',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid password`
  String get enterValidPassword {
    return Intl.message(
      'Please enter a valid password',
      name: 'enterValidPassword',
      desc: '',
      args: [],
    );
  }

  /// `Requests`
  String get requests {
    return Intl.message('Requests', name: 'requests', desc: '', args: []);
  }

  /// `Request accepted successfully`
  String get requestAccepted {
    return Intl.message(
      'Request accepted successfully',
      name: 'requestAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Request rejected successfully`
  String get requestRejected {
    return Intl.message(
      'Request rejected successfully',
      name: 'requestRejected',
      desc: '',
      args: [],
    );
  }

  /// `Request deleted successfully`
  String get requestDeleted {
    return Intl.message(
      'Request deleted successfully',
      name: 'requestDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Request is pending`
  String get requestPending {
    return Intl.message(
      'Request is pending',
      name: 'requestPending',
      desc: '',
      args: [],
    );
  }

  /// `Request rejected by admin`
  String get requestRejectedByAdmin {
    return Intl.message(
      'Request rejected by admin',
      name: 'requestRejectedByAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Request accepted by admin`
  String get requestAcceptedByAdmin {
    return Intl.message(
      'Request accepted by admin',
      name: 'requestAcceptedByAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Request not found`
  String get requestNotFound {
    return Intl.message(
      'Request not found',
      name: 'requestNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Request already exists`
  String get requestAlreadyExists {
    return Intl.message(
      'Request already exists',
      name: 'requestAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Reject`
  String get reject {
    return Intl.message('Reject', name: 'reject', desc: '', args: []);
  }

  /// `Delete Request`
  String get deleteRequest {
    return Intl.message(
      'Delete Request',
      name: 'deleteRequest',
      desc: '',
      args: [],
    );
  }

  /// `Booking Day`
  String get bookingDay {
    return Intl.message('Booking Day', name: 'bookingDay', desc: '', args: []);
  }

  /// `Request Date`
  String get requestDate {
    return Intl.message(
      'Request Date',
      name: 'requestDate',
      desc: '',
      args: [],
    );
  }

  /// `Booking Time`
  String get bookingTime {
    return Intl.message(
      'Booking Time',
      name: 'bookingTime',
      desc: '',
      args: [],
    );
  }

  /// `End Date`
  String get endDate {
    return Intl.message('End Date', name: 'endDate', desc: '', args: []);
  }

  /// `Registration Deadline`
  String get registrationDeadline {
    return Intl.message(
      'Registration Deadline',
      name: 'registrationDeadline',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Tournament Format`
  String get tournamentFormat {
    return Intl.message(
      'Tournament Format',
      name: 'tournamentFormat',
      desc: '',
      args: [],
    );
  }

  /// `Please enter number of teams`
  String get enterNumberOfTeams {
    return Intl.message(
      'Please enter number of teams',
      name: 'enterNumberOfTeams',
      desc: '',
      args: [],
    );
  }

  /// `Age Groups`
  String get ageGroups {
    return Intl.message('Age Groups', name: 'ageGroups', desc: '', args: []);
  }

  /// `Group Stage + Knockout`
  String get groupStageKnockout {
    return Intl.message(
      'Group Stage + Knockout',
      name: 'groupStageKnockout',
      desc: '',
      args: [],
    );
  }

  /// `Knockout Only`
  String get knockoutOnly {
    return Intl.message(
      'Knockout Only',
      name: 'knockoutOnly',
      desc: '',
      args: [],
    );
  }

  /// `League Format`
  String get leagueFormat {
    return Intl.message(
      'League Format',
      name: 'leagueFormat',
      desc: '',
      args: [],
    );
  }

  /// `Round Robin`
  String get roundRobin {
    return Intl.message('Round Robin', name: 'roundRobin', desc: '', args: []);
  }

  /// `please select format`
  String get selectFormat {
    return Intl.message(
      'please select format',
      name: 'selectFormat',
      desc: '',
      args: [],
    );
  }

  /// `Match Duration`
  String get matchDuration {
    return Intl.message(
      'Match Duration',
      name: 'matchDuration',
      desc: '',
      args: [],
    );
  }

  /// `Minutes per Half`
  String get minutesPerHalf {
    return Intl.message(
      'Minutes per Half',
      name: 'minutesPerHalf',
      desc: '',
      args: [],
    );
  }

  /// `Halftime (minutes)`
  String get halftimeMinutes {
    return Intl.message(
      'Halftime (minutes)',
      name: 'halftimeMinutes',
      desc: '',
      args: [],
    );
  }

  /// `Points System`
  String get pointsSystem {
    return Intl.message(
      'Points System',
      name: 'pointsSystem',
      desc: '',
      args: [],
    );
  }

  /// `Win`
  String get win {
    return Intl.message('Win', name: 'win', desc: '', args: []);
  }

  /// `Draw`
  String get draw {
    return Intl.message('Draw', name: 'draw', desc: '', args: []);
  }

  /// `Loss`
  String get loss {
    return Intl.message('Loss', name: 'loss', desc: '', args: []);
  }

  /// `Rules & Settings`
  String get rulesSettings {
    return Intl.message(
      'Rules & Settings',
      name: 'rulesSettings',
      desc: '',
      args: [],
    );
  }

  /// `Team Size Limits`
  String get teamSizeLimits {
    return Intl.message(
      'Team Size Limits',
      name: 'teamSizeLimits',
      desc: '',
      args: [],
    );
  }

  /// `Min Players`
  String get minPlayers {
    return Intl.message('Min Players', name: 'minPlayers', desc: '', args: []);
  }

  /// `Max Players`
  String get maxPlayers {
    return Intl.message('Max Players', name: 'maxPlayers', desc: '', args: []);
  }

  /// `Substitution Rules`
  String get substitutionRules {
    return Intl.message(
      'Substitution Rules',
      name: 'substitutionRules',
      desc: '',
      args: [],
    );
  }

  /// `3 Substitutions`
  String get threeSubstitutions {
    return Intl.message(
      '3 Substitutions',
      name: 'threeSubstitutions',
      desc: '',
      args: [],
    );
  }

  /// `5 Substitutions`
  String get fiveSubstitutions {
    return Intl.message(
      '5 Substitutions',
      name: 'fiveSubstitutions',
      desc: '',
      args: [],
    );
  }

  /// `Rolling Substitutions`
  String get rollingSubstitutions {
    return Intl.message(
      'Rolling Substitutions',
      name: 'rollingSubstitutions',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited Substitutions`
  String get unlimitedSubstitutions {
    return Intl.message(
      'Unlimited Substitutions',
      name: 'unlimitedSubstitutions',
      desc: '',
      args: [],
    );
  }

  /// `Basic Information`
  String get basicInformation {
    return Intl.message(
      'Basic Information',
      name: 'basicInformation',
      desc: '',
      args: [],
    );
  }

  /// `Upload Logo`
  String get uploadLogo {
    return Intl.message('Upload Logo', name: 'uploadLogo', desc: '', args: []);
  }

  /// `Recommended size: 200x200px, Max: 2MB`
  String get recommendedSize {
    return Intl.message(
      'Recommended size: 200x200px, Max: 2MB',
      name: 'recommendedSize',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Please select a location`
  String get pleaseSelectLocation {
    return Intl.message(
      'Please select a location',
      name: 'pleaseSelectLocation',
      desc: '',
      args: [],
    );
  }

  /// `Tournament Preview`
  String get tournamentPreview {
    return Intl.message(
      'Tournament Preview',
      name: 'tournamentPreview',
      desc: '',
      args: [],
    );
  }

  /// `Format`
  String get format {
    return Intl.message('Format', name: 'format', desc: '', args: []);
  }

  /// `Teams`
  String get teams {
    return Intl.message('Teams', name: 'teams', desc: '', args: []);
  }

  /// `Age Groups`
  String get ageGroupsLabel {
    return Intl.message(
      'Age Groups',
      name: 'ageGroupsLabel',
      desc: '',
      args: [],
    );
  }

  /// `{minutes} min halves`
  String minHalves(Object minutes) {
    return Intl.message(
      '$minutes min halves',
      name: 'minHalves',
      desc: '',
      args: [minutes],
    );
  }

  /// `{points} pts win`
  String ptsWin(Object points) {
    return Intl.message(
      '$points pts win',
      name: 'ptsWin',
      desc: '',
      args: [points],
    );
  }

  /// `{players} players`
  String players(Object players) {
    return Intl.message(
      '$players players',
      name: 'players',
      desc: '',
      args: [players],
    );
  }

  /// `Description`
  String get descriptionLabel {
    return Intl.message(
      'Description',
      name: 'descriptionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Save as Draft`
  String get saveAsDraft {
    return Intl.message(
      'Save as Draft',
      name: 'saveAsDraft',
      desc: '',
      args: [],
    );
  }

  /// `Publish Tournament`
  String get publishTournament {
    return Intl.message(
      'Publish Tournament',
      name: 'publishTournament',
      desc: '',
      args: [],
    );
  }

  /// `Tournament Created!`
  String get tournamentCreated {
    return Intl.message(
      'Tournament Created!',
      name: 'tournamentCreated',
      desc: '',
      args: [],
    );
  }

  /// `Your tournament has been successfully created and published.`
  String get tournamentCreatedMsg {
    return Intl.message(
      'Your tournament has been successfully created and published.',
      name: 'tournamentCreatedMsg',
      desc: '',
      args: [],
    );
  }

  /// `Go to Tournaments`
  String get goToTournaments {
    return Intl.message(
      'Go to Tournaments',
      name: 'goToTournaments',
      desc: '',
      args: [],
    );
  }

  /// `Match Rules`
  String get matchRules {
    return Intl.message('Match Rules', name: 'matchRules', desc: '', args: []);
  }

  /// `Offside rule applies`
  String get offsideRule {
    return Intl.message(
      'Offside rule applies',
      name: 'offsideRule',
      desc: '',
      args: [],
    );
  }

  /// `Yellow/red card system`
  String get cardSystem {
    return Intl.message(
      'Yellow/red card system',
      name: 'cardSystem',
      desc: '',
      args: [],
    );
  }

  /// `Extra time for knockout matches`
  String get extraTime {
    return Intl.message(
      'Extra time for knockout matches',
      name: 'extraTime',
      desc: '',
      args: [],
    );
  }

  /// `Penalty shootout if tied after extra time`
  String get penaltyShootout {
    return Intl.message(
      'Penalty shootout if tied after extra time',
      name: 'penaltyShootout',
      desc: '',
      args: [],
    );
  }

  /// `Custom Rules`
  String get customRules {
    return Intl.message(
      'Custom Rules',
      name: 'customRules',
      desc: '',
      args: [],
    );
  }

  /// `Schedule Configuration`
  String get scheduleConfiguration {
    return Intl.message(
      'Schedule Configuration',
      name: 'scheduleConfiguration',
      desc: '',
      args: [],
    );
  }

  /// `Match Scheduling`
  String get matchScheduling {
    return Intl.message(
      'Match Scheduling',
      name: 'matchScheduling',
      desc: '',
      args: [],
    );
  }

  /// `Auto-generate schedule`
  String get autoGenerateSchedule {
    return Intl.message(
      'Auto-generate schedule',
      name: 'autoGenerateSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Manual scheduling`
  String get manualScheduling {
    return Intl.message(
      'Manual scheduling',
      name: 'manualScheduling',
      desc: '',
      args: [],
    );
  }

  /// `Available Time Slots`
  String get availableTimeSlots {
    return Intl.message(
      'Available Time Slots',
      name: 'availableTimeSlots',
      desc: '',
      args: [],
    );
  }

  /// `Weekday Evenings (17:00 - 21:00)`
  String get weekdayEvenings {
    return Intl.message(
      'Weekday Evenings (17:00 - 21:00)',
      name: 'weekdayEvenings',
      desc: '',
      args: [],
    );
  }

  /// `Saturday Morning (09:00 - 13:00)`
  String get saturdayMorning {
    return Intl.message(
      'Saturday Morning (09:00 - 13:00)',
      name: 'saturdayMorning',
      desc: '',
      args: [],
    );
  }

  /// `Saturday Afternoon (14:00 - 18:00)`
  String get saturdayAfternoon {
    return Intl.message(
      'Saturday Afternoon (14:00 - 18:00)',
      name: 'saturdayAfternoon',
      desc: '',
      args: [],
    );
  }

  /// `Venue Allocation`
  String get venueAllocation {
    return Intl.message(
      'Venue Allocation',
      name: 'venueAllocation',
      desc: '',
      args: [],
    );
  }

  /// `Main Field`
  String get mainField {
    return Intl.message('Main Field', name: 'mainField', desc: '', args: []);
  }

  /// `Indoor Court`
  String get indoorCourt {
    return Intl.message(
      'Indoor Court',
      name: 'indoorCourt',
      desc: '',
      args: [],
    );
  }

  /// `Training Ground`
  String get trainingGround {
    return Intl.message(
      'Training Ground',
      name: 'trainingGround',
      desc: '',
      args: [],
    );
  }

  /// `Break Between Matches`
  String get breakBetweenMatches {
    return Intl.message(
      'Break Between Matches',
      name: 'breakBetweenMatches',
      desc: '',
      args: [],
    );
  }

  /// `15 minutes`
  String get minutes15 {
    return Intl.message('15 minutes', name: 'minutes15', desc: '', args: []);
  }

  /// `30 minutes`
  String get minutes30 {
    return Intl.message('30 minutes', name: 'minutes30', desc: '', args: []);
  }

  /// `45 minutes`
  String get minutes45 {
    return Intl.message('45 minutes', name: 'minutes45', desc: '', args: []);
  }

  /// `60 minutes`
  String get minutes60 {
    return Intl.message('60 minutes', name: 'minutes60', desc: '', args: []);
  }

  /// `Under 12`
  String get under12 {
    return Intl.message('Under 12', name: 'under12', desc: '', args: []);
  }

  /// `Under 14`
  String get under14 {
    return Intl.message('Under 14', name: 'under14', desc: '', args: []);
  }

  /// `Under 16`
  String get under16 {
    return Intl.message('Under 16', name: 'under16', desc: '', args: []);
  }

  /// `Under 18`
  String get under18 {
    return Intl.message('Under 18', name: 'under18', desc: '', args: []);
  }

  /// `Tournament saved as draft`
  String get tournamentSaved {
    return Intl.message(
      'Tournament saved as draft',
      name: 'tournamentSaved',
      desc: '',
      args: [],
    );
  }

  /// `Matches`
  String get matches {
    return Intl.message('Matches', name: 'matches', desc: '', args: []);
  }

  /// `More`
  String get more {
    return Intl.message('More', name: 'more', desc: '', args: []);
  }

  /// `click back again to exit`
  String get clickAgainToExit {
    return Intl.message(
      'click back again to exit',
      name: 'clickAgainToExit',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
