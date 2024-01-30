import 'package:flutter/material.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/model/auction_model.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_auction_detailes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MAauctionCard extends StatelessWidget {
  const MAauctionCard({super.key,required this.auction});
  final Auction auction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: MaterialButton(
        height: MAsizes.heightOfProductContainer,
        padding: EdgeInsets.zero,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => BuyerAuctionDetails(auction: auction),));
        },
        child: Container(
          width: MAsizes.widthOfProductContainer,
          height: MAsizes.heightOfProductContainer,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.offWhiteBoxColor,
            borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(width: MAsizes.screenW,child: Image(image: MemoryImage(auction.imageCover),fit: BoxFit.cover)),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: AppText(auction.title, size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      ),
                      Expanded(
                        flex: 1,
                        child: AppText('${auction.bestOffer}', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            AppText(auction.newProduct?'جديد':'مستعمل', size: MAsizes.textNormalSize, color:auction.newProduct?AppColors.textGreenColor:Colors.red),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor:auction.newProduct?AppColors.textGreenColor:Colors.red,
                                minRadius: 1.w,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                                color: AppColors.buttonGreenColor
                            ),
                            child: Center(child: AppText(auction.joined?'متابعة':"تفاصيل الانضمام",color: AppColors.textWhiteColor,size: MAsizes.textNormalSize/2,))
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
