import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'firestore_user.freezed.dart';
part 'firestore_user.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class FirestoreUser with _$FirestoreUser {
  const factory FirestoreUser({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required dynamic createdAt,  // dynamic型 なんでも許す
    required dynamic updatedAt,
    required int followerCount,
    required int followingCount,
    required bool isAdmin,
    required int muteCount,
    required Map<String,dynamic> searchToken,
    required int postCount,
    required String userName,
    required String userNameLanguageCode,
    required double userNameNegativeScore,
    required double userNamePositiveScore,
    required String userNameSentiment,
    required String uid,
    required String userImageURL,
  }) = _FirestoreUser;
  factory FirestoreUser.fromJson(Map<String,dynamic> json) => _$FirestoreUserFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}