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

  /// `User Name`
  String get username {
    return Intl.message('User Name', name: 'username', desc: '', args: []);
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `not have account yet?`
  String get notHaveAccount {
    return Intl.message(
      'not have account yet?',
      name: 'notHaveAccount',
      desc: '',
      args: [],
    );
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
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
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
