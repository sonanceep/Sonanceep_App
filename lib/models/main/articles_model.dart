// dart
import 'dart:convert';
// flutter
import 'package:flutter/material.dart';
import 'package:sonanceep_sns/domain/article/article.dart';
// package
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:sonanceep_sns/constants/voids.dart' as voids;

final articlesProvider = ChangeNotifierProvider(
  ((ref) => ArticlesModel()
));
class ArticlesModel extends ChangeNotifier {
  List<dynamic> jsons = [];
  List<Article> articles = [];

  ArticlesModel() {
    init();
  }

  Future<void> init() async {
    const String uri = 'https://qiita.com/api/v2/items';
    final response = await http.get(Uri.parse(uri));
    if(response.statusCode == 200) {
      jsons = json.decode(response.body);  // response中身をdecode
      articles = jsons.map((e) => Article.fromJson(e)).toList();


      // //型判別
      // final first = jsons.first;  //最初の記事を取得
      // final firstUser = first['user'];  //最初の記事のユーザーを取得
      // final List<String> articleFields = ['id', 'comments_count', 'likes_count', 'private', 'reactions_count', 'title', 'url', 'user',];
      // for(final field in articleFields) {
      //   debugPrint('$field is ${first[field].runtimeType.toString()}\n');  // runtimeTypeは型をreturn
      // }
      // final List<String> quitaUserFields = ['description', 'followees_count', 'followers_count', 'id', 'items_count', 'name', 'permanent_id', 'profile_image_url',];
      // for(final field in quitaUserFields) {
      //   debugPrint('$field is ${firstUser[field].runtimeType.toString()}\n');  // runtimeTypeは型をreturn
      // }
      


      //成功
    } else {
      //失敗
      voids.showFlutterToast(msg: 'リクエストが失敗しました');
    }
  }
}