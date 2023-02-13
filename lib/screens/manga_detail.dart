import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

import '../models/top_manga.dart';

class MangaDetail extends StatelessWidget {
  final TopManga manga;

  const MangaDetail({Key? key, required this.manga}) : super(key: key);

  static const String routeName = '/manga_detail';

  static void navigateTo(BuildContext context, TopManga manga) {
    Navigator.of(context).pushNamed(routeName, arguments: manga);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/iamdb-logo.png',
          fit: BoxFit.contain,
          height: 64,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;
          return Container(
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: [
                Center(
                  child: Container(
                    width: maxWidth * .8,
                    height: maxHeight * .5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(manga.imageUrl ?? ""),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    manga.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            manga.score.toString() + "/10",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "for " + manga.scoredBy.toString() + " votes",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text("#" + manga.rank.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(height: 5),
                          Text(
                            "Rank",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text("SYNOPSIS", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Container(
                  child: ExpandableText(
                    manga.synopsis! + "\n",
                    expandText: '\nRead more',
                    collapseText: '\nShow less',
                    maxLines: 3,
                    linkColor: Colors.blue,
                    collapseOnTextTap: true,
                    expandOnTextTap: true,
                  ),
                ),
                SizedBox(height: 20),
                Background(manga.background!),
                Text("INFORMATION",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Container(
                  child: ExpandableText(
                    "Type: ${manga.type}\n" +
                        "Chapters: ${manga.chapters}\n" +
                        "Volumes: ${manga.volumes}\n" +
                        "Status: ${manga.status}\n" +
                        "Aired: ${manga.publishedString}\n"
                        "Authors: ${manga.authorsName.join(", ")}\n" +
                        "Serializations: ${manga.serializationsName.join(", ")}\n" +
                        "Genres: ${manga.genresName.join(", ")}\n",
                    expandText: '\nMore information',
                    collapseText: '\nShow less',
                    maxLines: 3,
                    linkColor: Colors.blue,
                    collapseOnTextTap: true,
                    expandOnTextTap: true,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Background(String background) {
    if (background != "") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("BACKGROUND", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(
            child: ExpandableText(
              background + "\n",
              expandText: '\nRead more',
              collapseText: '\nShow less',
              maxLines: 3,
              linkColor: Colors.blue,
              collapseOnTextTap: true,
              expandOnTextTap: true,
            ),
          ),
          SizedBox(height: 20),
        ],
      );
    }
    return Container();
  }
}
