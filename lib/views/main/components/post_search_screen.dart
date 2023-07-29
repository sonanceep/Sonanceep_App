// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/details/user_image.dart';
import 'package:sonanceep_sns/domain/post/post.dart';
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:sonanceep_sns/models/post_search_model.dart';
import 'package:sonanceep_sns/views/main/components/search_screen.dart';

class PostSearchScreen extends ConsumerWidget {
  const PostSearchScreen({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final PostSearchModel postSearchModel = ref.watch(postSearchProvider);
    final postMaps = postSearchModel.postMaps;

    return SearchScreen(
      onQueryChanged: (text) async {
        postSearchModel.searchTerm = text;
        await postSearchModel.operation(muteUids: mainModel.muteUids, mutePostIds: mainModel.mutePostIds);
      },
      child: ListView.builder(  // DocumentSnapShotを使用するときはListView.builder()を使用した方が後々良い
        itemCount: postMaps.length,
        itemBuilder: (
          (context, index) {
            // usersの配列から１個１個取得している
            final post = Post.fromJson(postMaps[index]);

            return ListTile(
              leading: UserImage(length: 32.0, userImageURL: post.userImageURL),
              title: Text(post.userName),
              subtitle: Text(post.text),
            );
          } 
        ),
      ),
    );
  }
}