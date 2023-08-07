// flutter
// import 'package:flash/flash_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// constants
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/constants/strings.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flash/flash.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/domain/post/post.dart';
import 'package:sonanceep_sns/models/main_model.dart';

final createPostProvider = ChangeNotifierProvider(
  ((ref) => CreatePostModel()
));

class CreatePostModel extends ChangeNotifier {

  final TextEditingController textEditingController = TextEditingController();
  String text = '';

  void showPostFlashBar({
    required BuildContext context,
    required MainModel mainModel,
  }) {
    context.showFlashBar(
      persistent: true,
      content: Form(
        child: TextFormField(
          controller: textEditingController,
          style: const TextStyle(fontWeight: FontWeight.bold),
          onChanged: (value) => text = value,
          maxLength: 10,
        ),
      ),
      title: const Text(createPostTitle),
      // ボタンのメインの動作
      primaryActionBuilder: (context, controller, _) {
        return InkWell(
          child: const Icon(Icons.send),
          onTap: () async {
            if(textEditingController.text.isNotEmpty) {
              //メインの動作
              await createPost(mainModel: mainModel);
              await controller.dismiss();
              text = '';
            } else {
              //何もしない
              await controller.dismiss();
            }
          },
        );
      },
      // 閉じる時の動作
      negativeActionBuilder: (context, controller, _)  {
        return InkWell(
          child: const Icon(Icons.close),
          onTap: () async => await controller.dismiss(),
        );
      },
    );
  }

  Future<void> createPost({required MainModel mainModel}) async {
    final Timestamp now = Timestamp.now();
    final DocumentSnapshot<Map<String,dynamic>> currentUserDoc = mainModel.currentUserDoc;
    final FirestoreUser firestoreUser = mainModel.firestoreUser;
    final String activeUid = currentUserDoc.id;
    final String postId = returnUuidV4();
    final Post post = Post(
      createdAt: now,
      hashTags: [],
      imageURL: '',
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
  }
}