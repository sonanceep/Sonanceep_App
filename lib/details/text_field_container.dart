// flutter
import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  const TextFieldContainer({Key? key, required this.borderColor, required this.child, required this.shadowColor}) : super(key: key);
  final Color borderColor;
  final Color shadowColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size =  MediaQuery.of(context).size;  //デバイスのサイズを取得
    final double height = size.height;  //デバイスの高さ
    final double width = size.width;  //デバイスの幅
    // Centerで囲むと真ん中に配置される
    return Center(
      child: Container(
        // margin 要素の外の余白
        // symmetric 左右対称
        // vertical 上下対象な余白
        margin: EdgeInsets.symmetric(vertical: 8.0),
        width: width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(  //全方向にボーダーが付く
            color: borderColor,
          ),
          boxShadow: [BoxShadow(
            color: shadowColor,
            blurRadius: 8.0,
            offset: Offset(0, 0),
          )],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: child,
      ),
    );
  }
}