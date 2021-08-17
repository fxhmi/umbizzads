import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:umbizz/SplashScreen/splashScreen.dart';
import 'package:umbizz/themes.dart';


Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MyApp()
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {



    return ThemeProvider(
      //initTheme: MyThemes.darkTheme,
      child: Builder(
        builder: (context) => MaterialApp(
          title: "UMBizz",
          debugShowCheckedModeBanner: false,
          //theme: ThemeProvider.of(context),
          home: SplashScreen(),
        ),
      ),
    ) ;
  }
}


