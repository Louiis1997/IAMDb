import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class AnimeTrailer extends StatelessWidget {
  final String youtubeId;

  const AnimeTrailer({Key? key, required this.youtubeId}) : super(key: key);

  static const String routeName = '/anime_trailer';

  static void navigateTo(BuildContext context, String id) {
    Navigator.of(context).pushNamed(routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: YoutubePlayerController.fromVideoId(
        videoId: youtubeId,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showFullscreenButton: true,
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Trailer'),
          ),
          body: Center(child: player),
        );
      },
    );
  }
}
