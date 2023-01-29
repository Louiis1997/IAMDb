import 'package:flutter/material.dart';

import '../screens/agenda.dart';
import '../screens/anime_trailer.dart';
import '../screens/anime_detail.dart';
import '../screens/home.dart';
import '../screens/login.dart';
import '../screens/profile.dart';
import '../screens/screen_not_found.dart';
import '../screens/search.dart';
import '../screens/signup.dart';

class MyRouter {
  static Map<String, Widget Function(BuildContext context)> routes() {
    return {
      '/': (context) => const Login(),
      Login.routeName: (context) => const Login(),
      Signup.routeName: (context) => const Signup(),
      Home.routeName: (context) => const Home(),
      Search.routeName: (context) => const Search(),
    };
  }

  static MaterialPageRoute getRouter(RouteSettings settings) {
    Widget screen = const ScreenNotFound();

    switch (settings.name) {
      case Profile.routeName:
        final args = settings.arguments;
        if (args is String) {
          screen = Profile(
            userId: args,
          );
        }
        break;
      case Agenda.routeName:
        final args = settings.arguments;
        if (args is String) {
          screen = Agenda(
            userId: args,
          );
        }
        break;
      case AnimeDetail.routeName:
        final args = settings.arguments;
        if (args is int) {
          screen = AnimeDetail(
            animeId: args,
          );
        }
        break;
      case AnimeTrailer.routeName:
        final args = settings.arguments;
        if (args is String) {
          screen = AnimeTrailer(
            youtubeId: args,
          );
        }
        break;
    }

    return MaterialPageRoute(builder: (context) => screen);
  }
}
