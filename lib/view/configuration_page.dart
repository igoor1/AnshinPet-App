import 'package:anshinpet/resources/components/appbar_custom.dart';
import 'package:flutter/material.dart';

class ConfigurationsPage extends StatelessWidget {
  const ConfigurationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Cuidadores'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Ajuda'),
            onTap: () {
            },
          ),
        ],
      ),
    );
  }
}
