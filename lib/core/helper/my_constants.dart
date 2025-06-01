import 'package:intl/intl.dart';
import 'package:youth_center/models/user_model.dart';

class MyConstants {
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

  static CenterUser? centerUser;

  //collections
  static const String userCollection = 'Users';
  static const String cupCollection = 'Cups';
  static const String bookingCollection = 'Bookings';
  static const String requestCollection = 'BookingRequests';

  static const String youthCenterIdCollection = 'youthCenterId';
  static const String youthCentersCollection = 'youthCenters';

  static const String cupName = 'cupName';
  static const String team1 = 'team1';
  static const String team2 = 'team2';
  static const String team1Score = 'team1Score';
  static const String team2Score = 'team2Score';
  static const String cupStartDate = 'cupStartDate';
  static const String id = "id";
  static const String cupGroup = 'group';

  //images
static const String logoPath = 'images/logo.png';
static const String logoSvg = 'images/logo.svg';



  static const double containerRadius = 25;

static List<String> centerNames=[];

}
