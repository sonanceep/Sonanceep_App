import 'package:flutter/material.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/details/user_image.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/domain/message/message.dart';

class MessageFormat extends StatelessWidget {
  const MessageFormat({
    Key? key,
    required this.index,
    required this.isMine,
    required this.context,
    required this.message,
    required this.passiveUser,
  }) : super(key: key);

  final int index;
  final bool isMine;
  final BuildContext context;
  final Message message;
  final FirestoreUser passiveUser;

  @override
  Widget build(BuildContext context) {
    //与えられたmessageFormatURLが空の時に表示する
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: index == 0 ? 20 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: isMine ? TextDirection.rtl : TextDirection.ltr,  //自分は右寄せ、その他は左寄せ
        children: [
          isMine ? const SizedBox.shrink()  //空虚なウェジットを作成してスペースを作る
           : Padding(
             padding: const EdgeInsets.only(right: 6.0, bottom: 2.0),
             child: UserImage(userImageURL: passiveUser.userImageURL, length: 32.0),
           ),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),  //表示範囲を画面幅の指定割合までに設定
            decoration: BoxDecoration(
              color: isMine ? Colors.green : Colors.blue,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Text(message.message)
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2.0),
            child: Text(returnMessageTime(message: message), style: const TextStyle(fontSize: 12.0)),
          ),  // DateTime 型を文字列に変換
        ],
      ),
    );
  }
}