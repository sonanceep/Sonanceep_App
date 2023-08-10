// flutter
import 'package:flutter/material.dart';
import 'package:sonanceep_sns/domain/post/post.dart';

class PostFocusPage extends StatelessWidget {
  const PostFocusPage({
    Key? key,
    required this.post,
    // required this.mainModel,
  }) : super(key: key);

  // final MainModel mainModel;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        child: Image.network(
          post.imageURL,
          width: MediaQuery.of(context).size.width,  //画面の高さ * 0.5,
          // height: length,
          fit: BoxFit.cover, // 画像のアスペクト比を保ちつつサイズに収める
        ),
      ),
    );
  }
}