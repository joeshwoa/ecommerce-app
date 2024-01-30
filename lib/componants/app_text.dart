import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText(this.data,{super.key,required this.size,required this.color,this.max = 1,this.textOverflow = TextOverflow.ellipsis});
  final String data;
  final double size;
  final Color color;
  final int max;
  final TextOverflow textOverflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: max,
      overflow: textOverflow,
      data,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        color: color,
        fontFamily: 'El_Messiri',
        fontSize: size,
      ),
    );
  }
}
