import 'package:flutter/material.dart';

import '../screens/anime_detail.dart';
import '../screens/anime_grid.dart';
import '../services/anime.dart';

// Classe qui affiche la grille d'images
class SmallImageGrid extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final int itemCount;
  final String status;


  const SmallImageGrid(
      {Key? key, required this.snapshot, required this.itemCount, required this.status})
      : super(key: key);

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
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                return buildAgendaListProfilView(
                  snapshot,
                  index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder buildAgendaListProfilView(snapshot, int index) {
    return FutureBuilder(
      future: _getAnime(snapshot.data[index].animeId, index),
      builder: (context, imageSnapshot) {
        // Vérifie si la future a renvoyé une donnée valide
        if (imageSnapshot.hasData) {
          if (index == 5) {
            return Padding(
              // Padding de 5 pixels autour de chaque image
              padding: EdgeInsets.all(5),
              child: InkWell(
                // Comportement de clic sur l'image
                onTap: () => {
                  // Code à exécuter lors du clic sur l'image
                  AnimeGrid.navigateTo(context, status)
                },
                child: Container(
                  height: 45,
                  width: 30,
                  child: Stack(
                    //center on x axis and y axis
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageSnapshot.data!.imageUrl,
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          width: double.infinity,
                          height: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            textAlign: TextAlign.center,
                            "Voir plus\n" + "(+${snapshot.data.length - 5})",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Padding(
              // Padding de 5 pixels autour de chaque image
              padding: EdgeInsets.all(5),
              child: InkWell(
                // Comportement de clic sur l'image
                onTap: () => {
                  // Code à exécuter lors du clic sur l'image
                  AnimeDetail.navigateTo(context, imageSnapshot.data.malId)
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
          }
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
