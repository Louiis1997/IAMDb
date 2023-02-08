import 'package:flutter/material.dart';

import '../models/anime.dart';

class AnimeCard extends StatefulWidget {
  final Anime anime;
  final Function() onTap;

  const AnimeCard({Key? key, required this.anime, required this.onTap})
      : super(key: key);

  @override
  State<AnimeCard> createState() => _AnimeCardState();
}

class _AnimeCardState extends State<AnimeCard> {
  bool state = false;

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
            onTap: () => widget.onTap(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(45)),
                  child: Image.network(
                    widget.anime.imageUrl ?? "",
                    width: maxWidth * .2,
                    height: MediaQuery.of(context).size.height * .1,
                    fit: BoxFit.cover,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 20)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: maxWidth * .58,
                      child: Text(
                        widget.anime.titleEnglish ?? widget.anime.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${widget.anime.episodes} episodes",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Container(
                              height: 250,
                              color: Colors.amber,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CheckboxListTile(
                                    title: const Text("Envie de voir"),
                                    value: state,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        state = value ?? state;
                                      });
                                    },
                                    activeColor: Colors.orange,
                                    checkboxShape: const CircleBorder(),
                                    secondary: const Icon(
                                      Icons.access_time_outlined,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  CheckboxListTile(
                                    title: const Text("En pause"),
                                    value: state,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        state = value ?? state;
                                      });
                                    },
                                    activeColor: Colors.orange,
                                    checkboxShape: const CircleBorder(),
                                    secondary: const Icon(
                                      Icons.pause_circle_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                  CheckboxListTile(
                                    title: const Text("En cours"),
                                    value: state,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        state = value ?? state;
                                      });
                                    },
                                    activeColor: Colors.orange,
                                    checkboxShape: const CircleBorder(),
                                    secondary: const Icon(
                                      Icons.play_circle_outline,
                                      color: Colors.green,
                                    ),
                                  ),
                                  CheckboxListTile(
                                    title: const Text("Terminés"),
                                    value: state,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        state = value ?? state;
                                      });
                                    },
                                    activeColor: Colors.orange,
                                    checkboxShape: const CircleBorder(),
                                    secondary: const Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
