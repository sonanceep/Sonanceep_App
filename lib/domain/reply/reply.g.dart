// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Reply _$$_ReplyFromJson(Map<String, dynamic> json) => _$_Reply(
      createdAt: json['createdAt'],
      reply: json['reply'] as String,
      replyLanguageCode: json['replyLanguageCode'] as String,
      replyNegativeScore: (json['replyNegativeScore'] as num).toDouble(),
      replyPositiveScore: (json['replyPositiveScore'] as num).toDouble(),
      replySentiment: json['replySentiment'] as String,
      likeCount: json['likeCount'] as int,
      postRef: json['postRef'],
      postCommentRef: json['postCommentRef'],
      postCommentReplyId: json['postCommentReplyId'] as String,
      reportCount: json['reportCount'] as int,
      userName: json['userName'] as String,
      userNameLanguageCode: json['userNameLanguageCode'] as String,
      userNameNegativeScore: (json['userNameNegativeScore'] as num).toDouble(),
      userNamePositiveScore: (json['userNamePositiveScore'] as num).toDouble(),
      userNameSentiment: json['userNameSentiment'] as String,
      uid: json['uid'] as String,
      userImageURL: json['userImageURL'] as String,
      updatedAt: json['updatedAt'],
    );

Map<String, dynamic> _$$_ReplyToJson(_$_Reply instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'reply': instance.reply,
      'replyLanguageCode': instance.replyLanguageCode,
      'replyNegativeScore': instance.replyNegativeScore,
      'replyPositiveScore': instance.replyPositiveScore,
      'replySentiment': instance.replySentiment,
      'likeCount': instance.likeCount,
      'postRef': instance.postRef,
      'postCommentRef': instance.postCommentRef,
      'postCommentReplyId': instance.postCommentReplyId,
      'reportCount': instance.reportCount,
      'userName': instance.userName,
      'userNameLanguageCode': instance.userNameLanguageCode,
      'userNameNegativeScore': instance.userNameNegativeScore,
      'userNamePositiveScore': instance.userNamePositiveScore,
      'userNameSentiment': instance.userNameSentiment,
      'uid': instance.uid,
      'userImageURL': instance.userImageURL,
      'updatedAt': instance.updatedAt,
    };
