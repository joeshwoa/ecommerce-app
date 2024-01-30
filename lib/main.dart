import 'package:flutter/material.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/app_running_data/usertype.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/view/mobile_view/app_view/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  userType = sharedPreferences.getString('userType') ?? 'notSign';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'كلنا خادم',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainColor),
          ),
          home: !kIsWeb?const MAsplashScreen():(Device.screenType == ScreenType.mobile?const SizedBox():const SizedBox()),
        );
      },
    );
  }
}
