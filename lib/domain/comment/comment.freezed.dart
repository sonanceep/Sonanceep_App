// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return _Comment.fromJson(json);
}

/// @nodoc
mixin _$Comment {
// const factory 違うクラスのインスタンスを返すことができるコンストラクタ
  dynamic get createdAt =>
      throw _privateConstructorUsedError; // dynamic型 なんでも許す
  String get comment => throw _privateConstructorUsedError;
  String get commentLanguageCode => throw _privateConstructorUsedError;
  double get commentNegativeScore => throw _privateConstructorUsedError;
  double get commentPositiveScore => throw _privateConstructorUsedError;
  String get commentSentiment => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  dynamic get postRef => throw _privateConstructorUsedError;
  String get postCommentId => throw _privateConstructorUsedError;
  int get postCommentReplyCount => throw _privateConstructorUsedError;
  int get reportCount => throw _privateConstructorUsedError;
  int get muteCount => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get userNameLanguageCode => throw _privateConstructorUsedError;
  double get userNameNegativeScore => throw _privateConstructorUsedError;
  double get userNamePositiveScore => throw _privateConstructorUsedError;
  String get userNameSentiment => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  String get userImageURL => throw _privateConstructorUsedError;
  dynamic get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommentCopyWith<Comment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentCopyWith<$Res> {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) then) =
      _$CommentCopyWithImpl<$Res, Comment>;
  @useResult
  $Res call(
      {dynamic createdAt,
      String comment,
      String commentLanguageCode,
      double commentNegativeScore,
      double commentPositiveScore,
      String commentSentiment,
      int likeCount,
      dynamic postRef,
      String postCommentId,
      int postCommentReplyCount,
      int reportCount,
      int muteCount,
      String userName,
      String userNameLanguageCode,
      double userNameNegativeScore,
      double userNamePositiveScore,
      String userNameSentiment,
      String uid,
      String userImageURL,
      dynamic updatedAt});
}

/// @nodoc
class _$CommentCopyWithImpl<$Res, $Val extends Comment>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = freezed,
    Object? comment = null,
    Object? commentLanguageCode = null,
    Object? commentNegativeScore = null,
    Object? commentPositiveScore = null,
    Object? commentSentiment = null,
    Object? likeCount = null,
    Object? postRef = freezed,
    Object? postCommentId = null,
    Object? postCommentReplyCount = null,
    Object? reportCount = null,
    Object? muteCount = null,
    Object? userName = null,
    Object? userNameLanguageCode = null,
    Object? userNameNegativeScore = null,
    Object? userNamePositiveScore = null,
    Object? userNameSentiment = null,
    Object? uid = null,
    Object? userImageURL = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      commentLanguageCode: null == commentLanguageCode
          ? _value.commentLanguageCode
          : commentLanguageCode // ignore: cast_nullable_to_non_nullable
              as String,
      commentNegativeScore: null == commentNegativeScore
          ? _value.commentNegativeScore
          : commentNegativeScore // ignore: cast_nullable_to_non_nullable
              as double,
      commentPositiveScore: null == commentPositiveScore
          ? _value.commentPositiveScore
          : commentPositiveScore // ignore: cast_nullable_to_non_nullable
              as double,
      commentSentiment: null == commentSentiment
          ? _value.commentSentiment
          : commentSentiment // ignore: cast_nullable_to_non_nullable
              as String,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      postRef: freezed == postRef
          ? _value.postRef
          : postRef // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postCommentId: null == postCommentId
          ? _value.postCommentId
          : postCommentId // ignore: cast_nullable_to_non_nullable
              as String,
      postCommentReplyCount: null == postCommentReplyCount
          ? _value.postCommentReplyCount
          : postCommentReplyCount // ignore: cast_nullable_to_non_nullable
              as int,
      reportCount: null == reportCount
          ? _value.reportCount
          : reportCount // ignore: cast_nullable_to_non_nullable
              as int,
      muteCount: null == muteCount
          ? _value.muteCount
          : muteCount // ignore: cast_nullable_to_non_nullable
              as int,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userNameLanguageCode: null == userNameLanguageCode
          ? _value.userNameLanguageCode
          : userNameLanguageCode // ignore: cast_nullable_to_non_nullable
              as String,
      userNameNegativeScore: null == userNameNegativeScore
          ? _value.userNameNegativeScore
          : userNameNegativeScore // ignore: cast_nullable_to_non_nullable
              as double,
      userNamePositiveScore: null == userNamePositiveScore
          ? _value.userNamePositiveScore
          : userNamePositiveScore // ignore: cast_nullable_to_non_nullable
              as double,
      userNameSentiment: null == userNameSentiment
          ? _value.userNameSentiment
          : userNameSentiment // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      userImageURL: null == userImageURL
          ? _value.userImageURL
          : userImageURL // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CommentCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$$_CommentCopyWith(
          _$_Comment value, $Res Function(_$_Comment) then) =
      __$$_CommentCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {dynamic createdAt,
      String comment,
      String commentLanguageCode,
      double commentNegativeScore,
      double commentPositiveScore,
      String commentSentiment,
      int likeCount,
      dynamic postRef,
      String postCommentId,
      int postCommentReplyCount,
      int reportCount,
      int muteCount,
      String userName,
      String userNameLanguageCode,
      double userNameNegativeScore,
      double userNamePositiveScore,
      String userNameSentiment,
      String uid,
      String userImageURL,
      dynamic updatedAt});
}

/// @nodoc
class __$$_CommentCopyWithImpl<$Res>
    extends _$CommentCopyWithImpl<$Res, _$_Comment>
    implements _$$_CommentCopyWith<$Res> {
  __$$_CommentCopyWithImpl(_$_Comment _value, $Res Function(_$_Comment) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = freezed,
    Object? comment = null,
    Object? commentLanguageCode = null,
    Object? commentNegativeScore = null,
    Object? commentPositiveScore = null,
    Object? commentSentiment = null,
    Object? likeCount = null,
    Object? postRef = freezed,
    Object? postCommentId = null,
    Object? postCommentReplyCount = null,
    Object? reportCount = null,
    Object? muteCount = null,
    Object? userName = null,
    Object? userNameLanguageCode = null,
    Object? userNameNegativeScore = null,
    Object? userNamePositiveScore = null,
    Object? userNameSentiment = null,
    Object? uid = null,
    Object? userImageURL = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$_Comment(
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      commentLanguageCode: null == commentLanguageCode
          ? _value.commentLanguageCode
          : commentLanguageCode // ignore: cast_nullable_to_non_nullable
              as String,
      commentNegativeScore: null == commentNegativeScore
          ? _value.commentNegativeScore
          : commentNegativeScore // ignore: cast_nullable_to_non_nullable
              as double,
      commentPositiveScore: null == commentPositiveScore
          ? _value.commentPositiveScore
          : commentPositiveScore // ignore: cast_nullable_to_non_nullable
              as double,
      commentSentiment: null == commentSentiment
          ? _value.commentSentiment
          : commentSentiment // ignore: cast_nullable_to_non_nullable
              as String,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      postRef: freezed == postRef
          ? _value.postRef
          : postRef // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postCommentId: null == postCommentId
          ? _value.postCommentId
          : postCommentId // ignore: cast_nullable_to_non_nullable
              as String,
      postCommentReplyCount: null == postCommentReplyCount
          ? _value.postCommentReplyCount
          : postCommentReplyCount // ignore: cast_nullable_to_non_nullable
              as int,
      reportCount: null == reportCount
          ? _value.reportCount
          : reportCount // ignore: cast_nullable_to_non_nullable
              as int,
      muteCount: null == muteCount
          ? _value.muteCount
          : muteCount // ignore: cast_nullable_to_non_nullable
              as int,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userNameLanguageCode: null == userNameLanguageCode
          ? _value.userNameLanguageCode
          : userNameLanguageCode // ignore: cast_nullable_to_non_nullable
              as String,
      userNameNegativeScore: null == userNameNegativeScore
          ? _value.userNameNegativeScore
          : userNameNegativeScore // ignore: cast_nullable_to_non_nullable
              as double,
      userNamePositiveScore: null == userNamePositiveScore
          ? _value.userNamePositiveScore
          : userNamePositiveScore // ignore: cast_nullable_to_non_nullable
              as double,
      userNameSentiment: null == userNameSentiment
          ? _value.userNameSentiment
          : userNameSentiment // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      userImageURL: null == userImageURL
          ? _value.userImageURL
          : userImageURL // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Comment with DiagnosticableTreeMixin implements _Comment {
  const _$_Comment(
      {required this.createdAt,
      required this.comment,
      required this.commentLanguageCode,
      required this.commentNegativeScore,
      required this.commentPositiveScore,
      required this.commentSentiment,
      required this.likeCount,
      required this.postRef,
      required this.postCommentId,
      required this.postCommentReplyCount,
      required this.reportCount,
      required this.muteCount,
      required this.userName,
      required this.userNameLanguageCode,
      required this.userNameNegativeScore,
      required this.userNamePositiveScore,
      required this.userNameSentiment,
      required this.uid,
      required this.userImageURL,
      required this.updatedAt});

  factory _$_Comment.fromJson(Map<String, dynamic> json) =>
      _$$_CommentFromJson(json);

// const factory 違うクラスのインスタンスを返すことができるコンストラクタ
  @override
  final dynamic createdAt;
// dynamic型 なんでも許す
  @override
  final String comment;
  @override
  final String commentLanguageCode;
  @override
  final double commentNegativeScore;
  @override
  final double commentPositiveScore;
  @override
  final String commentSentiment;
  @override
  final int likeCount;
  @override
  final dynamic postRef;
  @override
  final String postCommentId;
  @override
  final int postCommentReplyCount;
  @override
  final int reportCount;
  @override
  final int muteCount;
  @override
  final String userName;
  @override
  final String userNameLanguageCode;
  @override
  final double userNameNegativeScore;
  @override
  final double userNamePositiveScore;
  @override
  final String userNameSentiment;
  @override
  final String uid;
  @override
  final String userImageURL;
  @override
  final dynamic updatedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Comment(createdAt: $createdAt, comment: $comment, commentLanguageCode: $commentLanguageCode, commentNegativeScore: $commentNegativeScore, commentPositiveScore: $commentPositiveScore, commentSentiment: $commentSentiment, likeCount: $likeCount, postRef: $postRef, postCommentId: $postCommentId, postCommentReplyCount: $postCommentReplyCount, reportCount: $reportCount, muteCount: $muteCount, userName: $userName, userNameLanguageCode: $userNameLanguageCode, userNameNegativeScore: $userNameNegativeScore, userNamePositiveScore: $userNamePositiveScore, userNameSentiment: $userNameSentiment, uid: $uid, userImageURL: $userImageURL, updatedAt: $updatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Comment'))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('comment', comment))
      ..add(DiagnosticsProperty('commentLanguageCode', commentLanguageCode))
      ..add(DiagnosticsProperty('commentNegativeScore', commentNegativeScore))
      ..add(DiagnosticsProperty('commentPositiveScore', commentPositiveScore))
      ..add(DiagnosticsProperty('commentSentiment', commentSentiment))
      ..add(DiagnosticsProperty('likeCount', likeCount))
      ..add(DiagnosticsProperty('postRef', postRef))
      ..add(DiagnosticsProperty('postCommentId', postCommentId))
      ..add(DiagnosticsProperty('postCommentReplyCount', postCommentReplyCount))
      ..add(DiagnosticsProperty('reportCount', reportCount))
      ..add(DiagnosticsProperty('muteCount', muteCount))
      ..add(DiagnosticsProperty('userName', userName))
      ..add(DiagnosticsProperty('userNameLanguageCode', userNameLanguageCode))
      ..add(DiagnosticsProperty('userNameNegativeScore', userNameNegativeScore))
      ..add(DiagnosticsProperty('userNamePositiveScore', userNamePositiveScore))
      ..add(DiagnosticsProperty('userNameSentiment', userNameSentiment))
      ..add(DiagnosticsProperty('uid', uid))
      ..add(DiagnosticsProperty('userImageURL', userImageURL))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Comment &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.commentLanguageCode, commentLanguageCode) ||
                other.commentLanguageCode == commentLanguageCode) &&
            (identical(other.commentNegativeScore, commentNegativeScore) ||
                other.commentNegativeScore == commentNegativeScore) &&
            (identical(other.commentPositiveScore, commentPositiveScore) ||
                other.commentPositiveScore == commentPositiveScore) &&
            (identical(other.commentSentiment, commentSentiment) ||
                other.commentSentiment == commentSentiment) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            const DeepCollectionEquality().equals(other.postRef, postRef) &&
            (identical(other.postCommentId, postCommentId) ||
                other.postCommentId == postCommentId) &&
            (identical(other.postCommentReplyCount, postCommentReplyCount) ||
                other.postCommentReplyCount == postCommentReplyCount) &&
            (identical(other.reportCount, reportCount) ||
                other.reportCount == reportCount) &&
            (identical(other.muteCount, muteCount) ||
                other.muteCount == muteCount) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userNameLanguageCode, userNameLanguageCode) ||
                other.userNameLanguageCode == userNameLanguageCode) &&
            (identical(other.userNameNegativeScore, userNameNegativeScore) ||
                other.userNameNegativeScore == userNameNegativeScore) &&
            (identical(other.userNamePositiveScore, userNamePositiveScore) ||
                other.userNamePositiveScore == userNamePositiveScore) &&
            (identical(other.userNameSentiment, userNameSentiment) ||
                other.userNameSentiment == userNameSentiment) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.userImageURL, userImageURL) ||
                other.userImageURL == userImageURL) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(createdAt),
        comment,
        commentLanguageCode,
        commentNegativeScore,
        commentPositiveScore,
        commentSentiment,
        likeCount,
        const DeepCollectionEquality().hash(postRef),
        postCommentId,
        postCommentReplyCount,
        reportCount,
        muteCount,
        userName,
        userNameLanguageCode,
        userNameNegativeScore,
        userNamePositiveScore,
        userNameSentiment,
        uid,
        userImageURL,
        const DeepCollectionEquality().hash(updatedAt)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CommentCopyWith<_$_Comment> get copyWith =>
      __$$_CommentCopyWithImpl<_$_Comment>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CommentToJson(
      this,
    );
  }
}

abstract class _Comment implements Comment {
  const factory _Comment(
      {required final dynamic createdAt,
      required final String comment,
      required final String commentLanguageCode,
      required final double commentNegativeScore,
      required final double commentPositiveScore,
      required final String commentSentiment,
      required final int likeCount,
      required final dynamic postRef,
      required final String postCommentId,
      required final int postCommentReplyCount,
      required final int reportCount,
      required final int muteCount,
      required final String userName,
      required final String userNameLanguageCode,
      required final double userNameNegativeScore,
      required final double userNamePositiveScore,
      required final String userNameSentiment,
      required final String uid,
      required final String userImageURL,
      required final dynamic updatedAt}) = _$_Comment;

  factory _Comment.fromJson(Map<String, dynamic> json) = _$_Comment.fromJson;

  @override // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
  dynamic get createdAt;
  @override // dynamic型 なんでも許す
  String get comment;
  @override
  String get commentLanguageCode;
  @override
  double get commentNegativeScore;
  @override
  double get commentPositiveScore;
  @override
  String get commentSentiment;
  @override
  int get likeCount;
  @override
  dynamic get postRef;
  @override
  String get postCommentId;
  @override
  int get postCommentReplyCount;
  @override
  int get reportCount;
  @override
  int get muteCount;
  @override
  String get userName;
  @override
  String get userNameLanguageCode;
  @override
  double get userNameNegativeScore;
  @override
  double get userNamePositiveScore;
  @override
  String get userNameSentiment;
  @override
  String get uid;
  @override
  String get userImageURL;
  @override
  dynamic get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$_CommentCopyWith<_$_Comment> get copyWith =>
      throw _privateConstructorUsedError;
}
