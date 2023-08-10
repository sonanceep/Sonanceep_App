import 'package:flutter/material.dart';
import 'package:sonanceep_sns/domain/post/post.dart';
import 'package:sonanceep_sns/views/post_focus_page.dart';
// constants
import 'package:sonanceep_sns/constants/routes.dart' as routes;

class PostCardContants extends StatelessWidget {
  const PostCardContants({
    Key? key,
    required this.length,
    required this.post,
    required this.text,
  }) : super(key: key);

  final double length;
  final Post post;
  final String text;

  @override
  Widget build(BuildContext context) {

    final imageURL = post.imageURL;

    //与えられたimageURLが空の時に表示する
    return imageURL.isNotEmpty ? 
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => routes.toPostFocusPage(context: context, post: post),
            child: Container(
              alignment: Alignment.center,
              child: Image.network(
                imageURL,
                width: length,
                // height: length,
                fit: BoxFit.cover, // 画像のアスペクト比を保ちつつサイズに収める
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Text(text, style: const TextStyle(fontSize: 24.0),),
        ),
      ],
    ) : Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Text(text, style: const TextStyle(fontSize: 24.0),),
      ),
    );
  }
}