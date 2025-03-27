import 'package:anshinpet/view/home_page.dart';
import 'package:anshinpet/view/login_page.dart';
import 'package:anshinpet/configs/routes/routes_name.dart';
import 'package:flutter/material.dart';

class Routes {

  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch(settings.name){
      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context) => LoginPage());
      
      case RoutesName.home:
        return MaterialPageRoute(builder: (BuildContext context) => HomePage());
      default:
      return MaterialPageRoute(builder: (_){
        return Scaffold(
          body: Center(
            child: Text('No route defined'),
          ),
        );
      });
    }
  }
}