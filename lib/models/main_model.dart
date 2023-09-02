// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sonanceep_sns/constants/enums.dart';
// constants
import 'package:sonanceep_sns/constants/routes.dart' as routes;
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;
// domain
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/domain/following_token/following_token.dart';
import 'package:sonanceep_sns/domain/like_comment_token/like_comment_token.dart';
import 'package:sonanceep_sns/domain/like_post_token/like_post_token.dart';
import 'package:sonanceep_sns/domain/like_reply_token/like_reply_token.dart';
import 'package:sonanceep_sns/domain/mute_comment_token/mute_comment_token.dart';
import 'package:sonanceep_sns/domain/mute_post_token/mute_post_token.dart';
import 'package:sonanceep_sns/domain/mute_reply_token/mute_reply_token.dart';
import 'package:sonanceep_sns/domain/mute_user_token/mute_user_token.dart';

final mainProvider = ChangeNotifierProvider(
  ((ref) => MainModel()
));  // MainModel()をグローバルに監視できるようになる

class MainModel extends ChangeNotifier {
  bool isLoading = false;

  late User? currentUser;
  late DocumentSnapshot<Map<String,dynamic>> currentUserDoc;
  late FirestoreUser firestoreUser;
  // tokens
  List<FollowingToken> followingTokens = [];
  List<String> followingUids = [];
  List<LikePostToken> likePostTokens = [];
  List<String> likePostIds = [];
  List<LikeCommentToken> likeCommentTokens = [];
  List<String> likeCommentIds = [];
  List<LikeReplyToken> likeReplyTokens = [];
  List<String> likeReplyIds = [];
  List<MuteUserToken> muteUserTokens = [];
  List<String> muteUids = [];
  List<MuteCommentToken> muteCommentTokens = [];
  List<String> muteCommentIds = [];
  List<MutePostToken> mutePostTokens = [];
  List<String> mutePostIds = [];
  List<MuteReplyToken> muteReplyTokens = [];
  List<String> muteReplyIds = [];

  // 以下３行が MainModel() が起動した時に行われる処理
  // ユーザーの動作を必要としないモデルの関数
  MainModel() {
    init();
  }

  // initの中でcurrentUserを更新すれば良い
  Future<void> init() async {
    startLoading();
    // modelを跨がないでcurrentUserの更新
    currentUser = FirebaseAuth.instance.currentUser;
    // p40gFwN3GhZiehODwdea7sbDIE63
    currentUserDoc = await FirebaseFirestore.instance.collection(usersFieldKey).doc(currentUser!.uid).get();
    // voids.showFlutterToast(msg: currentUserDoc.toString());
    await distributeTokens();
    firestoreUser = FirestoreUser.fromJson(currentUserDoc.data()!);
    // currentUserのuidの取得が可能になった
    endLoading();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setCurrentUser() {
    currentUser = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  //フォローやライク情報を保存？
  Future<void> distributeTokens() async {
    final tokensQshot = await currentUserDoc.reference.collection('tokens').get();
    // if(tokensQshot == null) voids.showFlutterToast(msg: "ユーザー作成時にtokensQshotが読み取れていない？");  // TODO
    final tokenDocs = tokensQshot.docs;
    tokenDocs.sort((a, b) => (b['createdAt'] as Timestamp).compareTo(a['createdAt']));  //新しい順に並べる 公式として理解 古い順ならaとbを逆にする

    for(final token in tokenDocs) {
      final Map<String,dynamic> tokenMap = token.data();
      // Stringからenumに変換してミスの無いようにしたい
      final TokenType tokenType = mapToTokenType(tokenMap: tokenMap);
      switch(tokenType) {  // enumsで判別して得られたtokenTypeを使ってswitch文    switch文とenumは相性が良くミスが起きない
        case TokenType.following:
          final FollowingToken followingToken = FollowingToken.fromJson(tokenMap);
          followingTokens.add(followingToken);
          followingUids.add(followingToken.passiveUid);  //フォローしているユーザーのIDがtokenから得られる
        break;
        case TokenType.likePost:
          final LikePostToken likePostToken = LikePostToken.fromJson(tokenMap);
          likePostTokens.add(likePostToken);
          likePostIds.add(likePostToken.postId);  //ライクしているユーザーのIDがtokenから得られる
        break;
        case TokenType.likeComment:
          final LikeCommentToken likeCommentToken = LikeCommentToken.fromJson(tokenMap);
          likeCommentTokens.add(likeCommentToken);
          likeCommentIds.add(likeCommentToken.postCommentId);
        break;
        case TokenType.likeReply:
          final LikeReplyToken likeReplyToken = LikeReplyToken.fromJson(tokenMap);
          likeReplyTokens.add(likeReplyToken);
          likeReplyIds.add(likeReplyToken.postCommentReplyId);
        break;
        case TokenType.muteUser:
          final MuteUserToken muteUserToken = MuteUserToken.fromJson(tokenMap);
          muteUserTokens.add(muteUserToken);
          muteUids.add(muteUserToken.passiveUid);  //ミュートされる側のID
        break;
        case TokenType.muteComment:
          final MuteCommentToken muteCommentToken = MuteCommentToken.fromJson(tokenMap);
          muteCommentTokens.add(muteCommentToken);
          muteCommentIds.add(muteCommentToken.postCommentId);  //ミュートされる側のID
        break;
        case TokenType.mutePost:
          final MutePostToken mutePostToken = MutePostToken.fromJson(tokenMap);
          mutePostTokens.add(mutePostToken);
          mutePostIds.add(mutePostToken.postId);  //ミュートされる側のID
        break;
        case TokenType.muteReply:
          final MuteReplyToken muteReplyToken = MuteReplyToken.fromJson(tokenMap);
          muteReplyTokens.add(muteReplyToken);
          muteReplyIds.add(muteReplyToken.postCommentReplyId);  //ミュートされる側のID
        break;
        case TokenType.mistake:
        break;
      }
    }
  }

  void updateFrontUserInfo({required String newUserName, required String newUserImageURL}) {  //データベース側の処理を経由しないフロントエンド側の処理なので Future でなくて良い
    // firestoreUserの中身を現在のfirestoreUserをほぼコピーしてuserNameだけ変更したものに更新
    firestoreUser = firestoreUser.copyWith(userName: newUserName, userImageURL: newUserImageURL);
    notifyListeners();
  }
}