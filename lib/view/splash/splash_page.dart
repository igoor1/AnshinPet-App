import 'package:anshinpet/core/services/splash_services.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    super.initState();

    splashServices.checkAuthentication(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
                padding: EdgeInsets.all(10),
                child: Image.asset("images/logo_full.png", height: 200),
              ),
      ),
    );
  }
}