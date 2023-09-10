// flutter
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// packages
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonanceep_sns/constants/colors.dart';
import 'package:sonanceep_sns/constants/routes.dart' as routes;
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/domain/firestore_artist/firestore_artist.dart';
import 'package:sonanceep_sns/models/artists/artist_search_model.dart';
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:sonanceep_sns/models/songs/song_search_model.dart';
import 'package:sonanceep_sns/views/artists/artist_card.dart';
import 'package:sonanceep_sns/views/main/components/search_screen.dart';
import 'package:sonanceep_sns/views/songs/song_card.dart';

class CreateScreen extends HookConsumerWidget {
  const CreateScreen({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final ArtistSearchModel artistSearchModel = ref.watch(artistSearchProvider);
    final SongSearchModel songSearchModel = ref.watch(songSearchProvider);

    final artistDocs = artistSearchModel.artistDocs;
    final songDocs = songSearchModel.songDocs;

    final RefreshController refreshController = RefreshController();

    useEffect(() {
      return refreshController.dispose;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text(createText)),
      body: SearchScreen(
        onQueryChanged: (text) async {
          songSearchModel.searchTerm = text;
          await songSearchModel.operation(muteUids: mainModel.muteUids, mutePostIds: mainModel.mutePostIds);
          artistSearchModel.searchTerm = text;
          await artistSearchModel.operation(muteUids: mainModel.muteUids, mutePostIds: mainModel.mutePostIds);
        },
        child: ListView.builder(  // DocumentSnapShotを使用するときはListView.builder()を使用した方が後々良い
          itemCount: artistDocs.length + songDocs.length,
          itemBuilder: (context, index) {
            // songsの配列から１個１個取得している
            if(index < artistDocs.length) {
              final artistDoc = artistDocs[index];
              final FirestoreArtist firestoreArtist = FirestoreArtist.fromJson(artistDoc.data()!);
              return Column(
                children: [
                  ArtistCard(firestoreArtist: firestoreArtist),
                  const Divider(
                    color: dividerColor,
                    thickness: 1.0,
                  ),
                ],
              );
            } else {
              final adjustedIndex = index - artistDocs.length; // インデックスを調整
              final songDoc = songDocs[adjustedIndex];
              return Column(
                children: [
                  SongCard(mainModel: mainModel, songDoc: songDoc),
                  const Divider(
                    color: dividerColor,
                    thickness: 1.0,
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.new_label,),
        onPressed: () => routes.toCreatePostPage(mainModel: mainModel, context: context),
      ),
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Center(
      //       child: RoundedButton(
      //         onPressed: () => routes.toCreatePostPage(mainModel: mainModel, context: context),
      //         widthRate: 0.85,
      //         color: Colors.green,
      //         text: createPostText,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}