import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: "images/iamdb-logo.png",
      splashIconSize: MediaQuery.of(context).size.width * .5,
      nextScreen: const Login(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      backgroundColor: (Theme.of(context).brightness == Brightness.dark)
          ? Colors.black
          : Colors.white,
    );
  }
}
