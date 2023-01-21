import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AnimeTrailer extends StatelessWidget {
  final String youtubeId;
  const AnimeTrailer({Key? key, required this.youtubeId}) : super(key: key);

  static const String routeName = '/anime_trailer';

  static void navigateTo(BuildContext context, String id) {
    Navigator.of(context).pushNamed(routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: youtubeId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Trailer'),
          ),
          body: player,
        );
      },
    );
  }
}
