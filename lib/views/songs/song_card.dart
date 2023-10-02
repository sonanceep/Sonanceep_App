// flutter
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/routes.dart' as routes;
import 'package:sonanceep_sns/details/song_image.dart';
import 'package:sonanceep_sns/details/card_container.dart';
import 'package:sonanceep_sns/domain/firestore_song/firestore_song.dart';
import 'package:sonanceep_sns/models/main_model.dart';

class SongCard extends ConsumerWidget {
  const SongCard({
    Key? key,
    required this.mainModel,
    required this.songDoc,
  }) : super(key: key);

  final MainModel mainModel;
  final DocumentSnapshot<Map<String, dynamic>> songDoc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final FirestoreSong firestoreSong = FirestoreSong.fromJson(songDoc.data()!);
    final List<String> songImageURL = firestoreSong.songImageURL;
    const int min = 0;
    final int max = songImageURL.length - 1;
    final int imageValue = Random().nextInt(max - min + 1) + min;

    return SizedBox(
      height: 100,
      child: InkWell(
        onTap: () => routes.toSongProfilePage(context: context, mainModel: mainModel, songDoc: songDoc, imageValue: imageValue),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SongImage(
                length: 80.0,
                songImageURL: firestoreSong.songImageURL[imageValue],
              ),
            ),
            Text(firestoreSong.songName),
            const Expanded(child: SizedBox()),
            const Padding(
              padding: EdgeInsets.only(right: 24.0),
              child: SizedBox(
                height: 80,
                width: 100,
                child: CardContainer(
                  onTap: null,
                  borderColor: Colors.green,
                  child: Center(child: Text('選択')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}