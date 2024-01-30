import 'dart:async';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/app_running_data/usertype.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/cubits/buyer_layout_cubit.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_auctions.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_category.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_category_search.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_favorite_products.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_home.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_my_account.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_product_search.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_seller_search.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_sellers.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_shopping_cart.dart';
import 'package:klnakhadem/view/mobile_view/app_view/please_login.dart';
import 'package:klnakhadem/view/mobile_view/app_view/selete_user_type.dart';

class MAbuyerLayout extends StatefulWidget {
  const MAbuyerLayout({super.key});

  @override
  State<MAbuyerLayout> createState() => _MAbuyerLayoutState();
}

class _MAbuyerLayoutState extends State<MAbuyerLayout> {
  final _pageController = PageController(initialPage: 2);

  final _controller = NotchBottomBarController(index: 2);

  int i = 2;

  final List<Widget> bottomBarPages = [
    userType == 'notSign'?const MAPleaseLogin(): const BuyerMyAccount(),
    userType == 'notSign'?const MAPleaseLogin(): const BuyerAuctions(),
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
  ];

  final List<Widget> pagesNames = [
    userType == 'notSign'?SizedBox(
      height: MAsizes.screenH*7/100,
      child: const Image(image: AssetImage('assets/images/Logo.png'),fit: BoxFit.contain),
    ):AppText('حسابي', size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
    userType == 'notSign'?SizedBox(
      height: MAsizes.screenH*7/100,
      child: const Image(image: AssetImage('assets/images/Logo.png'),fit: BoxFit.contain),
    ):AppText('مزادات', size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
    AppText('الرئيسية', size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
    userType == 'notSign'?SizedBox(
      height: MAsizes.screenH*7/100,
      child: const Image(image: AssetImage('assets/images/Logo.png'),fit: BoxFit.contain),
    ):AppText('الفئات', size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
    AppText('البائعين', size: MAsizes.textNormalSize, color: AppColors.textWhiteColor)
  ];

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  bool first = true;

  late final BuyerLayoutCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) {
          return BuyerLayoutCubit();
        },
        child: BlocConsumer<BuyerLayoutCubit, BuyerLayoutState>(
          listener: (context, state) {
          },
          builder: (context, state) {
            if(first) {
              cubit =BuyerLayoutCubit.getCubit(context);
              bottomBarPages[2]=BuyerHome(cubit: cubit);
              bottomBarPages[3]=userType == 'notSign'?const MAPleaseLogin(): BuyerCategory(cubit: cubit);
              bottomBarPages[4]=BuyerSellers(cubit: cubit);
              first = false;
              if(userType == 'notSign'){
                BuyerLayoutCubit.cartNumber = 0;
                cubit.fetchCartNumber();
              } else {
                get("${ApiPaths.getShoppingCartNumber}${sharedPreferences.getString('token')}").then((value) {
                  if(value['code']>=200&&value['code']<300) {
                    BuyerLayoutCubit.cartNumber = value['body']['data'];
                  }
                  cubit.fetchCartNumber();
                });
              }
            }
            return Scaffold(
              appBar: AppBar(
                leading: ( (i==2)||(i==3 && userType != 'notSign')||(i==4) )?IconButton(
                  onPressed: (){
                    if(i==2){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BuyerProductSearch(cubit: cubit,)));
                    } else if(i==3 && userType != 'notSign'){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BuyerCategorySearch(cubit: cubit,)));
                    } else if (i==4){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BuyerSellerSearch(cubit: cubit,)));
                    }
                  },
                  icon: const Icon(Icons.search),
                ):const SizedBox(),
                centerTitle: true,
                backgroundColor: AppColors.mainColor,
                title: pagesNames[i],
                actions: [
                  IconButton(
                    onPressed: (){
                      if(userType=='buyer')
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>BuyerShoppingCart(cubit: cubit,)));
                      }else{
                        if (context.mounted){
                          ScaffoldMessenger.of(context).clearMaterialBanners();
                          ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                            content: AppText(
                              'رجاء تسجيل الدخول اولا',
                              color: AppColors.textWhiteColor,
                              size: MAsizes.textNormalSize,
                            ),
                            actions: [
                              TextButton(
                                child: AppText(
                                  'حسنا',
                                  color: AppColors.textWhiteColor,
                                  size: MAsizes.textNormalSize,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).clearMaterialBanners();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MAselectUserType(),));
                                },
                              ),
                            ],
                            backgroundColor: AppColors.mainColor,

                          ));
                          Timer(const Duration(seconds: 3), () {
                            ScaffoldMessenger.of(context).clearMaterialBanners();
                          });
                        }
                      }
                    },
                    icon: Stack(
                      children: [
                        const Icon(Icons.shopping_cart),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.redAccent,
                            radius: 8,
                            child: Center(
                              child: AppText(
                                BuyerLayoutCubit.cartNumber.toString(),
                                color: AppColors.textWhiteColor,
                                size: MAsizes.textNormalSize*0.55,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: (){
                      if(userType=='buyer')
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>BuyerFavoriteProducts(cubit: cubit,)));
                      }else{
                        if (context.mounted){
                          ScaffoldMessenger.of(context).clearMaterialBanners();
                          ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                            content: AppText(
                              'رجاء تسجيل الدخول اولا',
                              color: AppColors.textWhiteColor,
                              size: MAsizes.textNormalSize,
                            ),
                            actions: [
                              TextButton(
                                child: AppText(
                                  'حسنا',
                                  color: AppColors.textWhiteColor,
                                  size: MAsizes.textNormalSize,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).clearMaterialBanners();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MAselectUserType(),));
                                },
                              ),
                            ],
                            backgroundColor: AppColors.mainColor,

                          ));
                          Timer(const Duration(seconds: 3), () {
                            ScaffoldMessenger.of(context).clearMaterialBanners();
                          });
                        }
                      }
                    },
                    icon: const Icon(Icons.favorite),
                  )
                ],
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
                      Icons.home_outlined,
                      color: Colors.white,
                    ),
                    activeItem: Icon(
                      Icons.home,
                      color:Colors.white,
                    ),
                    itemLabel: 'الرئيسية',
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
                    itemLabel: 'الفئات',
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.person_pin_outlined,
                      color: Colors.white,
                    ),
                    activeItem: Icon(
                      Icons.person_pin,
                      color: Colors.white,
                    ),
                    itemLabel: 'البائعين',
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
            );
          },
        ),
      ),
    );
  }
}