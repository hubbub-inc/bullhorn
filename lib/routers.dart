import 'package:flutter/material.dart';
import 'package:blips/screens/home_screen.dart';
import 'package:blips/screens/landing_screen.dart';
import 'package:blips/screens/auth_screen.dart';


class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case 'landing':
        return MaterialPageRoute(builder: (_) => LandingScreen());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}