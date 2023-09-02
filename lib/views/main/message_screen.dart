// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/routes.dart' as routes;
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/details/user_image.dart';
import 'package:sonanceep_sns/domain/firestore_room/firestore_room.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/models/main/message_model.dart';
import 'package:sonanceep_sns/models/main_model.dart';

class MessageScreen extends ConsumerWidget {
  const MessageScreen({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;
  // final 

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final MessageModel messageModel = ref.watch(messageProvider);
    // final CollectionReference usersCollection = FirebaseFirestore.instance.collection(usersFieldKey);

    return Scaffold(
      appBar: AppBar(
        title: const Text(messageText),
      ),
      // body:FutureBuilder<QuerySnapshot>(
      //   future: usersCollection.get(),
      //   builder: (context, futureSnapshot){
      //     if(futureSnapshot.connectionState == ConnectionState.waiting) {  //ロード中
      //       return const Center(child: CircularProgressIndicator());
      //     } else {
      //       if(futureSnapshot.hasData) {
      //         List<FirestoreRoom> talkRooms = futureSnapshot.data!;
      //         return ListView.builder(
      //           itemCount: futureSnapshot.data!.docs.length,
      //           itemBuilder: (context, index) {
      //             return Text(futureSnapshot.data!.docs[index].toString());
      //           },
      //         );
      //       } else {
      //         return const Text("取得に失敗しました。");  // TODO 多言語対応
      //       }
            
      //     }
      //   },
      // )
      
      
      
      
      
      body: StreamBuilder<QuerySnapshot>(
        stream: messageModel.fetchTalkroomSnapshot(mainModel: mainModel),  //createdRoomsのドキュメントが作られるとStreamBuilderが実行
        builder: (context, streamSnapshot) {
          if(streamSnapshot.hasData) {
            return FutureBuilder<List<FirestoreRoom>?>(
              future: messageModel.fetchJoindTalkrooms(querySnapshot: streamSnapshot.data!),
              builder: (context, talkRoomsFutureSnapshot) {
                if(talkRoomsFutureSnapshot.connectionState == ConnectionState.waiting) {  //ロード中
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if(talkRoomsFutureSnapshot.hasData) {
                    final talkRooms = talkRoomsFutureSnapshot.data!;
                    return FutureBuilder<List<FirestoreUser>?>(
                      future: messageModel.fetchPassiveUser(talkRooms: talkRooms, mainModel: mainModel),
                      builder: (context, passiveUserFutureSnapshot) {
                        if(passiveUserFutureSnapshot.connectionState == ConnectionState.waiting) {  //ロード中
                          return const Center(child: CircularProgressIndicator());
                        } else {
                          if(passiveUserFutureSnapshot.hasData) {
                            final List<FirestoreUser> passiveUsers = passiveUserFutureSnapshot.data!;
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: ListView.builder(  //メイン操作画面
                                itemCount: talkRooms.length,  //トークにいるユーザーの人数
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => routes.toMessagePage(context: context, mainModel: mainModel, passiveUser: passiveUsers[index]),
                                    child: SizedBox(  //リストを出力している
                                      height: 70,
                                      child: Row(  //横並び
                                        children: [
                                          Padding(  //指定箇所に余白
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),  //上下に同じ分の余白
                                            child: UserImage(userImageURL: passiveUsers[index].userImageURL, length: 48.0),
                                          ),
                                          Column(  //縦並び
                                            crossAxisAlignment: CrossAxisAlignment.start,  //左寄せ
                                            mainAxisAlignment: MainAxisAlignment.center,  //縦中央寄せ
                                            children: [
                                              Text(passiveUsers[index].userName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                              SizedBox(
                                                width: 300,
                                                child: Text(talkRooms[index].lastMessage, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              ),
                            );
                          } else {
                            return const Center(child: Text('トーク相手の取得に失敗しました'));
                          }
                        }
                      }
                    );
                  } else {
                    return const Center(child: Text('トークルームの取得に失敗しました'));
                  }
                }
              }
            );
          } else {
            return const Center(child: CircularProgressIndicator());  //ロードマーク
          }
        }
      ),
    );
  }
}