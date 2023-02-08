import 'package:flutter/material.dart';

import '../models/episode.dart';

class EpisodeCard extends StatelessWidget {
  final Episode episode;

  const EpisodeCard({Key? key, required this.episode}) : super(key: key);

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                episode.malId.toString(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: maxWidth * .6,
                    child: Text(
                      episode.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${episode.duration} min",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Aired on: ${episode.aired?.substring(0, 10)}",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Filler: ",
                        ),
                        isFillerOrRecap(episode.filler),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Recap: ",
                        ),
                        isFillerOrRecap(episode.recap),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  WidgetSpan isFillerOrRecap(bool? bool) {
    if (bool == true) {
      return const WidgetSpan(child: Icon(Icons.check, color: Colors.green));
    } else {
      return const WidgetSpan(child: Icon(Icons.close, color: Colors.red));
    }
  }
}
