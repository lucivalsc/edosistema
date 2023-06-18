import 'package:edo_sistema/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor: const Color.fromRGBO(86, 239, 185, 1),
      systemNavigationBarColor: const Color.fromRGBO(242, 242, 242, 1),
      statusBarBrightness: Brightness.dark,
      //Ícones superior e inferior
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(246, 246, 246, 1),
        appBarTheme: const AppBarTheme(
          color: Color.fromRGBO(86, 239, 185, 1),
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, 45),
            backgroundColor: const Color.fromRGBO(86, 239, 185, 1),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromRGBO(86, 239, 185, 1),
        ),
      ),
      home: const Splash(),
    );
  }
}
