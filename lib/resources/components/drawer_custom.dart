import 'package:anshinpet/configs/routes/routes_name.dart';
import 'package:anshinpet/view/disease/disease_page.dart';
import 'package:anshinpet/view/vaccine/vaccine_page.dart';
import 'package:anshinpet/viewmodels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerCustom extends StatelessWidget {
  const DrawerCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, 
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
                    fontSize: 20.0),
              ),
            ),
          ),
          
          ListTileElement(Icons.assignment, 'Doenças', 
            onTap: () {
              Navigator.of(context).pop(); 
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DiseasePage()));
          }),
          ListTileElement(Icons.healing, 'Vacinas', 
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const VaccinePage()));
          }),
          ListTileElement(Icons.medical_services, 'Medicação',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, RoutesName.medication);
          }),
          ListTileElement(Icons.category, 'Tipos de Animais',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, RoutesName.animalType);
          }),
          ListTileElement(Icons.check_circle, 'Status de Animais',
            onTap: () {
              Navigator.of(context).pop(); 
              Navigator.pushNamed(context, RoutesName.animalStatus);
          }),
          ListTileElement(Icons.settings, 'Configurações',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, RoutesName.settings);
          }),
          Divider(),
          ListTileElement(
            Icons.logout,
            'Sair', 
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<AuthViewModel>(context, listen: false).logout(context);
            }
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
      leading: Icon(icon),
      title: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    ),
  );
}
