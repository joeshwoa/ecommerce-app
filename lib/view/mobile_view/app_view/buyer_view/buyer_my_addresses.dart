import 'package:flutter/material.dart';
import 'package:klnakhadem/api/api_methods/get.dart';
import 'package:klnakhadem/api/api_paths.dart';
import 'package:klnakhadem/api/create_objects_from_response/create_address.dart';
import 'package:klnakhadem/app_running_data/sharedpreferences.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/mobile_componants/mobile_address_box.dart';
import 'package:klnakhadem/componants/app_text.dart';
import 'package:klnakhadem/model/address_model.dart';
import 'package:klnakhadem/view/mobile_view/app_view/buyer_view/buyer_add_address.dart';

class BuyerMyAddresses extends StatefulWidget {
  const BuyerMyAddresses({super.key});

  @override
  State<BuyerMyAddresses> createState() => _BuyerMyAddressesState();
}

class _BuyerMyAddressesState extends State<BuyerMyAddresses> {

  List<Address> addresses = [];
  bool isLoading = false;// Flag to track if an API call is in progress
  late final ScrollController _controller;
  int itemCounter = 1;
  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        itemCounter = addresses.length +1;
      });
      fetchData();
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
    fetchData(); // Fetch initial data when widget is initialized
  }

  @override
  void dispose(){
    super.dispose();
    fetchData().ignore();
    _controller.dispose();
  }

  Future<void> fetchData() async {
    if (!isLoading) {
      if(mounted){
        setState(() {
          isLoading = true;
        });
      }

      final responseMap = await get("${ApiPaths.getAddress}${sharedPreferences.getString('token')}").onError((error, stackTrace) {
        return {
          'code':999
        };
      });

      if (responseMap['code'] >= 200 && responseMap['code'] < 300) {
        final Map<String, dynamic> responseData = responseMap['body'];
        final List<Address> newAddresses = [];

        for(int i=0;i<responseData["results"];i++){
          newAddresses.add(createAddress(responseData["data"][i]));
        }

        if(mounted){
          setState(() {
            addresses.addAll(newAddresses);

            itemCounter = addresses.length;
            isLoading = false;
          });
        }
      } else if (responseMap['code'] == 999) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(child: AppText('الخدمة غير متوفرة حاليا لوجود مشكلة بالخادم',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,)),
              backgroundColor: AppColors.mainColor,
              showCloseIcon: true,
            ),
          );
        }
      } else {
      }
    }
  }

  Future<void> _refresh() async{
    setState(() {
      itemCounter = 1;
      addresses.clear();
    });
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: AppText('عناويني',size: MAsizes.textNormalSize, color: AppColors.textWhiteColor),
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: MaterialButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const BuyerAddAddress(),));
                    },
                    child: Container(
                        height: MAsizes.buttonHeight,
                        width: MAsizes.buttonBigWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                            color: AppColors.buttonGreenColor
                        ),
                        child: Center(child: AppText('اضافة عنوان',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 1,
                    width: MAsizes.widthOfWalletContainer,
                    decoration: const BoxDecoration(
                      color: AppColors.mainColor,
                    ),
                  ),
                ),
                !isLoading && addresses.isEmpty?Center(
                  child: AppText('لا يوجد عناوين',color: AppColors.textGreenColor,size: MAsizes.textBigSize,),
                ):AppText('العناوين المحفوظة سابقاً',size: MAsizes.textBigSize, color: AppColors.textGreenColor),
                if(!isLoading && addresses.isNotEmpty)Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context,index) {
                        if (index < addresses.length) {
                          // Render category card
                          return MAaddressBox(
                            address: addresses[index],
                          );
                        } else if (isLoading) {
                          // Render loading indicator while fetching more data
                          return const Center(
                            child: CircularProgressIndicator(color: AppColors.mainColor,),
                          );
                        } else {
                          // Render an empty container at the end
                          return Container(
                          );
                        }
                      },
                      itemCount: itemCounter,
                    ),
                  ),
                ),
                if(isLoading)const Center(child: CircularProgressIndicator(color: AppColors.mainColor,),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
