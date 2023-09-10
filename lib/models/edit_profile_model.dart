// dart
import 'dart:io';
// flutter
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/lists.dart';
import 'package:sonanceep_sns/constants/maps.dart';
import 'package:sonanceep_sns/constants/voids.dart'as voids;
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// constants
import 'package:sonanceep_sns/constants/others.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
// domain
import 'package:sonanceep_sns/domain/user_update_log/user_update_log.dart';

final editProfileProvider = ChangeNotifierProvider(
  ((ref) => EditProfileModel()
));
class EditProfileModel extends ChangeNotifier {
  File? croppedFile = null;
  String userName = "";

  Future<void> updateUserInfo({required BuildContext context, required MainModel mainModel}) async {
    String userImageURL = '';
    // userNameとcroppedがどっちもnullだったら行う必要ない
    if(!(userName.isEmpty && croppedFile == null)) {
      // userNameとcroppedFileどっちかの情報がある状態
      final currentUserDoc = mainModel.currentUserDoc;
      final firestoreUser = mainModel.firestoreUser;
      if(croppedFile != null) {
        userImageURL = await uploadImageAndGetURL(uid: currentUserDoc.id, file: croppedFile!);
      } else {
        // croppedFileがnullなら
        userImageURL = firestoreUser.userImageURL;
      }
      if(userName.isEmpty) {
        userName = firestoreUser.userName;
      }
      mainModel.updateFrontUserInfo(newUserName: userName, newUserImageURL: userImageURL);
      Navigator.pop(context);  //ひとつ前のページに戻る
      final UserUpdateLog updateLog = UserUpdateLog(
        logCreatedAt: Timestamp.now(),
        searchToken: returnSearchToken(searchWords: returnSearchWords(searchTerm: userName)),
        userName: userName,
        userImageURL: userImageURL,
        userRef: currentUserDoc.reference,
        uid: currentUserDoc.id,
      );
      await currentUserDoc.reference.collection('userUpdateLogs').doc().set(updateLog.toJson());  //アプリから呼び出すことがなく消すことも無いから、idを指定する必要がない。    .doc()とidを指定しないと勝手に生成してくれる
    }
  }


  // File? croppedFile = null;

  // Future<void> pickImage() async {
  //   xFile = await returnXFile();
  // }

  Future<String> uploadImageAndGetURL({required String uid, required File file}) async {  //Fileを使うには import 'dart:io';
    final String fileName = returnJpgFileName();
    final Reference storageRef = FirebaseStorage.instance.ref().child('users').child(uid).child(fileName);
    // users/uid/ファイル名 にアップロード
    await storageRef.putFile(file);
    // users/uid/ファイル名 のURLを取得している
    return await storageRef.getDownloadURL();  // Future の場合時間がかかる処理のため await が必要
  }

  Future<void> onImageTapped() async {
    final XFile xFile = await returnImageXFile();
    croppedFile = await returnCroppedFile(xFile: xFile);
    notifyListeners();
  }
}