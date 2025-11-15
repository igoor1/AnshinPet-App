import 'package:anshinpet/configs/routes/routes_name.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarCustom extends StatefulWidget {
  const BottomNavigationBarCustom({super.key, this.valueIndex});
  final int? valueIndex;

  @override
  State<BottomNavigationBarCustom> createState() =>
      _BottomNavigationBarCustomState();
}

class _BottomNavigationBarCustomState extends State<BottomNavigationBarCustom> {
  int _selectedIndex = 1;
  bool a = false;

  getIndex() {
    return widget.valueIndex;
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = getIndex();
  }

  void _bottomChangeIndex(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushNamed(context, RoutesName.animal);
      } else if (_selectedIndex == 1) {
        Navigator.pushNamed(context, RoutesName.home);
      } else {
        Navigator.pushNamed(context, RoutesName.donation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.pets,
              size: (_selectedIndex == 0) ? 35 : 25,
            ),
            label: 'Animais'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: (_selectedIndex == 1) ? 35 : 25,
            ),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.volunteer_activism,
              size: (_selectedIndex == 2) ? 35 : 25,
            ),
            label: 'Doações'),
      ],
      currentIndex: _selectedIndex,
      onTap: _bottomChangeIndex,
    );
  }
}
