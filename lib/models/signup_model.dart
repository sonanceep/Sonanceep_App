// flutter
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/lists.dart';
import 'package:sonanceep_sns/constants/maps.dart';
import 'package:sonanceep_sns/constants/others.dart';
// constants
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/routes.dart' as routes;
// domain
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';

final signupProvider = ChangeNotifierProvider(
  ((ref) => SignupModel()
));  // SignupModel()をグローバルに監視できるようになる

class SignupModel extends ChangeNotifier {
  int counter = 0;
  final User? currentUser = returnAuthUser();
  // auth  email,passwordの変数を作成
  String email = '';
  String password = '';
  bool isObscure = true;  //アカウント作成時等、入力を隠すかどうか

  //ユーザー作成
  Future<void> createFirestoreUser({required BuildContext context, required String uid}) async {
      //被りなしのランダムなIDを生成する準備
      // final uuid = Uuid();
      // final String v4 = uuid.v4();
      //クラス化されたjson形式の取得
      final Timestamp now = Timestamp.now();
      final FirestoreUser firestoreUser = FirestoreUser(
        createdAt: now,
        updatedAt: now,
        followerCount: 0,
        followingCount: 0,
        isAdmin: false,
        searchToken: returnSearchToken(searchWords: returnSearchWords(searchTerm: aliceName)),
        postCount: 0,
        muteCount: 0,
        talkRoomCount: 0,
        userName: aliceName,
        uid: uid,
        userImageURL: '',
        userNameLanguageCode: '',
        userNameNegativeScore: 0,
        userNamePositiveScore: 0,
        userNameSentiment: '',
      );  //userName uid が足りていなかったら教えてくれる
      //ユーザー情報の取得
      final Map<String,dynamic> userData = firestoreUser.toJson();  //firestoreUser.toJson() でユーザー情報を得る
      // Cloud Firestore に格納
      await FirebaseFirestore.instance.collection(usersFieldKey).doc(uid).set(userData);  //doc(空) ランダムなIDとなるがuserDataにuidを含めない
      //ユーザー作成完了のバナー
      await voids.showFlutterToast(msg: userCreatedMsg);
      notifyListeners();
  }

  //ユーザー作成  FirevbaseAuthを使用
  Future<void> createUser({required BuildContext context}) async {
    try {
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final User? user = result.user;
      final String uid = user!.uid;
      await createFirestoreUser(context: context, uid: uid);  //新規作成
      routes.toVerifyEmailPage(context: context);
    } on FirebaseAuthException catch(e) {  // .createUserWithEmailAndPasswordによってエラーが生じる
      final String errorCode = e.code;
      switch(errorCode) {
        case 'email-already-in-use':
          await voids.showFlutterToast(msg: emailAlreadyInUseMsg);
        break;
        case 'operation-not-allowed':
          // Firebaseでemail/passwordが許可されていない
          // 開発側の過失
          debugPrint(firebaseAuthEmailOperationNotAllowed);
        break;
        case 'weak-password':
          await voids.showFlutterToast(msg: weakPasswordMsg);
        break;
        case 'invalid-email':
          await voids.showFlutterToast(msg: invalidEmailMsg);
        break;
      }
    }
  }

  void toggleIsObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }
}