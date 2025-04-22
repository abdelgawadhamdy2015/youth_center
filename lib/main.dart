import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:youth_center/auth.dart';
import 'package:youth_center/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.purple),
        bannerTheme: const MaterialBannerThemeData(),
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,

      home: const Auth(),
    );
  }
}
