// flutter
// import 'package:flash/flash_helper.dart';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sonanceep_sns/constants/others.dart';
// constants
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/constants/strings.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flash/flash.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/domain/post/post.dart';
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:video_player/video_player.dart';

final createPostProvider = ChangeNotifierProvider(
  ((ref) => CreatePostModel()
));

class CreatePostModel extends ChangeNotifier {

  File? croppedFile = null;
  String text = '';
  String imageURL = '';

  Future<void> showPost({
    required BuildContext context,
    required MainModel mainModel,
  }) async {
    // //画像の投稿
    // // textとcroppedがどっちもnullだったら行う必要ない
    // if(!(text.isEmpty && croppedFile == null)) {
    //   final currentUserDoc = mainModel.currentUserDoc;
    //   if(croppedFile != null) {
    //     imageURL = await uploadImageAndGetURL(uid: currentUserDoc.id, file: croppedFile!);
    //   } else {
    //     // croppedFileがnullなら
    //     imageURL = '';
    //   }
    //   if(text.isNotEmpty) {
    //     await createPost(mainModel: mainModel, context: context);
    //     text = '';
    //   }
    // }

    // 動画の投稿
    if(!(text.isEmpty && croppedFile == null)) {
      final currentUserDoc = mainModel.currentUserDoc;
      if(croppedFile != null) {
        imageURL = await uploadVideoAndGetURL(uid: currentUserDoc.id, file: croppedFile!);
      } else {
        // croppedFileがnullなら
        imageURL = '';
      }
      if(text.isNotEmpty) {
        await createPost(mainModel: mainModel, context: context);
        text = '';
      }
    }





    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     final textEditingController = TextEditingController();
    //     return AlertDialog(
    //       title: const Text(createPostTitle),
    //       content: Form(
    //         child: TextFormField(
    //           controller: textEditingController,
    //           style: const TextStyle(fontWeight: FontWeight.bold),
    //           maxLength: 10,
    //         ),
    //       ),
    //       actions: [
    //         TextButton(
    //           onPressed: () async => await onImageTapped(),
    //           child: const Icon(Icons.link),
    //         ),
    //         //送信
    //         TextButton(
    //           onPressed: () async {
    //             if(textEditingController.text.isNotEmpty) {
    //               //メインの動作
    //               await createPost(mainModel: mainModel);
    //               Navigator.pop(context);
    //             } else {
    //               //何もしない
    //               Navigator.pop(context);
    //             }
    //           },
    //           child: const Icon(Icons.send),
    //         ),
    //         //閉じる
    //         TextButton(
    //           onPressed: () async => Navigator.pop(context),
    //           child: const Icon(Icons.close),
    //         ),
    //       ],
    //       insetPadding: const EdgeInsets.all(20),
    //     );
    //   },
    // );
  }

  Future<void> createPost({required MainModel mainModel, required BuildContext context}) async {
    final Timestamp now = Timestamp.now();
    final DocumentSnapshot<Map<String,dynamic>> currentUserDoc = mainModel.currentUserDoc;
    final FirestoreUser firestoreUser = mainModel.firestoreUser;
    final String activeUid = currentUserDoc.id;
    final String postId = returnUuidV4();
    final Post post = Post(
      createdAt: now,
      hashTags: [],
      imageURL: imageURL,
      likeCount: 0,
      text: text,
      textLanguageCode: '',
      textNegativeScore: 0,
      textPositiveScore: 0,
      textSentiment: '',
      commentCount: 0,
      postId: postId,
      reportCount: 0,
      muteCount: 0,
      uid: activeUid,
      userImageURL: firestoreUser.userImageURL,
      userName: firestoreUser.userName,
      userNameLanguageCode: firestoreUser.userNameLanguageCode,
      userNameNegativeScore: firestoreUser.userNameNegativeScore,
      userNamePositiveScore: firestoreUser.userNamePositiveScore,
      userNameSentiment: firestoreUser.userNameSentiment,
      updatedAt: now,
    );
    await currentUserDoc.reference.collection('posts').doc(postId).set(post.toJson());  // main_model.dartで最初に取得したcurrentUserDocの下に投稿を作成する
    await voids.showFlutterToast(msg: createdPostMsg);
    Navigator.pop(context);  //ひとつ前のページに戻る
  }

  // // 画像のURLを読み取る
  // Future<String> uploadImageAndGetURL({required String uid, required File file}) async {  //Fileを使うには import 'dart:io';
  //   final String fileName = returnJpgFileName();
  //   final Reference storageRef = FirebaseStorage.instance.ref().child('users').child(uid).child(fileName);
  //   // users/uid/ファイル名 にアップロード
  //   // await storageRef.putFile(file);
  //   // users/uid/ファイル名 のURLを取得している
  //   return await storageRef.getDownloadURL();  // Future の場合時間がかかる処理のため await が必要
  // }

  // 動画のURLを読み取る
  Future<String> uploadVideoAndGetURL({required String uid, required File file}) async {
    // ファイル名を生成
    final String fileName = returnMp4FileName();
    // Firebase Storageの参照を作成
    final Reference storageRef = FirebaseStorage.instance.ref().child('users').child(uid).child(fileName);
    // users/uid/ファイル名 にアップロード
    await storageRef.putFile(file);
    // users/uid/ファイル名 のURLを取得している
    return await storageRef.getDownloadURL();  // Future の場合時間がかかる処理のため await が必要
  }

  // // 画像のfileを読み取る
  // Future<void> onImageTapped() async {
  //   final XFile xFile = await returnImageXFile();
  //   croppedFile = await returnCroppedFile(xFile: xFile);
  //   notifyListeners();
  // }

  // 動画のfileを読み取る
  Future<void> onVideoTapped() async {
    final XFile xFile = await returnVideoXFile();
    croppedFile = File(xFile.path);
    notifyListeners();
  }
}