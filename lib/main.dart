import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slipbuddy/bloc_provider/bloc_provider.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/firebase_options.dart';
import 'package:slipbuddy/notification/NotificationService.dart';
import 'package:slipbuddy/screen/dashboard/home_screen.dart';
import 'package:slipbuddy/screen/splash.dart';
import 'package:slipbuddy/screen/users/dashboard.dart';
Future<void> requestLocationPermission() async {
  final status = await Permission.location.request();
  if (status.isGranted) {
    await getAndSaveLocation();
  } else {
    // Show permission denied message
  }
}
Future<void> getAndSaveLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude, position.longitude);

  Placemark place = placemarks.first;
  String address =
      "${place.locality}";

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('saved_address', address);
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppTheme.statusBar, // Set your desired status bar color here
    statusBarBrightness: Brightness.dark, // For iOS: set the status bar text color to light
    statusBarIconBrightness: Brightness.dark, // For Android: set the status bar icons to light
  ));
  runApp(const MyApp());
}
Future<void> checkFirstLaunch() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  if (isFirstTime) {
    await requestLocationPermission();
    await prefs.setBool('isFirstTime', false);
  }
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    checkFirstLaunch();
  }
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

