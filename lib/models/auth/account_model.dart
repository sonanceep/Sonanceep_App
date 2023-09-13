// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sonanceep_sns/constants/enums.dart';
// constants
import 'package:sonanceep_sns/constants/others.dart';
import 'package:sonanceep_sns/constants/routes.dart' as routes;
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
// domain

final accountProvider = ChangeNotifierProvider(
  ((ref) => AccountModel()
));

class AccountModel extends ChangeNotifier {
  User? currentUser = returnAuthUser();
  String password = '';
  bool isObscure = true;

  ReauthenticationState reauthenticationState = ReauthenticationState.initialValue;

  // routs処理も同時にこなさなければならない
  Future<void> reauthenticateWithCredention({
    required BuildContext context,
    required FirestoreUser firestoreUser,
  }) async {
    //まず再認証をする
    currentUser = returnAuthUser();
    final String email = currentUser!.email!;
    final AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);  //認証情報  個人のFirebaseAuthの大事な作業に必要

    try {
      //エラーをcatchしたらその瞬間、tyrの中の処理は中断される
      await currentUser!.reauthenticateWithCredential(credential);
      //認証が完了したらメッセージを表示する
      await voids.showFlutterToast(msg: reauthenticatedMsg);
      switch(reauthenticationState) {
        case ReauthenticationState.initialValue:
        break;
        case ReauthenticationState.updatePassword:
          // updatePasswordに飛ばす
          routes.toUpdatePasswordPage(context: context);
        break;
        case ReauthenticationState.updateEmail:
          // updateEmailに飛ばす
          routes.toUpdateEmailPage(context: context);
        break;
        case ReauthenticationState.deleteUser:
          //ユーザーを削除するDialogを表示する
          showDeleteUserDialog(context: context, firestoreUser: firestoreUser);
        break;
      }
    } on FirebaseAuthException catch(e) {
      String msg = '';
      switch(e.code) {
        case 'wrong-password':
          msg = wrongPasswordMsg;
        break;
        case 'invalid-email':
          msg = invalidEmailMsg;
        break;
        case 'invalid-credential':
          msg = invailCredentialMsg;
        break;
        case 'user-not-found':
          msg = userNotFoundMsg;
        break;
        case 'user-mismatc':
          msg = userMismaticMsg;
        break;
      }
      voids.showFlutterToast(msg: msg);
    }
  }

  void toggleIsObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future<void> logout({required BuildContext context/*, required MainModel mainModel*/}) async {
    await FirebaseAuth.instance.signOut();
    final String msg = returnL10n(context: context).logoutedMsg;
    routes.toFinishedPage(context: context, msg: msg);
  }

  void showDeleteUserDialog({
    required BuildContext context,
    required FirestoreUser firestoreUser,
  }) {
    final l10n = returnL10n(context: context);

    showCupertinoModalPopup(
      context: context,
      builder: (innerContext) => CupertinoAlertDialog(
        content: Text(l10n.deleteUserAlertMsg),
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
              await deleteUser(context: context, firestoreUser: firestoreUser);
            },
            child: const Text(yesText),
          ),
        ],
      ),
    );
  }

  Future<void> deleteUser({
    required BuildContext context,
    required FirestoreUser firestoreUser,
  }) async {
    // FinishedPageに飛ばす
    final l10n = returnL10n(context: context);
    final String msg = l10n.userDeletedMsg;
    routes.toFinishedPage(context: context, msg: msg);

    //ユーザーの削除にはReauthenticationが必要
    //ユーザーの削除はFirebaseAuthのトークンが必要
    final User currentUser = returnAuthUser()!;
    // deleteUserを作成する

    try {
      await FirebaseFirestore.instance.collection('deleteUsers').doc(currentUser.uid).set(firestoreUser.toJson()).then((_) => currentUser.delete());
    } on FirebaseException catch(e) {
      if(e.code == 'requires-recent-login') {
        voids.showFlutterToast(msg: l10n.requiresRecentLoginMsg);
      }
    }
  }
}