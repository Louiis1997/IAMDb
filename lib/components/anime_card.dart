import 'package:flutter/material.dart';

import '../models/anime.dart';

class AnimeCard extends StatelessWidget {
  final Anime anime;
  final Function() onTap;

  const AnimeCard({Key? key, required this.anime, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, constraints) {
        final maxWidth = constraints.maxWidth;
        return Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(45),
            border: Border.all(color: Colors.grey),
          ),
          child: GestureDetector(
            onTap: () => onTap(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(45)),
                  child: Image.network(
                    anime.imageUrl ?? "",
                    width: maxWidth * .2,
                    height: MediaQuery.of(context).size.height * .1,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: maxWidth * .6,
                        child: Text(
                          anime.titleEnglish ?? anime.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${anime.episodes} episodes",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
