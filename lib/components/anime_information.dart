import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../common/user-interface-dialog.utils.dart';
import '../models/anime.dart';
import '../models/character.dart';
import '../screens/characters.dart';
import '../services/rating.dart';
import '../services/character.dart';

class AnimeInformation extends StatefulWidget {
  final Future<Anime> future;
  final int animeId;

  const AnimeInformation(
      {Key? key, required this.future, required this.animeId})
      : super(key: key);

  @override
  State<AnimeInformation> createState() => _AnimeInformationState();
}

class _AnimeInformationState extends State<AnimeInformation> {
  TextEditingController _ratingController = TextEditingController(text: "0.0");
  double _userRating = 0.0;

  @override
  void initState() {
    super.initState();
    _getUserRating(widget.animeId);
  }

  @override
  Widget build(BuildContext context) {
    return buildFutureBuilderAnime();
  }

  FutureBuilder buildFutureBuilderAnime() {
    return FutureBuilder(
      future: widget.future,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RatingBarIndicator(
                    rating: _userRating / 2,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    itemCount: 5,
                    itemSize: 50.0,
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      autocorrect: false,
                      enableSuggestions: false,
                      controller: _ratingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(),
                        hintText: 'Enter rating',
                        labelText: 'Enter rating',
                        suffixIcon: MaterialButton(
                          onPressed: () {
                            try {
                              _userRating =
                                  double.parse(_ratingController.text);
                            } catch (e) {
                              UserInterfaceDialog.displayAlertDialog(
                                  context,
                                  "Error when rating the anime",
                                  "Please enter a valid rating");
                            }
                            setState(() {});
                            _rate(widget.animeId, _userRating);
                          },
                          child: Text('Rate'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
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
                        return Center(child: Text('Sorry, couldn\'t load the anime info.'));
                      }
                      return Center(child: Text('Sorry, couldn\'t load the anime info.'));
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

  Future<List<Character>> _getAnimeCharacters(int animeId) async {
    return CharacterService.getCharacters(animeId);
  }

  void _getUserRating(int animeId) async {
    try {
      double rating = await RatingService.getUserRatingByAnimeId(animeId);
      setState(() {
        _userRating = rating;
        _ratingController = TextEditingController(text: rating.toString());
      });
    } catch (err) {
      setState(() {
        _userRating = 0;
        _ratingController = TextEditingController(text: "0.0");
      });
    }
  }

  void _rate(int animeId, double rate) async {
    try {
      if (rate >= 10) {
        UserInterfaceDialog.displayAlertDialog(context,
            "Error when rating the anime", "Please enter a rating below 10");
        return;
      }
      await RatingService.rate(animeId, rate);
      setState(() {
        _userRating = rate;
        _ratingController = TextEditingController(text: rate.toString());
      });
    } catch (err) {
      UserInterfaceDialog.displaySnackBar(
        context: context,
        message:
            "Rating failed, something went wrong. Please try again later or contact support",
        messageType: MessageType.error,
      );
    }
  }
}
