import 'package:flutter/material.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';

class MobileClipPathBox extends StatelessWidget {
  const MobileClipPathBox({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _GreenBoxClipper(),
      child: Container(
        height: MAsizes.heightOfClipPathBox,
        decoration: const BoxDecoration(
          color: AppColors.mainColor,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -MAsizes.screenW*5/100,
              left: MAsizes.screenW-90,
              child: Opacity(
                opacity: 0.1,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: MAsizes.screenW*10/100,
              left: MAsizes.screenW*3/5,
              child: Opacity(
                opacity: 0.1,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: MAsizes.screenW*4/100,
              left: MAsizes.screenW*2/6,
              child: Opacity(
                opacity: 0.1,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -MAsizes.screenW*14/100,
              left: MAsizes.screenW*2/9,
              child: Opacity(
                opacity: 0.1,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: MAsizes.screenW*3/100,
              left: -30,
              child: Opacity(
                opacity: 0.1,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GreenBoxClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, MAsizes.heightOfClipPathBox-MAsizes.screenH*4/100);
    /*path.quadraticBezierTo(
        size.width/16, MAsizes.heightOfClipPathBox, size.width*3/16, MAsizes.heightOfClipPathBox-20);
    path.quadraticBezierTo(
        size.width*8/16, MAsizes.heightOfClipPathBox-100, size.width*13/16, MAsizes.heightOfClipPathBox-20);
    path.quadraticBezierTo(
        size.width*14/16, MAsizes.heightOfClipPathBox, size.width*16/16, MAsizes.heightOfClipPathBox-20);*/
    path.quadraticBezierTo(
        size.width*2/32, MAsizes.heightOfClipPathBox, size.width*16/32, MAsizes.heightOfClipPathBox-MAsizes.screenH*10/100);
    path.quadraticBezierTo(
        size.width*30/32, MAsizes.heightOfClipPathBox, size.width*32/32, MAsizes.heightOfClipPathBox-MAsizes.screenH*4/100);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}