// flutter
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  const RoundedButton({
    Key? key,
    required this.onPressed,
    required this.widthRate,
    required this.color,
    required this.text,
  }) : super(key: key);

  final void Function()? onPressed;
  final double widthRate;  // 0 < withRate < 1.0
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;  //モバイルの幅のピクセル数

    return 
    SizedBox(
      width: maxWidth * widthRate,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,  //上下
              horizontal: 8.0,  //左右
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}