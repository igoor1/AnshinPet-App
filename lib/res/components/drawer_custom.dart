import 'package:flutter/material.dart';

class DrawerCustom extends StatelessWidget {
  const DrawerCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'AnshinPet',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
            decoration: BoxDecoration(color: Color.fromRGBO(124, 84, 217, 0.3)),
          ),
          ListTileElement(Icons.medication_liquid, 'Cuidados Médicos'),
          ListTileElement(Icons.group, 'Cuidadores'),
          ListTileElement(Icons.settings, 'Configurações'),
          Divider(),
          ListTileElement(Icons.question_mark, 'Ajuda'),
          ListTileElement(Icons.logout, 'Sair'),
        ],
      ),
    );
  }
}

Widget ListTileElement(icon, text) {
  return Padding(
    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
    child: ListTile(
      leading: Icon(
        icon,
        color: Color.fromRGBO(124, 84, 217, 1),
      ),
      title: Text(
        text,
        style: TextStyle(
            color: Color.fromRGBO(124, 84, 217, 1),
            fontWeight: FontWeight.bold),
      ),
      onTap: () {},
    ),
  );
}
