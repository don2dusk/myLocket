import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_locket/screens/screens.dart';
import 'globals.dart' as globals;
import 'utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globals.cameras = await availableCameras();
  FocusManager.instance.primaryFocus?.unfocus();
  await Firebase.initializeApp();
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: backgroundColor,
    ));
  } else if (Platform.isIOS) {
    CupertinoNavigationBar(backgroundColor: backgroundColor);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GetMaterialApp(
      supportedLocales: const [
        Locale('en'),
      ],
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null
          ? const MainScreen()
          : const WelcomeScreen(),
    );
  }
}
