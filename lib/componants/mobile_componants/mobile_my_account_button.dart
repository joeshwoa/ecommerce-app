import 'package:flutter/material.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';

class MAmyAccountButton extends StatelessWidget {
  const MAmyAccountButton({super.key,this.goToStyle = 'push',this.onPressed,required this.word,required this.goTo,required this.icon});
  final String word;
  final Widget goTo;
  final IconData icon;
  final String goToStyle;
  final dynamic onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: MaterialButton(
        onPressed: onPressed ?? (){
          if(goToStyle == 'push'){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>goTo));
          }
          else if(goToStyle == 'pushReplacement')
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>goTo));
          }
        },
        padding: EdgeInsets.zero,
        child: Container(
          height: MAsizes.buttonHeight*1.5,
          width: MAsizes.screenW,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
              color: AppColors.offWhiteBoxColor
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.arrow_back),
                const Expanded(child: SizedBox()),
                AppText(word, size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                Icon(icon),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
