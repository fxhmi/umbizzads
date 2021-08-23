import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:umbizz/SplashScreen/splashScreen.dart';



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

      child: Builder(
        builder: (context) => MaterialApp(
          title: "UMBizz",
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ),
      ),
    ) ;
  }
}


