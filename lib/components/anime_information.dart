import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:iamdb/models/character.dart';

import '../main.dart';
import '../models/anime.dart';
import '../screens/anime_detail.dart';
import '../screens/characters.dart';
import '../services/character.dart';

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
              SizedBox(height: 10),
              //VOTE widget
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
                          data.score.toString() + "/10",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "for " + data.scoredBy.toString() + " votes",
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
                        Text("#" + data.rank.toString(),
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
                  data.synopsis + "\n",
                  expandText: '\nRead more',
                  collapseText: '\nShow less',
                  maxLines: 3,
                  linkColor: Colors.blue,
                  collapseOnTextTap: true,
                  expandOnTextTap: true,
                ),
              ),
              SizedBox(height: 20),
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("CHARACTERS",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      AllCharacters.navigateTo(context, data.malId);
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
              SizedBox(height: 10),
              FutureBuilder(
                future: _getAnimeCharacters(data.malId),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        final characters = snapshot.data;
                        if (characters == null || characters.isEmpty) {
                          return Center(
                            child: Text(
                              'No Characters found',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          );
                        }
                        return SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: characters.length >= 15
                                ? 15
                                : characters.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              characters[index].imageUrl ?? ""),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        characters[index].name,
                                        style: Theme.of(context).textTheme.bodyText1,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return Text('${snapshot.error}');
                    default:
                      return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              SizedBox(height: 150),
            ],
          ),
        );
      },
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
              background,
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

  Future<List<Character>> _getAnimeCharacters(int animeId) async {
    final token = await storage.read(key: "token");
    return CharacterService.getCharacters(token!, animeId);
  }
}
