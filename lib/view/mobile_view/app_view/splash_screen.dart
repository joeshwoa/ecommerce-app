import 'dart:async';

import 'package:flutter/material.dart';
import 'package:klnakhadem/app_running_data/usertype.dart';
import 'package:klnakhadem/assets_paths/app_images.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_layout.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_layout.dart';

class MAsplashScreen extends StatefulWidget {
  const MAsplashScreen({super.key});

  @override
  State<MAsplashScreen> createState() => _MAsplashScreenState();
}

class _MAsplashScreenState extends State<MAsplashScreen> {

  @override
  void initState() {
    super.initState();
    if(userType == 'notSign')
      {
        Timer(const Duration(seconds: 3), ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MAbuyerLayout())));
      }
    else if(userType == 'buyer')
      {
        Timer(const Duration(seconds: 3), ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MAbuyerLayout())));
      }
    else if(userType == 'seller' || userType == 'sellerComplete')
      {
        Timer(const Duration(seconds: 3), ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MAsellerLayout())));
      }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:Scaffold( resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.mainColor,
      body: SizedBox(
        height: MAsizes.screenH,
        width: MAsizes.screenW,
        child: Stack(
          children: [
            SizedBox(
              height: MAsizes.screenH,
              width: MAsizes.screenW,
              child: const Image(image: AssetImage(AppImages.splashBackground),fit: BoxFit.cover),
            ),
            Container(
              height: MAsizes.screenH,
              width: MAsizes.screenW,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.mainColor.withOpacity(0.8),
                    Colors.white.withOpacity(0.8)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                )
              ),
            ),
            Center(
              child: SizedBox(
                height: MAsizes.screenW*50/100,
                width: MAsizes.screenW*50/100,
                child: const Image(image: AssetImage(AppImages.logo),fit: BoxFit.contain),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
