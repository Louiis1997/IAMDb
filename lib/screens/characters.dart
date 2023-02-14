import 'package:flutter/material.dart';

import '../models/character.dart';
import '../services/character.dart';

class AllCharacters extends StatelessWidget {
  final int animeId;

  const AllCharacters({Key? key, required this.animeId}) : super(key: key);

  static const String routeName = '/characters';

  static void navigateTo(BuildContext context, int id) {
    Navigator.of(context).pushNamed(routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters'),
      ),
      body: FutureBuilder(
        future: _getAnimeCharacters(animeId),
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
                return GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 0.65,
                  children: [
                    for (var character in characters)
                      Container(
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
                                  image: NetworkImage(character.imageUrl ?? ""),
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
                                character.name,
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
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
    );
  }

  Future<List<Character>> _getAnimeCharacters(int animeId) async {
    return CharacterService.getCharacters(animeId);
  }
}
