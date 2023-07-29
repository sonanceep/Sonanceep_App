// flutter
import 'package:flutter/cupertino.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/domain/mute_post_token/mute_post_token.dart';
import 'package:sonanceep_sns/domain/post_mute/post_mute.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:sonanceep_sns/constants/enums.dart';
import 'package:sonanceep_sns/constants/ints.dart';
import 'package:sonanceep_sns/constants/others.dart';
import 'package:sonanceep_sns/constants/strings.dart';
// domains

// domain
import 'package:sonanceep_sns/models/main_model.dart';

final mutePostsProvider = ChangeNotifierProvider(
  ((ref) => MutePostsModel()
));
class MutePostsModel extends ChangeNotifier {

  bool showMutePosts = false;
  List<String> mutePostIds = [];
  List<DocumentSnapshot<Map<String,dynamic>>> mutePostDocs = [];
  final RefreshController refreshController = RefreshController();
  List<MutePostToken> newMutePostTokens = [];  //新しくミュートするユーザー
  // 新しくミュートするユーザー
  Query<Map<String, dynamic>> returnQuery({
    required List<String> max10MutePostIds
  }) => FirebaseFirestore.instance.collectionGroup('posts').where('postId', whereIn: max10MutePostIds);  // .orderBy()はクエリが必要    .collectionGroup('posts')によりrulesを作成

  Future<void> getMutePosts({
    required MainModel mainModel,
  }) async {
    showMutePosts = true;
    mutePostIds = mainModel.mutePostIds;
    await process();
    notifyListeners();
  }

  Future<void> onRefresh({required MainModel mainModel}) async {
    refreshController.refreshCompleted();
    //複雑な処理
    //必ずしも実装する必要はない
    //新しく取得するのは能動的
    // mainModelでnewMutePostIds
    // onRefreshされたら配列を空にする
    await processNewMutePosts();
    notifyListeners();
  }

  Future<void> onReload() async {
    await process();
    notifyListeners();
  }

  Future<void> onLoading() async {
    refreshController.loadComplete();
    await process();
    notifyListeners();
  }

  Future<void> processNewMutePosts() async {
    final List<String> newMutePostIds = newMutePostTokens.map((e) => e.postId).toList();  // newMutePostTokensをfor文で回してpostIdだけをまとめている
    //新しくミュートしたコメントが10人以上の場合
    final List<String> max10MutePostIds = newMutePostIds.length > 10 ? 
    newMutePostIds.sublist(0, tenCount)  // 10より大きかったら10個取り出す
    : newMutePostIds;                    // 10より小さかったらそのまま適応
    if(max10MutePostIds.isNotEmpty) {
      final qshot = await returnQuery(max10MutePostIds: max10MutePostIds).get();
      final reversed = qshot.docs.reversed.toList();  //いつもの新しいdocsに対して行う処理
      for(final mutePostDoc in reversed) {
        mutePostDocs.insert(0, mutePostDoc);
        // mutemutePostDocに加えたということはもう新しくない
        //新しいものリストから省く
        // tokenに含まれるpostIdがミュートされるべきユーザーと同じpostIdのものを取得
        final deleteNewMutePostTokens = newMutePostTokens.where((element) => element.postId == mutePostDoc.id).toList().first;
        newMutePostTokens.remove(deleteNewMutePostTokens);
      }
    }
    notifyListeners();
  }

  Future<void> process() async {
    if(mutePostIds.length > mutePostDocs.length) {
      final int mutePostDocsLength = mutePostDocs.length;  //序盤のmutemutePostDocsの長さを保持
      // whereInで検索にかけたので、max10MutePostIdsには10個までしかpostIdを入れない
      final List<String> max10MutePostIds = (mutePostIds.length - mutePostDocs.length) > 10 ? 
      mutePostIds.sublist(mutePostDocsLength, mutePostDocsLength + tenCount) : mutePostIds.sublist(mutePostDocsLength, mutePostIds.length);  // sublistはリストを分解
      if(max10MutePostIds.isNotEmpty) {
        final qshot = await returnQuery(max10MutePostIds: max10MutePostIds).get();
        for(final mutePostDoc in qshot.docs) {
          mutePostDocs.add(mutePostDoc);
        }
      }
    }
    notifyListeners();
  }

  Future<void> mutePost({
    required MainModel mainModel,
    required DocumentSnapshot<Map<String,dynamic>> postDoc,  // docsにはpostDocs、PostDocsが含まれる
    required List<DocumentSnapshot<Map<String,dynamic>>> postDocs,
  }) async {
    final String tokenId = returnUuidV4();
    final currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;
    final Timestamp now = Timestamp.now();
    final postRef = postDoc.reference;
    final String postId = postDoc.id;
    final MutePostToken mutePostToken = MutePostToken(
      activeUid: activeUid,
      createdAt: now,
      postId: postId,
      postRef: postRef,
      tokenId: tokenId,
      tokenType: mutePostTokenTypeString,
    );
    newMutePostTokens.add(mutePostToken);  //新しくミュートしたコメント
    mainModel.mutePostTokens.add(mutePostToken);  // mutePostTokensに投稿のミュートした人のIdを含めた
    mainModel.mutePostIds.add(postId);
    postDocs.remove(postDoc);  //ミュートしたコメントを除外する
    notifyListeners();
    // currentUserDoc.ref...
    // 自分がミュートしたことの印
    await userDocToTokenDocRef(currentUserDoc: currentUserDoc, tokenId: tokenId).set(mutePostToken.toJson());
    //ミュートされたことの印
    final PostMute postMute = PostMute(
      activeUid: activeUid,
      createdAt: now,
      postId: postId,
      postRef: postRef,
    );
    await postDoc.reference.collection('postMutes').doc(activeUid).set(postMute.toJson());  // .collection('postMutes')によりrulesを作成
  }

  void showMutePostDialog({
    required BuildContext context,
    required MainModel mainModel,
    required DocumentSnapshot<Map<String,dynamic>> postDoc,  // docsにはpostDocs、PostDocsが含まれる
    required List<DocumentSnapshot<Map<String,dynamic>>> postDocs,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext innerContext) => CupertinoAlertDialog(
        // title: const Text('コメントをミュートする'),
        content: const Text(mutePostAlertMsg),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(innerContext),
            child: const Text(noText),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(innerContext);
              await mutePost(mainModel: mainModel, postDoc: postDoc, postDocs: postDocs);
            },
            child: const Text(yesText),
          ),
        ],
      ),
    );
  }

  // void showMutePostPopup({
  //   required BuildContext context,
  //   required MainModel mainModel,
  //   required DocumentSnapshot<Map<String,dynamic>> PostDoc,  // docsにはpostDocs、PostDocsが含まれる
  //   required List<DocumentSnapshot<Map<String,dynamic>>> PostDocs,
  // }) {
  //   showCupertinoModalPopup(
  //     context: context,
  //     //中で別のcontextのinnerContextを生成する
  //     builder: (BuildContext innerContext) => CupertinoActionSheet(  // contextとは違う名前にする方が良い
  //       // title: const Text('行う操作を選択'),
  //       actions: <CupertinoActionSheetAction>[
  //         CupertinoActionSheetAction(
  //           isDestructiveAction: true,
  //           onPressed: () {
  //             Navigator.pop(innerContext);
  //             showMutePostDialog(context: context, mainModel: mainModel, PostDoc: PostDoc, PostDocs: PostDocs);
  //           },
  //           child: const Text(mutePostText),
  //         ),
  //         CupertinoActionSheetAction(
  //           onPressed: () => Navigator.pop(innerContext),
  //           child: const Text(backText),
  //         ),
  //       ],
  //     ) 
  //   );
  // }

  Future<void> unMutePost({
    required MainModel mainModel,
    required DocumentSnapshot<Map<String,dynamic>> postDoc,  // docsにはpostDocs、PostDocsが含まれる
    required List<DocumentSnapshot<Map<String,dynamic>>> postDocs,
  }) async {
    // nutePostsModel側の処理
    final String postId = postDoc.id;
    mutePostDocs.remove(postDoc);
    mainModel.mutePostIds.remove(postId);
    final currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;
    final MutePostToken deleteMutePostToken = mainModel.mutePostTokens.where((element) => element.postId == postId).toList().first;
    if(newMutePostTokens.contains(deleteMutePostToken)) {  //もし削除するミュートコメントが新しいやつなら
      newMutePostTokens.remove(deleteMutePostToken);
    }
    mainModel.mutePostTokens.remove(deleteMutePostToken);
    notifyListeners();
    //自分がミュートしたことの印を削除
    await userDocToTokenDocRef(currentUserDoc: currentUserDoc, tokenId: deleteMutePostToken.tokenId).delete();
    //コメントのミュートされた印を削除
    final DocumentReference<Map<String,dynamic>> mutePostRef = deleteMutePostToken.postRef;
    await mutePostRef.collection('postMutes').doc(activeUid).delete();
  }

  void showUnMutePostDialog({
    required BuildContext context,
    required MainModel mainModel,
    required DocumentSnapshot<Map<String,dynamic>> postDoc,  // docsにはpostDocs、PostDocsが含まれる
    required List<DocumentSnapshot<Map<String,dynamic>>> postDocs,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext innerContext) => CupertinoAlertDialog(
        // title: const Text('ユーザーのミュートを解除する'),
        content: const Text(unMutePostAlertMsg),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(innerContext),
            child: const Text(noText),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(innerContext);
              await unMutePost(mainModel: mainModel, postDoc: postDoc, postDocs: postDocs);
            },
            child: const Text(yesText),
          ),
        ],
      ),
    );
  }

  // void showUnMuteUserPopup({
  //   required BuildContext context,
  //   required MainModel mainModel,
  //   required DocumentSnapshot<Map<String,dynamic>> PostDoc,  // docsにはpostDocs、PostDocsが含まれる
  //   required List<DocumentSnapshot<Map<String,dynamic>>> PostDocs,
  // }) {
  //   showCupertinoModalPopup(
  //     context: context,
  //     //中で別のcontextのinnerContextを生成する
  //     builder: (BuildContext innerContext) => CupertinoActionSheet(  // contextとは違う名前にする方が良い
  //       // title: const Text('行う操作を選択'),
  //       actions: <CupertinoActionSheetAction>[
  //         CupertinoActionSheetAction(
  //           onPressed: () {
  //             Navigator.pop(innerContext);
  //             showUnMuteUserDialog(context: context, mainModel: mainModel, PostDoc: PostDoc, PostDocs: PostDocs);
  //           },
  //           child: const Text(unMuteUserText),
  //         ),
  //         CupertinoActionSheetAction(
  //           onPressed: () => Navigator.pop(innerContext),
  //           child: const Text(backText),
  //         ),
  //       ],
  //     ) 
  //   );
  // }
}