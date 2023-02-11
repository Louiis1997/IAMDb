import 'package:flutter/material.dart';

import '../main.dart';
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
    return buildSmallImageGrid();
  }

  Container buildSmallImageGrid() {
    return Container(
      color: Colors.black,
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
                  color: Colors.grey,
                  child: Stack(
                    //center on x axis and y axis
                    children: [
                      Image.network(
                        imageSnapshot.data!.imageUrl,
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          textAlign: TextAlign.center,
                          "Voir plus\n" + "(+${snapshot.data.length - 6})",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey,
                  ),
                  child: Image.network(
                    imageSnapshot.data!.imageUrl,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.fill,
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
    final token = await storage.read(key: "token");
    final anime = await AnimeService.getAnimeById(token!, id);
    return anime;
  }
}
