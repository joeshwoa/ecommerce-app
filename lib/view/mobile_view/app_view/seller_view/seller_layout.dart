import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:klnakhadem/app_running_data/usertype.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_auctions.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_home.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_my_account.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_my_account_for_not_complete_seller.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_please_complete_your_information.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_products.dart';
import 'package:klnakhadem/view/mobile_view/app_view/seller_view/seller_profits.dart';

class MAsellerLayout extends StatefulWidget {
  const MAsellerLayout({super.key});

  @override
  State<MAsellerLayout> createState() => _MAsellerLayoutState();
}

class _MAsellerLayoutState extends State<MAsellerLayout> {
  final _pageController = PageController(initialPage: 2);

  final _controller = NotchBottomBarController(index: 2);

  int i = 2;

  final List<Widget> bottomBarPages = [
    userType == 'seller'?const SellerMyAccountForNotCompleteSeller():  const SellerMyAccount(),
    userType == 'seller'?const SellerPleaseCompleteYourInformation(): const SellerProfits(),
    const SellerHome(),
    userType == 'seller'?const SellerPleaseCompleteYourInformation(): const SellerAuctions(),
    userType == 'seller'?const SellerPleaseCompleteYourInformation(): const SellerProducts(),
  ];

  final List<Widget> pagesNames = [
    userType == 'seller'?SizedBox(
      height: MAsizes.screenH*7/100,
      child: const Image(image: AssetImage('assets/images/Logo.png'),fit: BoxFit.contain),
    ):AppText('حسابي', size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
    userType == 'seller'?SizedBox(
      height: MAsizes.screenH*7/100,
      child: const Image(image: AssetImage('assets/images/Logo.png'),fit: BoxFit.contain),
    ):AppText('الارباح', size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
    AppText('الرئيسية', size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
    userType == 'seller'?SizedBox(
      height: MAsizes.screenH*7/100,
      child: const Image(image: AssetImage('assets/images/Logo.png'),fit: BoxFit.contain),
    ):AppText('المزادات', size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
    userType == 'seller'?SizedBox(
      height: MAsizes.screenH*7/100,
      child: const Image(image: AssetImage('assets/images/Logo.png'),fit: BoxFit.contain),
    ):AppText('المنتجات', size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
  ];

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          centerTitle: true,
          backgroundColor: AppColors.mainColor,
          title: pagesNames[i],
          /*actions: [
            IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.shopping_cart),
            ),
            IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.favorite),
            )
          ],*/
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
              bottomBarPages.length, (index) => bottomBarPages[index]),
        ),
        extendBody: true,
        bottomNavigationBar: AnimatedNotchBottomBar(
          /// Provide NotchBottomBarController
          notchBottomBarController: _controller,
          color: AppColors.mainColor,
          showLabel: true,
          notchColor: AppColors.mainColor,

          /// restart app if you change removeMargins
          removeMargins: false,
          bottomBarWidth: MAsizes.screenW,
          durationInMilliSeconds: 300,
          itemLabelStyle: const TextStyle(
            color: AppColors.textWhiteColor,
            fontFamily: 'El_Messiri',
          ),
          bottomBarItems: const [
            BottomBarItem(
              inActiveItem: Icon(
                Icons.account_circle_outlined,
                color: Colors.white,
              ),
              activeItem: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              itemLabel: 'حسابي',
            ),
            BottomBarItem(
              inActiveItem: Icon(
                Icons.price_change_outlined,
                color: Colors.white,
              ),
              activeItem: Icon(
                Icons.price_change,
                color:Colors.white,
              ),
              itemLabel: 'الارباح',
            ),
            BottomBarItem(
              inActiveItem: Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
              activeItem: Icon(
                Icons.home,
                color: Colors.white,
              ),
              itemLabel: 'الرئيسية',
            ),
            BottomBarItem(
              inActiveItem: Icon(
                Icons.one_k_plus_outlined,
                color: Colors.white,
              ),
              activeItem: Icon(
                Icons.one_k_plus,
                color: Colors.white,
              ),
              itemLabel: 'المزادات',
            ),
            BottomBarItem(
              inActiveItem: Icon(
                Icons.category_outlined,
                color: Colors.white,
              ),
              activeItem: Icon(
                Icons.category,
                color: Colors.white,
              ),
              itemLabel: 'المنتجات',
            ),
          ],
          showShadow: true,
          onTap: (index) {
            /*/// perform action on tab change and to update pages you can update pages without pages
            log('current selected index $index');*/
            _pageController.jumpToPage(index);
            setState(() {
              i = index;
            });
          },
        ),
      ),
    );
  }
}
