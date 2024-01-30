import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/post.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/componants/app_text_form_field.dart';
import 'package:klnakhadem/model/auction_model.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_auction_policy.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toggle_switch/toggle_switch.dart';

class BuyerAuctionDetails extends StatefulWidget {
  const BuyerAuctionDetails({super.key,required this.auction});

  final Auction auction;

  @override
  State<BuyerAuctionDetails> createState() => _BuyerAuctionDetailsState();
}

class _BuyerAuctionDetailsState extends State<BuyerAuctionDetails> {

  TextEditingController moneyController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int currentImage = 0;
  String deliveryOrPickup = 'delivery';
  int optionSelected = 0;
  bool isLoading = false;

  _onAlertWithCustomContentPressed(context) {
    Alert(
        context: context,
        title: "السوم",
        closeIcon: IconButton(
          icon: const Icon(Icons.close,color: Colors.redAccent),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        style: AlertStyle(titleStyle: TextStyle(
          color: AppColors.mainColor,
          fontFamily: 'El_Messiri',
          fontSize: MAsizes.textBetweenNormalAndBigSize,
          overflow: TextOverflow.ellipsis,
        )),
        content: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              AppTextFormField(
                validator: (value){
                  if(value == null || value.isEmpty)
                  {
                    return 'السوم لا يمكن ان يكون فارغ';
                  }
                  else if(int.parse(value) == 0)
                  {
                    return 'السوم لا يمكن ان يكون صفر';
                  }
                  else if(int.parse(value) < widget.auction.bestOffer)
                  {
                    return 'السوم الخاص بك لا يمكن ان يكون اقل  من اعلي سوم متاح';
                  }
                  return null;
                },
                mycontroller: moneyController,
                hintText: ' ادخال السوم',
                labelText: 'السوم',
                keyboardType: const TextInputType.numberWithOptions(signed: false,decimal: false),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: MaterialButton(
                  onPressed: () async {
                    if(formKey.currentState!.validate())
                    {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(child: AppText('جاري اضافة المنتج الي السلة',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                          backgroundColor: AppColors.mainColor,
                          showCloseIcon: true,
                        ),
                      );
                      Map<String,dynamic> data = {
                        'user':sharedPreferences.getString('token'),
                        'offer':int.parse(moneyController.text),
                        'auction':widget.auction.id,
                      };
                      Map responseMap = await post(ApiPaths.shoppingCart,data).onError((error, stackTrace) {
                        return {
                          'code':999
                        };
                      });
                      if((responseMap['code']>=200 && responseMap['code']<300)){
                        moneyController.clear();
                        if (context.mounted){
                          ScaffoldMessenger.of(context)
                              .clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(
                                  child: AppText(
                                    'تم اضافة المنتج بنجاح',
                                    color: AppColors.textWhiteColor,
                                    size: MAsizes.textNormalSize,
                                  )),
                              backgroundColor: AppColors.mainColor,
                              showCloseIcon: true,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      }else if (responseMap['code']==400&&responseMap['body']['message']=='') {
                        moneyController.clear();
                        if (context.mounted){
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(child: AppText('المنتج غير متوفر منه الكمية المطلوبة حاليا',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                              backgroundColor: AppColors.mainColor,
                              showCloseIcon: true,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      } else{
                        moneyController.clear();
                        if (context.mounted){
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(child: AppText('فشل اضافة المنتج',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
                              backgroundColor: AppColors.mainColor,
                              showCloseIcon: true,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      }
                    }
                  },
                  child: Container(
                      height: MAsizes.buttonHeight,
                      width: MAsizes.buttonBigWidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                          color: AppColors.buttonGreenColor
                      ),
                      child: Center(child: AppText('اضافة سوم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                  ),
                ),
              )
            ],
          ),
        ),
        buttons: []).show();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('تفاصيل منتج',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SizedBox(
          height: MAsizes.screenH,
          width: MAsizes.screenW,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
                                color: AppColors.offWhiteBoxColor
                            ),
                            height: MAsizes.heightOfBigEmptySpace*2,
                            width: MAsizes.screenW,
                            child: CarouselSlider.builder(
                              options: CarouselOptions(
                                scrollPhysics: const PageScrollPhysics(),
                                height: MAsizes.heightOfBigEmptySpace*2,
                                viewportFraction: 1.0,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                initialPage: 0,
                                pauseAutoPlayOnTouch: true,
                                pauseAutoPlayOnManualNavigate: true,
                                autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentImage = index;
                                  });
                                },
                              ),
                              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                                  SizedBox.expand(
                                      child: InteractiveViewer(
                                        child: Image(image: MemoryImage(widget.auction.images[itemIndex])),
                                      )),
                              itemCount: widget.auction.images.length,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for(int i=0;i<widget.auction.images.length;i++)...[
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.mainColor,
                                      radius: currentImage == i? 8:4,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AppText(widget.auction.title,size: MAsizes.textBetweenNormalAndBigSize, color: AppColors.textGreenColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AppText(widget.auction.marketName,size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AppText(widget.auction.marketAddress,size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AppText(widget.auction.description,size: MAsizes.textNormalSize, color: AppColors.textBlackColor,max: 10),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          AppText("${widget.auction.price}",size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                          AppText('الحد الادني ',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          AppText("${widget.auction.bestOffer}",size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                          AppText('اعلي سوم ',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          AppText(widget.auction.userOfBestOffer,size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                          AppText('صاحب اعلي سوم ',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          AppText(widget.auction.endAt.minute<10?'${widget.auction.endAt.year}/${widget.auction.endAt.month}/${widget.auction.endAt.day}   ${widget.auction.endAt.hour}:0${widget.auction.endAt.minute}':'${widget.auction.endAt.year}/${widget.auction.endAt.month}/${widget.auction.endAt.day}   ${widget.auction.endAt.hour}:${widget.auction.endAt.minute}',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                          AppText('موعد انتهاء المزاد ',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          AppText('${widget.auction.available}',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                          AppText('الكمية ',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                        ],
                      ),
                    ),
                    /*Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                MobileText('السعر',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                MobileText('الكمية',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                MobileText('الخيار',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                                SizedBox(
                                  width: MAsizes.widthOfMediumEmptySpace,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              MobileText('10',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                              MobileText('1',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                              MobileText('احمر',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                              CircleAvatar(
                                radius: MAsizes.widthOfSmallEmptySpace*2/5,
                                backgroundColor: AppColors.mainColor,
                                child: MaterialButton(
                                  onPressed: (){
                                    setState(() {
                                      optionSelected=0;
                                    });
                                  },
                                  padding: EdgeInsets.zero,
                                  child: CircleAvatar(
                                    radius: (MAsizes.widthOfSmallEmptySpace*2/5)-2,
                                    backgroundColor: optionSelected==0?AppColors.mainColor:AppColors.offWhiteBoxColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              MobileText('10',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                              MobileText('1',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                              MobileText('احمر',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                              CircleAvatar(
                                radius: MAsizes.widthOfSmallEmptySpace*2/5,
                                backgroundColor: AppColors.mainColor,
                                child: MaterialButton(
                                  onPressed: (){
                                    setState(() {
                                      optionSelected=1;
                                    });
                                  },
                                  padding: EdgeInsets.zero,
                                  child: CircleAvatar(
                                    radius: (MAsizes.widthOfSmallEmptySpace*2/5)-2,
                                    backgroundColor: optionSelected==1?AppColors.mainColor:AppColors.offWhiteBoxColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              MobileText('10',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                              MobileText('1',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                              MobileText('احمر',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                              CircleAvatar(
                                radius: MAsizes.widthOfSmallEmptySpace*2/5,
                                backgroundColor: AppColors.mainColor,
                                child: MaterialButton(
                                  onPressed: (){
                                    setState(() {
                                      optionSelected=2;
                                    });
                                  },
                                  padding: EdgeInsets.zero,
                                  child: CircleAvatar(
                                    radius: (MAsizes.widthOfSmallEmptySpace*2/5)-2,
                                    backgroundColor: optionSelected==2?AppColors.mainColor:AppColors.offWhiteBoxColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              MobileText('10',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                              MobileText('1',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                              MobileText('احمر',size: MAsizes.textNormalSize, color: AppColors.textBlackColor),
                              CircleAvatar(
                                radius: MAsizes.widthOfSmallEmptySpace*2/5,
                                backgroundColor: AppColors.mainColor,
                                child: MaterialButton(
                                  onPressed: (){
                                    setState(() {
                                      optionSelected=3;
                                    });
                                  },
                                  padding: EdgeInsets.zero,
                                  child: CircleAvatar(
                                    radius: (MAsizes.widthOfSmallEmptySpace*2/5)-2,
                                    backgroundColor: optionSelected==3?AppColors.mainColor:AppColors.offWhiteBoxColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),*/
                    if(widget.auction.deliveryOrPickup=='both')Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: ToggleSwitch(
                          minWidth: MAsizes.buttonNormalWidth,
                          initialLabelIndex: deliveryOrPickup=='delivery'?0:1,
                          cornerRadius: MAsizes.buttonBorderRadius,
                          activeFgColor: AppColors.textWhiteColor,
                          inactiveBgColor: AppColors.offWhiteBoxColor,
                          inactiveFgColor: AppColors.textGreenColor,
                          totalSwitches: 2,
                          customTextStyles: const [TextStyle(
                            fontFamily: 'El_Messiri',
                          ),TextStyle(
                            fontFamily: 'El_Messiri',
                          )],
                          labels: const ['استلام', 'توصيل'],
                          activeBgColors: const [[AppColors.mainColor],[AppColors.mainColor]],
                          onToggle: (i){
                            if(i == 0){
                              deliveryOrPickup = 'delivery';
                            } else if (i == 1){
                              deliveryOrPickup = 'pickup';
                            }
                          },
                        ),
                      ),
                    ),
                    if(widget.auction.deliveryOrPickup!='both')Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Container(
                          width: MAsizes.buttonNormalWidth,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Center(child: AppText(widget.auction.deliveryOrPickup=='pickup'?'استلام':'توصيل',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor)),
                          ),
                        ),
                      ),
                    ),
                    if(widget.auction.deliveryOrPickup!='pickup')Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          AppText(widget.auction.deliveryPrice.toString(),size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                          AppText('سعر التوصيل ',size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        onPressed: () {
                          widget.auction.joined?_onAlertWithCustomContentPressed(context):Navigator.push(context, MaterialPageRoute(builder: (context) => const BuyerAuctionPolicy(),));
                        },
                        child: Container(
                            height: MAsizes.buttonHeight,
                            width: MAsizes.buttonBigWidth,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                color: AppColors.buttonGreenColor
                            ),
                            child: Center(child: AppText(widget.auction.joined?'اضافة سوم':'دخول المزاد',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MouseEnabledScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}