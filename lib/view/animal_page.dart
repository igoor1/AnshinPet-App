import 'package:anshinpet/res/components/appbar_custom.dart';
import 'package:anshinpet/res/components/bottom_navigation_bar_custom.dart';
import 'package:anshinpet/res/components/drawer_custom.dart';
import 'package:flutter/material.dart';

class AnimalPage extends StatefulWidget {
  const AnimalPage({super.key});

  @override
  State<AnimalPage> createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(),
      drawer: DrawerCustom(),
      body: Container(
        child: Text('Teste'),
      ),
      bottomNavigationBar: BottomNavigationBarCustom(
        valueIndex: 0,
      ),
    );
  }
}
