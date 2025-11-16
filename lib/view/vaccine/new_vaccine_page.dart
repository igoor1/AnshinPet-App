import 'package:anshinpet/model/vaccine_model.dart';
import 'package:anshinpet/viewmodels/vaccine_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewVaccinePage extends StatefulWidget {
  const NewVaccinePage({super.key});

  @override
  State<NewVaccinePage> createState() => _VaccineAddPageState();
}

class _VaccineAddPageState extends State<NewVaccinePage> {
  final nameController = TextEditingController();
  final manufacturerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<VaccineViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Nova Vacina")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: manufacturerController,
              decoration: const InputDecoration(labelText: "Fabricante"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final vaccine = Vaccine(
                  id: 0,
                  name: nameController.text,
                  manufacturer: manufacturerController.text,
                );

                bool ok = await vm.addVaccine(vaccine);

                if (ok) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
