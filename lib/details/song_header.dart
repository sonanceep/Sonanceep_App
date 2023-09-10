// flutter
import 'package:flutter/material.dart';
import 'package:sonanceep_sns/details/song_button.dart';
import 'package:sonanceep_sns/details/song_image.dart';
// components
import 'package:sonanceep_sns/constants/routes.dart' as routes;
import 'package:sonanceep_sns/domain/firestore_song/firestore_song.dart';
import 'package:sonanceep_sns/models/main_model.dart';

class SongHeader extends StatelessWidget {
  const SongHeader({
    Key? key,
    required this.mainModel,
    required this.firestoreSong,
    required this.imageValue,
    required this.onTap,
  }) : super(key: key);

  final MainModel mainModel;
  final FirestoreSong firestoreSong;
  final int imageValue;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 56.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SongImage(songImageURL: firestoreSong.songImageURL[imageValue], length: 64.0),
                ),
                Text(firestoreSong.songName, style: const TextStyle(fontSize: 40.0),),
              ],
            ),
          ),
          SongButton(mainModel: mainModel),
        ]
      ),
    );
  }
}