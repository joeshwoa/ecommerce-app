import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';

class SellerPolicy extends StatefulWidget {
  const SellerPolicy({super.key});

  @override
  State<SellerPolicy> createState() => _SellerPolicyState();
}

class _SellerPolicyState extends State<SellerPolicy> {

  late final String policy;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if(!isLoading)
    {
      setState(() {
        isLoading = true;
      });
      get(ApiPaths.getSellerPolicy).then((value){
        Map responseMap=value;
        if((responseMap['code']>=200 && responseMap['code']<300))
        {
          policy = responseMap['body']['terms'];
          setState(() {
            isLoading = false;
          });
        }
      }).onError((error, stackTrace) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
              backgroundColor: AppColors.mainColor,
              showCloseIcon: true,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('سياسات الخصوصية للتاجر',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
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
          child: isLoading?const Center(child: CircularProgressIndicator(color: AppColors.mainColor,)):Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      policy,
                      color: AppColors.textBlackColor,
                      size: MAsizes.textNormalSize,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
