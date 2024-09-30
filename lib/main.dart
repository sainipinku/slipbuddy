import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slipbuddy/bloc_provider/bloc_provider.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/firebase_options.dart';
import 'package:slipbuddy/screen/dashboard/home_screen.dart';
import 'package:slipbuddy/screen/splash.dart';
import 'package:slipbuddy/screen/users/dashboard.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppTheme.statusBar, // Set your desired status bar color here
    statusBarBrightness: Brightness.dark, // For iOS: set the status bar text color to light
    statusBarIconBrightness: Brightness.dark, // For Android: set the status bar icons to light
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return MultiBlocProvider(
      providers: BlocProviders.providers,
      child: ScreenUtilInit(
          designSize: Size(width, height),
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                useMaterial3: false,
                appBarTheme: AppBarTheme(color: AppTheme.primaryColor)
              ),
              home: Splash(),
            );
          }),
    );
  }
}

