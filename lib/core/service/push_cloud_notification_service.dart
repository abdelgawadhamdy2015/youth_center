// import 'dart:convert';
// import 'dart:developer';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:youth_center/core/helper/my_constants.dart';
// import 'package:youth_center/core/helper/shared_pref_helper.dart';
// import 'package:youth_center/core/service/local_notification_service.dart';

// class PushCloudNotificationService {
//   static FirebaseMessaging messaging = FirebaseMessaging.instance;

//   static Future init() async {
//     await messaging.requestPermission();
//     String? token = await messaging.getToken();
//     await SharedPrefHelper.setData(MyConstants.deviceToken, token);

//     log(token ?? "null");
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//     // forground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       LocalNotificationService().showNotification(message);
//     });
//   }

//   static Future<void> handleBackgroundMessage(RemoteMessage message) async {
//     await Firebase.initializeApp();
//     log(message.notification?.title ?? "no title");
//   }

//   static Future<String> getAccessToken() async {
//     final serviceAcountJson = dotenv.env['serviceAcountJson'];
//     log(serviceAcountJson.toString());
//     // final serviceAcountJson = {
//     //   "type": "service_account",
//     //   "project_id": "apex-attendance-8e503",
//     //   "private_key_id": "2dc34ddbded0448d5dbdd2f440870626ac60ae93",
//     //   "private_key":
//     //       "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCNo/INsKXmgm3A\nIxiRpLux2N9yTw8yCR2cM13At/767Nhg4a8h5tIOz14Rz8M/hmoM3xmhk2fmi65O\ngDKltNPboBxaKMxADAe0d7a3g7cSyJpTFpdu0ctl73ef23IodwzdJTEsLzs6/ish\nugUVpbfrr2XOMgz55BSNhCPEomsdLBTc9RPcqWAO5Q1Jhoj4K4b6O3873T7Bhyiy\nd7kv+PF58zCeRq9Ow+gGpAO3O7BamMr36FruGt8gITkkHn3hGWjTFCEdTvdoT/3c\n8adXALnH7zsPfnCumRvYJEus71H9DfWI1faRN75IAysdFT3Isj/39oLoxUVoScAP\nUPqMadMBAgMBAAECggEARkIfFNxdhriG8UpXaxNQSVlfCUgfLP4pkmxGYozCbbyj\nXndEVKg25ULGkkZBPxcRLt5Ry/yfCtSZu3XK6biHaIeE2NIo8tIk1keVunUbEDWy\nm2l253EomCFPcNu9RkY7eszylcy98DbYtUudLw47a6ze7oeUOTaCXWpBBc5dHKQe\nmhHsGEvfMLsYZIoZFqnLoEGtKEtmWcRaciXVRebdAITOfNznOIuSAEDFtsWjShPr\nUBsJkKessjbR71P/8Y0Bq9aXwDXmZ8Zj174QmLaypxMMBcwuNb4CFpa5nS9Yf6Ik\nk52GTSShY/mmTLnlhPLM87qCwLebzaqZ+Toxw6OCGwKBgQDEdQMeQwKTKPfPAb8f\nw87C7+WN1Eqo1X/J3rdDyFZTwg5SBVtNowNRgySqgGU4JQ90/UdFkd68KyXz4EbN\nob+vWNu2GtTKShBD69t6Ldn3sl9NtluvNJUkpywt8o0S2mi12ADDAvLvpe6gMlNm\n3y1Sslmi/2NgnPAEq+vLmNYAswKBgQC4kb2lNj1TFsWy3NysDVzuzOvUcu197g4R\n+/Zr9wcMhcShOSdzSI/pvZSORlIn1yubLN058wdeRnZtpmurtw+El0/eX8D6bSEN\nhUPE6kCm2MxWoOLP00J1OUlaA8kjXWMOErl1epUINZiG8fQJL8CsmXDlytlExF7F\nUuFdur8PewKBgAp3wabHI0f8Etgw26IxqL6yUaTw/tloJtr2xwURk6f62xB7wJWu\nberV9govtTT8pIozRKzsTNXx5p/L/3nNeI07Stm1LElrENrNonAsKUUNeA6H/PKk\n9p1xWuVH20R55sJptACwE4m5abGXfOIqWhvh7OzGduEa+58EGhhLGHwJAoGAJnqD\n3hCrwknKF5sCCoCSslpYhCcdqhZaKper7SBIAO1WbAI9XkRvdFyIvwycDiBGwAgf\navhmvdnU0NFUOy1j99GP3h16XvsnW+k/kqr/pYknOJw8DPXPMh8qUrDdWxkaEJII\nxhwzO83oqaGBrfSdp54psk6S80o5M8wundrUAEcCgYEAuU3m86Ql6Z+nEaEU4CUJ\n0kpBIbod/f6UqDIJo2xaP0vyV9s01ZP4l8EIU5DSgd0xCvRKTq0b1vTUr6s3hsTJ\n2aDP05RRM1e59BUS1XuKXcQkQtrfFc1VAjlP6D5Lw3mwBbZgPY1lh1qHpY99uMq1\nAugs0raKhnBS8AbUfo22heU=\n-----END PRIVATE KEY-----\n",
//     //   "client_email":
//     //       "apex-attendance@apex-attendance-8e503.iam.gserviceaccount.com",
//     //   "client_id": "105386528691454947476",
//     //   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//     //   "token_uri": "https://oauth2.googleapis.com/token",
//     //   "auth_provider_x509_cert_url":
//     //       "https://www.googleapis.com/oauth2/v1/certs",
//     //   "client_x509_cert_url":
//     //       "https://www.googleapis.com/robot/v1/metadata/x509/apex-attendance%40apex-attendance-8e503.iam.gserviceaccount.com",
//     //   "universe_domain": "googleapis.com"
//     // };
//     List<String> scopes = [
//       "https://www.googleapis.com/auth/userinfo.email",
//       "https://www.googleapis.com/auth/firebase.database",
//       "https://www.googleapis.com/auth/firebase.messaging"
//     ];
//     http.Client client = await auth.clientViaServiceAccount(
//         auth.ServiceAccountCredentials.fromJson(serviceAcountJson), scopes);
//     // get the access  token
//     auth.AccessCredentials credentials =
//         await auth.obtainAccessCredentialsViaServiceAccount(
//       auth.ServiceAccountCredentials.fromJson(serviceAcountJson),
//       scopes,
//       client,
//     );
//     client.close();
//     return credentials.accessToken.data;
//   }

//   static sendNotificationToAdmin(
//     String deviceToken,
//     BuildContext context,
//     String tripId,
//     String messageSender,
//     String messageBody,
//   ) async {
//     final String serverAccessTokenKey = await getAccessToken();
//     String endPointFirebaseCloudMessaging =
//         'https://fcm.googleapis.com/v1/projects/apex-attendance-8e503/messages:send';

//     final Map<String, dynamic> message = {
//       'message': {
//         'token': deviceToken,
//         'notification': {'title': messageSender, 'body': messageBody},
//         'data': {
//           'tripId': tripId,
//         }
//       }
//     };

//     final http.Response response =
//         await http.post(Uri.parse(endPointFirebaseCloudMessaging),
//             headers: <String, String>{
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $serverAccessTokenKey'
//             },
//             body: jsonEncode(message));
//     if (response.statusCode == 200) {
//       log('Notification send successfully');
//     } else {
//       log('Send notification faild: ${response.statusCode}');
//     }
//   }
// }
