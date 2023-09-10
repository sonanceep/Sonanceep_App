import 'package:flutter/material.dart';
import 'package:sonanceep_sns/details/circle_image.dart';
import 'package:sonanceep_sns/details/rectangle_image.dart';

class SongImage extends StatelessWidget {
  const SongImage({
    Key? key,
    required this.length,
    required this.songImageURL,
  }) : super(key: key);

  final double length;
  final String songImageURL;

  @override
  Widget build(BuildContext context) {
    //与えられたsongImageURLが空の時に表示する
    return songImageURL.isEmpty ? 
    Container(
      height: length,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, size: length,),
    )
    : RectangleImage(length: length, image: NetworkImage(songImageURL));
  }
}