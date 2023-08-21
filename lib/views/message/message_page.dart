import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/models/main/message_model.dart';

class MessagePage extends ConsumerWidget {
  MessagePage({
    Key? key,
    required this.passiveUser,
  }) : super(key: key);

  final FirestoreUser passiveUser;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final MessageModel messageModel = ref.watch(messageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("メッセージ相手の名前"),
      ),
      body: Stack(
        children: [

          Column(
            // mainAxisSize: MainAxisSize.min,  //下寄せ
            mainAxisAlignment: MainAxisAlignment.end,  //最終的な下寄せ
            children: [
              Container(
                color: Colors.white,
                height: 60,
                child: Row(  //入力欄、送信ボタン類
                  children: [
                   Expanded(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: controller,  //入力された文字列を取得
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          border: OutlineInputBorder()
                        ),
                      ),
                    )),
                    IconButton(
                      onPressed: () async {
                        await messageModel.sendMessage(
                          roomId: "",
                          message: controller.text,
                        );
                        controller.clear();  //入力欄の文字列をクリア
                      },
                      icon: const Icon(Icons.send)
                    )
                  ],
                ),
              ),
              Container(  //ホームに戻る時に干渉しないようにする余白
                color: Colors.white,
                height: MediaQuery.of(context).padding.bottom,
              ),
            ],
          )
        ],
      ),
    );
  }
}