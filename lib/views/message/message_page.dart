import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sonanceep_sns/constants/bools.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/details/message_format.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/domain/message/message.dart';
import 'package:sonanceep_sns/models/main/message_model.dart';
import 'package:sonanceep_sns/models/main_model.dart';

class MessagePage extends ConsumerWidget {
  MessagePage({
    Key? key,
    required this.mainModel,
    required this.passiveUser,
  }) : super(key: key);

  final MainModel mainModel;
  final FirestoreUser passiveUser;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final MessageModel messageModel = ref.watch(messageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(passiveUser.userName),
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: messageModel.fetchMessageSnapshot(mainModel: mainModel, passiveUser: passiveUser),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if(!snapshot.hasData) {
                return const Text("データがありません");
              } else {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: ListView.builder(
                    physics: const RangeMaintainingScrollPhysics(),  //画面幅を超えるリストの要素が表示されればスクロール可能になる
                    shrinkWrap: true,  //リストの要素数幅分にコンパクト化
                    reverse: true,  //リストが下に追加されていくように
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final bool isMine = messageIsMine(mainModel: mainModel, snapshot: snapshot, index: index);
                      final Message message = messageModel.messageSnapshot(snapshot: snapshot, index: index);
                      DateTime date = message.createdAt.toDate();
                      return (index <= snapshot.data!.docs.length - 2) && 
                      (date.day == messageModel.messageSnapshot(snapshot: snapshot, index: index + 1).createdAt.toDate().day) ? 
                      MessageFormat(index: index, isMine: isMine, context: context, message: message, passiveUser: passiveUser)
                      : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),  //表示範囲を画面幅の指定割合までに設定
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                              child: Text(returnMessageDate(message: message), style: const TextStyle(fontSize: 12.0)),
                            ),
                          ),
                          MessageFormat(index: index, isMine: isMine, context: context, message: message, passiveUser: passiveUser),
                        ],
                      );
                    }
                  ),
                );
              }
            }
          ),
          Column(
            // mainAxisSize: MainAxisSize.min,  //下寄せ
            mainAxisAlignment: MainAxisAlignment.end,  //最終的な下寄せ
            children: [
              Container(
                color: Colors.grey,
                height: 60,
                child: Row(  //入力欄、送信ボタン類
                  children: [
                   Expanded(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: controller,  //入力された文字列を取得
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )),
                    IconButton(
                      onPressed: () async {
                        await messageModel.sendMessage(mainModel: mainModel, passiveUser: passiveUser, text: controller.text);
                        controller.clear();  //入力欄の文字列をクリア
                      },
                      icon: const Icon(Icons.send)
                    )
                  ],
                ),
              ),
              Container(  //ホームに戻る時に干渉しないようにする余白
                color: Colors.grey,
                height: MediaQuery.of(context).padding.bottom,
              ),
            ],
          )
        ],
      ),
    );
  }
}