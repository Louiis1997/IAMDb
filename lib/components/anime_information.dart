import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';

import '../models/anime.dart';

class AnimeInformation extends StatelessWidget {
  final Future<Anime> future;

  const AnimeInformation({Key? key, required this.future}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildFutureBuilderAnime();
  }

  FutureBuilder buildFutureBuilderAnime() {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              final anime = snapshot.data;
              if (anime == null) {
                return Center(
                  child: Text(
                    'Anime not found 😵‍💫',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                );
              }
              return buildAnimeInformation(snapshot.data);
            }
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Text('${snapshot.error}');
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  LayoutBuilder buildAnimeInformation(data) {
    return LayoutBuilder(
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
                      image: NetworkImage(data.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Text("SYNOPSIS", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                child: ExpandableText(
                  data.synopsis + "\n",
                  expandText: '\nRead more',
                  collapseText: '\nShow less',
                  maxLines: 3,
                  linkColor: Colors.blue,
                  collapseOnTextTap: true,
                  expandOnTextTap: true,
                ),
              ),
              SizedBox(height: 10),
              Background(data.background),
              Text("INFORMATION",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                child: ExpandableText(
                  "Type: ${data.type}\n" +
                      "Episodes: ${data.episodes}\n" +
                      "Status: ${data.status}\n" +
                      //"Aired: ${data.aired?.from}\n"
                      "Season: ${data.season}\n" +
                      "Producers: ${data.producersName.join(", ")}\n" +
                      "Licensors: ${data.licensorsName.join(", ")}\n" +
                      "Studios: ${data.studiosName.join(", ")}\n" +
                      "Genres: ${data.genresName.join(", ")}\n",
                  expandText: '\nMore information',
                  collapseText: '\nShow less',
                  maxLines: 3,
                  linkColor: Colors.blue,
                  collapseOnTextTap: true,
                  expandOnTextTap: true,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("CHARACTERS",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/anime/characters',
                          arguments: data.characters);
                    },
                    child: Text(
                      "Show more",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 200),
            ],
          ),
        );
      },
    );
  }

  Background(String background) {
    if (background != "") {
      return Column(
        children: [
          Text("BACKGROUND", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(
            child: ExpandableText(
              background,
              expandText: '\nRead more',
              collapseText: '\nShow less',
              maxLines: 3,
              linkColor: Colors.blue,
              collapseOnTextTap: true,
              expandOnTextTap: true,
            ),
          ),
          SizedBox(height: 10),
        ],
      );
    }
    return Container();
  }
}
