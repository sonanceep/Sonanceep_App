// // dart
// import 'dart:io';
// // flutter
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// // package
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// // constants
// import 'package:sonanceep_sns/constants/others.dart';
// import 'package:sonanceep_sns/constants/strings.dart';
// import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';

// final profileProvider = ChangeNotifierProvider(
//   ((ref) => ProfileModel()
// ));

// class ProfileModel extends ChangeNotifier {
//   // File? croppedFile = null;

//   // // Future<void> pickImage() async {
//   // //   xFile = await returnXFile();
//   // // }

//   // Future<String> uploadImageAndGetURL({required String uid, required File file}) async {  //Fileを使うには import 'dart:io';
//   //   final String fileName = returnJpgFileName();
//   //   final Reference storageRef = FirebaseStorage.instance.ref().child('users').child(uid).child(fileName);
//   //   // users/uid/ファイル名 にアップロード
//   //   await storageRef.putFile(file);
//   //   // users/uid/ファイル名 のURLを取得している
//   //   return storageRef.getDownloadURL();  // Future の場合時間がかかる処理のため await が必要
//   // }

//   // // Future<void> updateUserImageURL({required FirestoreUser firestoreUser}) async {
//   // //   final XFile xFile = await returnXFile();
//   // //   final String uid = firestoreUser.uid;
//   // //   final File file = File(xFile.path);  //写真のパスを取得
//   // //   croppedFile = await returnCroppedFile(xFile: xFile);
//   // //   final String url = await uploadImageAndGetURL(uid: uid, file: file);
//   // //   await FirebaseFirestore.instance.collection(usersFieldKey).doc(uid).update({  // cloudFire上のURLを更新
//   // //     'userImageURL': url,
//   // //   });
//   // //   notifyListeners();
//   // // }



//   // Future<void> uploadUserImage({required DocumentSnapshot<Map<String,dynamic>> currentUserDoc}) async {
//   //   final XFile xFile = await returnXFile();
//   //   final File file = File(xFile.path);  //写真のパスを取得
//   //   final String uid = currentUserDoc.id;
//   //   croppedFile = await returnCroppedFile(xFile: xFile);
//   //   final String url = await uploadImageAndGetURL(uid: uid, file: file);
//   //   await currentUserDoc.reference.update({  // cloudFire上のURLを更新
//   //     'userImageURL': url,
//   //   });
//   //   notifyListeners();
//   // }
// }











// flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sonanceep_sns/constants/enums.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonanceep_sns/constants/lists.dart';
// constants
import 'package:sonanceep_sns/constants/others.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;

final profileProvider = ChangeNotifierProvider(
  ((ref) => ProfileModel()
));

class ProfileModel extends ChangeNotifier {
  // bool isLoading = false;
  List<DocumentSnapshot<Map<String,dynamic>>> postDocs = [];
  SortState sortState = SortState.byNewestFirst;
  late User? currentUser;

  // final RefreshController refreshController = RefreshController();  //初期化するたびに捨てる
  List<String> muteUids = [];
  List<String> mutePostIds= [];
  Query<Map<String,dynamic>> returnQuery() {
    final User? currentUser = returnAuthUser();
    final Query<Map<String,dynamic>> query = FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).collection('posts');
    switch(sortState) {
      case SortState.byLikeUidCount:
        return query.orderBy('likeCount', descending: true);
      case SortState.byNewestFirst:
        return query.orderBy('createdAt', descending: true);
      case SortState.byOldestfirst:
        return query.orderBy('createdAt', descending: false);
    }
  }

  ProfileModel() {
    init();
  }

  Future<void> init() async {
    final muteUidsAndMutePostIds = await returnMuteUidsAndMutePostIds();
    muteUids = muteUidsAndMutePostIds.first;
    mutePostIds = muteUidsAndMutePostIds.last;
    await onReload();
  }

  Future<void> onRefresh(RefreshController refreshController) async {
    refreshController.refreshCompleted();
    await voids.processNewDocs(muteUids: muteUids, mutePostIds: mutePostIds, docs: postDocs, query: returnQuery());
    notifyListeners();
  }

  Future<void> onReload() async {
    // startLoading();
    await voids.processBasicDocs(muteUids: muteUids, mutePostIds: mutePostIds, docs: postDocs, query: returnQuery());
    // endLoading();
    notifyListeners();
  }

  Future<void> onLoading(RefreshController refreshController) async {
    refreshController.loadComplete();
    await voids.processOldDocs(muteUids: muteUids, mutePostIds: mutePostIds, docs: postDocs, query: returnQuery());
    notifyListeners();
  }

  void onMenuPressed({required BuildContext context}) {
    voids.showPopup(
      context: context,
      builder: (innerContext) {
        return CupertinoActionSheet(
          message: const Text('操作を選択'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                if(sortState != SortState.byLikeUidCount) {
                  sortState = SortState.byLikeUidCount;
                  await onReload();
                }
                Navigator.pop(innerContext);
              },
              isDestructiveAction: true,
              child: const Text('いいね順に並び替え',),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                if(sortState != SortState.byNewestFirst) {
                  sortState = SortState.byNewestFirst;
                  await onReload();
                }
                Navigator.pop(innerContext);
              },
              isDestructiveAction: true,
              child: const Text('新しい順に並び替え',),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                if(sortState != SortState.byOldestfirst) {
                  sortState = SortState.byOldestfirst;
                  await onReload();
                }
                Navigator.pop(innerContext);
              },
              isDestructiveAction: true,
              child: const Text('古い順に並び替え',),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(innerContext),
              child: const Text(backText),
            ),
          ],
        );
      }
    );
  }





























  // File? croppedFile = null;

  // // Future<void> pickImage() async {
  // //   xFile = await returnXFile();
  // // }

  // Future<String> uploadImageAndGetURL({required String uid, required File file}) async {  //Fileを使うには import 'dart:io';
  //   final String fileName = returnJpgFileName();
  //   final Reference storageRef = FirebaseStorage.instance.ref().child('users').child(uid).child(fileName);
  //   // users/uid/ファイル名 にアップロード
  //   await storageRef.putFile(file);
  //   // users/uid/ファイル名 のURLを取得している
  //   return storageRef.getDownloadURL();  // Future の場合時間がかかる処理のため await が必要
  // }

  // // Future<void> updateUserImageURL({required FirestoreUser firestoreUser}) async {
  // //   final XFile xFile = await returnXFile();
  // //   final String uid = firestoreUser.uid;
  // //   final File file = File(xFile.path);  //写真のパスを取得
  // //   croppedFile = await returnCroppedFile(xFile: xFile);
  // //   final String url = await uploadImageAndGetURL(uid: uid, file: file);
  // //   await FirebaseFirestore.instance.collection(usersFieldKey).doc(uid).update({  // cloudFire上のURLを更新
  // //     'userImageURL': url,
  // //   });
  // //   notifyListeners();
  // // }



  // Future<void> uploadUserImage({required DocumentSnapshot<Map<String,dynamic>> currentUserDoc}) async {
  //   final XFile xFile = await returnXFile();
  //   final File file = File(xFile.path);  //写真のパスを取得
  //   final String uid = currentUserDoc.id;
  //   croppedFile = await returnCroppedFile(xFile: xFile);
  //   final String url = await uploadImageAndGetURL(uid: uid, file: file);
  //   await currentUserDoc.reference.update({  // cloudFire上のURLを更新
  //     'userImageURL': url,
  //   });
  //   notifyListeners();
  // }
}