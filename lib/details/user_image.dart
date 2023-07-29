import 'package:flutter/material.dart';
import 'package:sonanceep_sns/details/circle_image.dart';

class UserImage extends StatelessWidget {
  const UserImage({
    Key? key,
    required this.length,
    required this.userImageURL,
  }) : super(key: key);

  final double length;
  final String userImageURL;

  @override
  Widget build(BuildContext context) {
    //与えられたUserImageURLが空の時に表示する
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: userImageURL.isEmpty ? 
      Container(
        width: length,
        height: length,
        child: Icon(Icons.person, size: length,),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          shape: BoxShape.circle,
        ),
      )
      : CircleImage(length: length, image: NetworkImage(userImageURL))
    );
  }
}