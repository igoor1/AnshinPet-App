import 'package:anshinpet/configs/routes/routes_name.dart';
import 'package:anshinpet/view/disease_page.dart';
import 'package:anshinpet/view/vaccine_page.dart';
import 'package:anshinpet/view_model/token_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerCustom extends StatelessWidget {
  const DrawerCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color.fromRGBO(124, 84, 217, 0.3)),
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'AnshinPet',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
                ),
              ),
            ),  
          ),
          ListTileElement(
            Icons.assignment, 
            'Doenças',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DiseasePage()))
            ),
            ListTileElement(
            Icons.healing, 
            'Vacinas',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VaccinePage()))
            ),
          ListTileElement(Icons.group, 'Cuidadores'),
          ListTileElement(Icons.settings, 'Configurações'),
          Divider(),
          ListTileElement(Icons.question_mark, 'Ajuda'),
          ListTileElement(
            Icons.logout, 
            'Sair', onTap: 
            () => _logout(context)
          ),
        ],
      ),
    );
  }
}

Widget ListTileElement(IconData icon, String text, {VoidCallback? onTap}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
    child: ListTile(
      leading: Icon(
        icon
      ),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    ),
  );
}


void _logout(BuildContext context) async {
  final token = Provider.of<TokenViewModel>(context, listen: false);
  await token.remove();
  if (!context.mounted) return;

  Navigator.of(context).pop();
  Navigator.pushNamedAndRemoveUntil(
    context, 
    RoutesName.login, 
    (route) => false
  );
}