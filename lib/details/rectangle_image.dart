import 'package:flutter/material.dart';

class RectangleImage extends StatelessWidget {
  const RectangleImage({
    Key? key,
    required this.length,
    required this.image,
  }) : super(key: key);

  final double length;
  final ImageProvider<Object> image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: length,
      height: length,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: image,
        ),
      ),
    );
  }
}