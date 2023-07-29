import 'package:freezed_annotation/freezed_annotation.dart';
// packeges
part 'post.freezed.dart';
part 'post.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class Post with _$Post {
  // DBに保存する
  // createdAtやIdが必要
  // 自分がフォローしたことの印
  const factory Post({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required dynamic createdAt,
    required List<String> hashTags,
    required String imageURL,
    required int likeCount,
    required String text,
    required String textLanguageCode,
    required double textNegativeScore,
    required double textPositiveScore,
    required String textSentiment,
    required int commentCount,
    required String postId,
    required int reportCount,
    required int muteCount,
    required String uid,
    required String userName,
    required String userNameLanguageCode,
    required double userNameNegativeScore,
    required double userNamePositiveScore,
    required String userNameSentiment,
    required String userImageURL,
    required dynamic updatedAt,
  }) = _Post;
  factory Post.fromJson(Map<String,dynamic> json) => _$PostFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}