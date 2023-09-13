// flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// packages
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonanceep_sns/constants/colors.dart';
import 'package:sonanceep_sns/constants/routes.dart' as routes;
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/details/user_image.dart';
import 'package:sonanceep_sns/domain/firestore_artist/firestore_artist.dart';
import 'package:sonanceep_sns/models/artists/artist_search_model.dart';
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:sonanceep_sns/views/main/components/search_screen.dart';

class ArtistSearchPage extends HookConsumerWidget {
  const ArtistSearchPage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final ArtistSearchModel artistSearchModel = ref.watch(artistSearchProvider);

    final artistDocs = artistSearchModel.artistDocs;

    final RefreshController refreshController = RefreshController();

    useEffect(() {
      return refreshController.dispose;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text(artistSearchTitle)),
      body: SearchScreen(
        onQueryChanged: (text) async {
          artistSearchModel.searchTerm = text;
          await artistSearchModel.operation(muteUids: mainModel.muteUids, mutePostIds: mainModel.mutePostIds);
        },
        child: ListView.builder(  // DocumentSnapShotを使用するときはListView.builder()を使用した方が後々良い
          itemCount: artistDocs.length,
          itemBuilder: (
            (context, index) {
              // artistsの配列から１個１個取得している
              final artistDoc = artistDocs[index];
              final FirestoreArtist firestoreArtist = FirestoreArtist.fromJson(artistDoc.data()!);
              return Column(
                children: [
                  InkWell(
                    onTap: () => voids.showPopup(  //自分の投稿に対して行うポップアップ
                      context: context,
                      builder: (BuildContext innerContext) => CupertinoActionSheet(
                        actions: [
                          //アーティストを編集
                          CupertinoActionSheetAction(
                            isDestructiveAction: true,
                            onPressed: () {
                              Navigator.pop(innerContext);
                              // deletePostModel.deletePostDialog(context: context);
                            },
                            child: const Text(adminEditArtistProfileTitle),
                          ),
                          //アルバムを登録
                          CupertinoActionSheetAction(
                            isDestructiveAction: true,
                            onPressed: () {
                              Navigator.pop(innerContext);
                              routes.toAlbumRegistrationPage(context: context, artistDoc: artistDoc);
                            },
                            child: const Text(adminAlbumRegistrationTitle),
                          ),
                          //音源を登録
                          CupertinoActionSheetAction(
                            isDestructiveAction: true,
                            onPressed: () {
                              Navigator.pop(innerContext);
                              artistSearchModel.getAlbumList(context: context, firestoreArtist: firestoreArtist, artistDoc: artistDoc);
                            },
                            child: const Text(adminSongRegistrationTitle),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () => Navigator.pop(innerContext),
                            child: const Text(backText),
                          ),
                        ],
                      ),
                    ),
                    child: SizedBox(
                      height: 130,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: UserImage(
                              length: 80.0,
                              userImageURL: firestoreArtist.artistImageURL,
                            ),
                          ),
                          Text(firestoreArtist.artistName),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: dividerColor,
                    thickness: 1.0,
                  ),
                ],
              );
            } 
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.new_label,),
        onPressed: () => routes.toCreatePostPage(mainModel: mainModel, context: context),
      ),
    );
  }
}