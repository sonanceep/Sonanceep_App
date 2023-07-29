// flutter
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;
// components
import 'package:sonanceep_sns/details/rounded_button.dart';
import 'package:sonanceep_sns/details/user_image.dart';
import 'package:sonanceep_sns/domain/reply/reply.dart';
import 'package:sonanceep_sns/views/refresh_screen.dart';
// model
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:sonanceep_sns/models/mute_Replies_model.dart';

class MuteRepliesPage extends ConsumerWidget {
  const MuteRepliesPage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final MuteRepliesModel muteRepliesModel = ref.watch(muteRepliesProvider);
    final muteReplyDocs = muteRepliesModel.muteReplyDocs;
  
    return Scaffold(
      appBar: AppBar(
        title: const Text(muteRepliesPageTitle),
      ),
      body: muteRepliesModel.showMuteReplies ? 
      RefreshScreen(
        onRefresh: () async => await muteRepliesModel.onRefresh(mainModel: mainModel),
        onLoading: () async => await muteRepliesModel.onLoading(),
        refreshController: muteRepliesModel.refreshController,
        child: ListView.builder(
          itemCount: muteReplyDocs.length,
          itemBuilder: (BuildContext context, int index) {
            final muteReplyDoc = muteReplyDocs[index];
            final Reply muteReply = Reply.fromJson(muteReplyDoc.data()!);
            return ListTile(
              leading: UserImage(length: 60, userImageURL: muteReply.userImageURL,),
              title: Text(muteReply.reply),
              onTap: () => voids.showPopup(
                context: context,
                builder: (BuildContext innerContext) => CupertinoActionSheet(
                  actions: [
                    CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(innerContext);
                        muteRepliesModel.showUnMuteReplyDialog(context: context, mainModel: mainModel, replyDoc: muteReplyDoc);
                      },
                      child: const Text(unMuteReplyText),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () => Navigator.pop(innerContext),
                      child: const Text(backText),
                    ),
                  ]
                )
              ),
            );
          }
        ),
      )
      : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RoundedButton(
              onPressed: () async => await muteRepliesModel.getMutePostCommentReplies(mainModel: mainModel),
              widthRate: 0.85,
              color: Colors.blue,
              text: showMuteRepliesText,
            ),
          )
        ],
      ),
    );
  }
}