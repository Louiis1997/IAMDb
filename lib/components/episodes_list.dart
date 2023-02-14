import 'package:flutter/material.dart';

import '../components/episode_card.dart';
import '../models/episode.dart';

class EpisodeList extends StatelessWidget {
  final Future<List<Episode>> future;

  const EpisodeList({Key? key, required this.future}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildFutureBuilderItem();
  }

  FutureBuilder buildFutureBuilderItem() {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              final episodes = snapshot.data;
              if (episodes == null || episodes.isEmpty) {
                return Center(
                  child: Text(
                    'No episode for this anime yet',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }
              return buildEpisodeListView(snapshot.data);
            }
            if (snapshot.hasError) {
              return Center(child: Text("Sorry, couldn't load episodes"));
            }
            return Center(child: Text("Sorry, couldn't load episodes"));
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  SizedBox buildEpisodeListView(data) {
    return SizedBox(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return EpisodeCard(
            episode: data[index],
          );
        },
      ),
    );
  }
}
