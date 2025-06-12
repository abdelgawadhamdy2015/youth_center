import 'package:intl/intl.dart';
import 'package:youth_center/models/user_model.dart';

class MyConstants {
  static final RegExp emailCharRegExp = RegExp(r'[a-zA-Z0-9@._\-+]');
  static final RegExp arabicCharRegExp = RegExp(r'[\u0600-\u06FF]');
  static final RegExp englishCharRegExp = RegExp(r'[a-zA-Z]');
  static final RegExp numberCharRegExp = RegExp(r'[0-9]');

  //shared pref constants
  static const String prefCenterUser = 'centerUser';
  static const String prefCenterNames = 'CenterNames';

  // status
  static const String finished = 'finished';
  static const String success = 'Success';
  static const String failed = 'Failed';

  static const String arabic = 'ar';
  static const String english = 'en';

  static final DateFormat hourFormat = DateFormat('HH:mm', MyConstants.english);
  static final DateFormat dateFormat = DateFormat(
    'dds-MM-yyyy',
    MyConstants.english,
  );
  static CenterUser? centerUser;
  static const String upComming = "UpComing";
  static const String ongoing = "OnGoing";

  static const String completed = "Completed";

  //collections
  static const String userCollection = 'Users';
  static const String cupCollection = 'Cups';
  static const String bookingCollection = 'Bookings';
  static const String requestCollection = 'BookingRequests';

  static const String youthCenterIdCollection = 'location';
  static const String youthCentersCollection = 'youthCenters';

  static const String cupName = 'cupName';
  static const String team1 = 'team1';
  static const String team2 = 'team2';
  static const String team1Score = 'team1Score';
  static const String team2Score = 'team2Score';
  static const String cupStartDate = 'startDate';
  static const String cupEndDate = 'endDate';
  static const String matchTime = "matchTime";

  static const String id = "id";
  static const String cupGroup = 'group';

  //images
  static const String logoPath = 'images/logo.png';
  static const String logoSvg = 'images/logo.svg';

  static const double containerRadius = 25;

  static List<String> centerNames = [];
}
