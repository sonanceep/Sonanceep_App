// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/details/user_image.dart';
import 'package:sonanceep_sns/domain/quita_user/quita_user.dart';
import 'package:sonanceep_sns/models/main/articles_model.dart';

class ArticlesScreen extends ConsumerWidget {
  const ArticlesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ArticlesModel articlesModel = ref.watch(articlesProvider);
    final articles = articlesModel.articles;
    return const Scaffold(
      // body: Container(
      //   alignment: Alignment.center,
      //   child: ListView.builder(
      //     itemCount: articles.length,
      //     itemBuilder: (context, index) {
      //       final article = articles[index];
      //       final QuitaUser quitaUser = QuitaUser.fromJson(article.user);
      //       return ListTile(
      //         leading: UserImage(length: 64.0, userImageURL: quitaUser.profile_image_url),
      //         title: Text(quitaUser.name),
      //         subtitle: Text(article.title),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}