import 'package:flutter/material.dart';
import 'package:anshinpet/res/components/drawer_custom.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: DrawerCustom(),
      body: Text("Home Page"),
    );
  }
}
