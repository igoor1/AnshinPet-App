import 'package:anshinpet/view/animals/animal_status_page.dart';
import 'package:anshinpet/view/animals/animal_type_page.dart';
import 'package:anshinpet/view/login_page.dart';
import 'package:anshinpet/view/animal_page.dart';
import 'package:anshinpet/view/splash/splash_page.dart';

import 'package:anshinpet/configs/routes/routes_name.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => SplashPage());
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginPage());
      case RoutesName.animal:
        return MaterialPageRoute(
            builder: (BuildContext context) => AnimalPage());
      case RoutesName.animalType:
        return MaterialPageRoute(
            builder: (BuildContext context) => AnimalTypePage());
      case RoutesName.animalStatus:
        return MaterialPageRoute(
            builder: (BuildContext context) => AnimalStatusPage());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
