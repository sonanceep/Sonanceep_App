import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'article.freezed.dart';
part 'article.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class Article with _$Article {
  const factory Article({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String id,
    required int comments_count,
    required int likes_count,
    required bool private,
    required int reactions_count,
    required String title,
    required String url,
    required dynamic user,
  }) = _Article;
  factory Article.fromJson(Map<String,dynamic> json) => _$ArticleFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}