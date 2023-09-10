// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// packages
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sonanceep_sns/constants/colors.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/details/song_header.dart';
// components
import 'package:sonanceep_sns/domain/firestore_song/firestore_song.dart';
import 'package:sonanceep_sns/models/songs/song_profile_model.dart';
// models
import 'package:sonanceep_sns/models/main_model.dart';

class SongProfilePage extends HookConsumerWidget {
  const SongProfilePage({
    Key? key,
    required this.mainModel,
    required this.songDoc,
    required this.imageValue,
  }) : super(key: key);

  final MainModel mainModel;
  final DocumentSnapshot<Map<String,dynamic>> songDoc;
  final int imageValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // final RefreshController refreshController = RefreshController();
    final SongProfileModel songProfileModel = ref.watch(songProfileProvider);
    final FirestoreSong firestoreSong = FirestoreSong.fromJson(songDoc.data()!);
    // final postDocs = songProfileModel.postDocs;

    // useEffect(() {
    //   return refreshController.dispose;
    // }, []);
 
    return Scaffold(
      appBar: AppBar(
        title: const Text(createText),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: SongHeader(mainModel: mainModel, firestoreSong: firestoreSong, imageValue: imageValue, onTap: () {}),
            ),
            const Divider(
              color: dividerColor,
              thickness: 4.0,
            ),
            //PassiveUserProfilePageを参照する
          ],
        ),
      )
    );
  }
}