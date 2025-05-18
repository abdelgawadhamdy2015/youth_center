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
    final name =
        (locale.countryCode?.isEmpty ?? false)
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

  /// `enter Password`
  String get enterPassword {
    return Intl.message(
      'enter Password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get username {
    return Intl.message('User Name', name: 'username', desc: '', args: []);
  }

  /// ` enter User Name`
  String get enterUsername {
    return Intl.message(
      ' enter User Name',
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

  /// `Creat Tournament`
  String get createCup {
    return Intl.message(
      'Creat Tournament',
      name: 'createCup',
      desc: '',
      args: [],
    );
  }

  /// `enter your Name`
  String get entername {
    return Intl.message(
      'enter your Name',
      name: 'entername',
      desc: '',
      args: [],
    );
  }

  /// `enter your mobile`
  String get enterMobile {
    return Intl.message(
      'enter your mobile',
      name: 'enterMobile',
      desc: '',
      args: [],
    );
  }

  /// `enter start time ex : 22:30`
  String get enterStartTime {
    return Intl.message(
      'enter start time ex : 22:30',
      name: 'enterStartTime',
      desc: '',
      args: [],
    );
  }

  /// `enter end time ex : 22:30`
  String get enterEndTime {
    return Intl.message(
      'enter end time ex : 22:30',
      name: 'enterEndTime',
      desc: '',
      args: [],
    );
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

  /// `Number of Teams: `
  String get numberOfTeams {
    return Intl.message(
      'Number of Teams: ',
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

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
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

  /// `Please Fill`
  String get pleaseFill {
    return Intl.message('Please Fill', name: 'pleaseFill', desc: '', args: []);
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
