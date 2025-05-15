// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';
// import 'package:youth_center/core/routes/routes.dart';
// import 'package:youth_center/screen/home/home_screen.dart';


// class AppRouter {
//   final Function(Locale) changeLanguage;
//   AppRouter(this.changeLanguage);
//   Route generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       // case Routes.noInternetScreen:
//       //   return MaterialPageRoute(
//       //     builder: (_) => NoInternetScreen(),
//       //   );
//       case Routes.homeScreen:
//         return MaterialPageRoute(
//           builder: (_) => 
//              HomeScreen(
//               changeLanguage: changeLanguage,
//             ),
          
//         );
//       case Routes.departuresScreen:
//         final arguments = settings.arguments as String?;

//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (context) => getIt<DepartureCubit>(),
//             child: DeparturesScreen(
//               changeLanguage: changeLanguage,
//               departureType: arguments,
//             ),
//           ),
//         );
//       case Routes.attendaceScreen:
//         return MaterialPageRoute(
//           builder: (_) => MultiBlocProvider(
//             providers: [
//               BlocProvider(create: (context) => getIt<AttendanceCubit>()),
//               BlocProvider(create: (context) => getIt<SendAttendanceCubit>()),
//             ],
//             child: Attendance(
//               changeLanguage: changeLanguage,
//             ),
//           ),
//         );

//       case Routes.loginScreen:
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (context) => getIt<LoginCubit>(),
//             child: LoginScreen(
//               changeLanguage: changeLanguage,
//             ),
//           ),
//         );

//       case Routes.forgetPasswordSccreen:
//         return MaterialPageRoute(
//             builder: (_) => BlocProvider(
//                   create: (context) => getIt<FrogetPasswordCubit>(),
//                   child: ForgetPassword(
//                     changeLanguage: changeLanguage,
//                   ),
//                 ));

//       case Routes.homeScreen:
//         return MaterialPageRoute(
//             builder: (_) => MultiBlocProvider(providers: [
//                   BlocProvider(create: (context) => getIt<HomeCubit>()),
//                   BlocProvider(create: (context) => getIt<EventsCubit>()),
//                 ], child: HomeScreen(changeLanguage: changeLanguage)));

//       case Routes.detailedReportScreen:
//         return MaterialPageRoute(
//             builder: (_) => BlocProvider(
//                   create: (context) => getIt<ReportsCubit>(),
//                   child: DetailedReportScreen(
//                     changeLanguage: changeLanguage,
//                   ),
//                 ));
//       case Routes.overAllReportScreen:
//         return MaterialPageRoute(
//             builder: (_) => BlocProvider(
//                   create: (context) => getIt<ReportsCubit>(),
//                   child: OverAllReportScreen(
//                     changeLanguage: changeLanguage,
//                   ),
//                 ));
//       case Routes.permissionReportScreen:
//         return MaterialPageRoute(
//             builder: (_) => MultiBlocProvider(
//                   providers: [
//                     BlocProvider(
//                         create: (context) => getIt<PermissionReportCubit>()),
//                     BlocProvider(
//                         create: (context) => getIt<AllVaccationsCubit>()),
//                   ],
//                   child: PermissionReportScreen(
//                     isPermission: true,
//                   ),
//                 ));
//       case Routes.vaccationsReportScreen:
//         return MaterialPageRoute(
//             builder:(_) => MultiBlocProvider(
//                   providers: [
//                     BlocProvider(
//                         create: (context) => getIt<PermissionReportCubit>()),
//                     BlocProvider(
//                         create: (context) => getIt<AllVaccationsCubit>()),
//                   ],
//                   child: PermissionReportScreen(
//                     isPermission: false,
//                   ),
//                 ));
//       case Routes.notificationScreen:
//         return MaterialPageRoute(
//             builder: (_) => BlocProvider(
//                   create: (context) => getIt<EventsCubit>(),
//                   child: NotificationScreen(
//                     changeLanguage: changeLanguage,
//                   ),
//                 ));
//       case Routes.profileScreen:
//         return MaterialPageRoute(
//             builder: (_) => BlocProvider(
//                   create: (context) => getIt<AppBarCubit>(),
//                   child: UserProfileScreen(
//                     changeLanguage: changeLanguage,
//                   ),
//                 ));
//       case Routes.employeeInfoScreen:
//         final arguments = settings.arguments as int?;
//         log(arguments.toString());
//         return MaterialPageRoute(
//             builder: (_) => BlocProvider(
//                   create: (context) => getIt<AppBarCubit>(),
//                   child: EmployeeInfoWidget(
//                     pageIndex: arguments ?? 0,
//                   ),
//                 ));
//       case Routes.vacationFormScreen:
//         final arguments = settings.arguments as Map<String, dynamic>?;
//         return MaterialPageRoute(
//             builder: (_) => MultiBlocProvider(
//                     providers: [
//                       BlocProvider(
//                           create: (context) => getIt<RequestVaccationCubit>()),
//                       BlocProvider(
//                           create: (context) => getIt<AllVaccationsCubit>()),
//                       BlocProvider(
//                           create: (context) => getIt<PermissionCubit>()),
//                       BlocProvider(
//                           create: (context) => getIt<DepartureCubit>()),
//                       ChangeNotifierProvider(
//                           create: (context) => CheckboxState()),
//                     ],
//                     child: VacationForm(
//                       changeLanguage: changeLanguage,
//                       departureModel: arguments?["departureModel"],
//                     )));
//       case Routes.permissionScreen:
//         final arguments = settings.arguments as Map<String, dynamic>?;

//         return MaterialPageRoute(
//             builder: (_) => MultiBlocProvider(
//                     providers: [
//                       BlocProvider(
//                           create: (context) => getIt<RequestVaccationCubit>()),
//                       BlocProvider(
//                           create: (context) => getIt<AllVaccationsCubit>()),
//                       BlocProvider(
//                           create: (context) => getIt<PermissionCubit>()),
//                       BlocProvider(
//                           create: (context) => getIt<DepartureCubit>()),
//                       ChangeNotifierProvider(
//                           create: (context) => CheckboxState()),
//                     ],
//                     child: PermissionForm(
//                       changeLanguage: changeLanguage,
//                       departureModel: arguments?["departureModel"],
//                     )));

//       default:
//         return MaterialPageRoute(
//             builder: (_) => Scaffold(
//                   body: Center(
//                     child: Text("no defined Route with name ${settings.name}"),
//                   ),
//                 ));
//     }
//   }
// }
