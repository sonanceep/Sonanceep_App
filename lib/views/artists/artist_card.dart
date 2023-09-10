// flutter
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/details/user_image.dart';
import 'package:sonanceep_sns/domain/firestore_artist/firestore_artist.dart';

class ArtistCard extends ConsumerWidget {
  const ArtistCard({
    Key? key,
    required this.firestoreArtist,
  }) : super(key: key);

  final FirestoreArtist firestoreArtist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 100,
      child: InkWell(
        onTap: () {},
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
            const Expanded(child: SizedBox()),
            const Padding(
              padding: EdgeInsets.only(right: 24.0),
              child: Icon(Icons.chevron_right, color: Colors.blueGrey,),
            ),
          ],
        ),
      ),
    );
  }
}