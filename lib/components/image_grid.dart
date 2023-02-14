import 'package:flutter/material.dart';

import '../screens/anime_detail.dart';
import '../services/anime.dart';

// Classe qui affiche la grille d'images
class ImageGrid extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;

  const ImageGrid({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildSmallImageGrid(context);
  }

  Container buildSmallImageGrid(context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: GridView.builder(
              // Nombre de colonnes de la grille
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 5,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return buildAgendaListProfilView(
                  snapshot.data,
                  index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder buildAgendaListProfilView(data, int index) {
    return FutureBuilder(
      future: _getAnime(data[index].animeId, index),
      builder: (context, imageSnapshot) {
        // Vérifie si la future a renvoyé une donnée valide
        if (imageSnapshot.hasData) {
          return Padding(
            // Padding de 5 pixels autour de chaque image
            padding: EdgeInsets.all(5),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                // Comportement de clic sur l'image
                onTap: () => {
                  // Code à exécuter lors du clic sur l'image
                  AnimeDetail.navigateTo(context, imageSnapshot.data.malId)
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageSnapshot.data!.imageUrl,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          );
        } else {
          // Affiche un spinner lorsque la future n'a pas encore renvoyé de données
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 12),
            child: CircularProgressIndicator(
              strokeWidth: 8,
            ),
          );
        }
      },
    );
  }

  Future<dynamic> _getAnime(int id, int index) async {
    await Future.delayed(Duration(seconds: (index / 2).round()));
    final anime = await AnimeService.getAnimeById(id);
    return anime;
  }
}
