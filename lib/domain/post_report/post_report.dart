import 'package:freezed_annotation/freezed_annotation.dart';
// packeges
part 'post_report.freezed.dart';
part 'post_report.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class PostReport with _$PostReport {
  //メールで送信
  const factory PostReport({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String others,  //その他の報告内容
    required String reportContent,  //メインの報告内容
    required String postCreatorUid,
    required String passiveUserName,
    required dynamic postDocRef,
    required String postId,
    required String postReportId,
    required String text,
    required String textLanguageCode,
    required double textNegativeScore,
    required double textPositiveScore,
    required String textSentiment,
  }) = _PostReport;
  factory PostReport.fromJson(Map<String,dynamic> json) => _$PostReportFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}