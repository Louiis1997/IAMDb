import 'package:flutter/material.dart';
import 'package:iamdb/screens/events/event-creation.dart';
import 'package:iamdb/screens/events/event-details.dart';
import 'package:iamdb/screens/manga_detail.dart';

import '../screens/splash.dart';
import '../screens/agenda.dart';
import '../screens/anime_trailer.dart';
import '../screens/anime_detail.dart';
import '../screens/home.dart';
import '../screens/login.dart';
import '../screens/profile.dart';
import '../screens/screen_not_found.dart';
import '../screens/search.dart';
import '../screens/signup.dart';
import '../screens/events/events.dart';
import '../models/event.dart';

class MyRouter {
  static Map<String, Widget Function(BuildContext context)> routes() {
    return {
      '/': (context) => const SplashScreen(),
      Login.routeName: (context) => const Login(),
      Signup.routeName: (context) => const Signup(),
      Home.routeName: (context) => const Home(),
      Search.routeName: (context) => const Search(),
      Agenda.routeName: (context) => const Agenda(),
      Profile.routeName: (context) => const Profile(),
      Events.routeName: (context) => const Events(),
      EventCreation.routeName: (context) => const EventCreation(),
    };
  }

  static MaterialPageRoute getRouter(RouteSettings settings) {
    Widget screen = const ScreenNotFound();

    switch (settings.name) {
      case AnimeDetail.routeName:
        final args = settings.arguments;
        if (args is int) {
          screen = AnimeDetail(
            animeId: args,
          );
        }
        break;
      case MangaDetail.routeName:
        final args = settings.arguments;
        if (args is int) {
          screen = MangaDetail(
            mangaId: args,
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
      case EventDetails.routeName:
        print('EventDetails.routeName: ${settings.arguments}');
        final args = settings.arguments;
        if (args is Event) {
          screen = EventDetails(
            event: args,
          );
        }
        break;
    }

    return MaterialPageRoute(builder: (context) => screen);
  }
}
