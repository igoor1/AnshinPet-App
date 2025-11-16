import 'package:anshinpet/model/medication_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anshinpet/viewmodels/medication_view_model.dart';
import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/resources/components/appbar_custom.dart';

class NewMedicationPage extends StatefulWidget {
  const NewMedicationPage({super.key});

  @override
  State<NewMedicationPage> createState() => _NewMedicationPageState();
}

class _NewMedicationPageState extends State<NewMedicationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _saveMedication() async {
    if (_formKey.currentState!.validate()) {
      final med = MedicationModel(
        name: _nameController.text,
        manufacturer: _manufacturerController.text,
        batch: _batchController.text,
      );

      bool ok = await Provider.of<MedicationViewModel>(context, listen: false)
          .addMedication(med);

      if (ok) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarCustom(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Cadastrar Novo Medicamento",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nome"),
                validator: (v) => (v == null || v.isEmpty) ? "Insira o nome" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _manufacturerController,
                decoration: const InputDecoration(labelText: "Fabricante"),
                validator: (v) => (v == null || v.isEmpty) ? "Insira o fabricante" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _batchController,
                decoration: const InputDecoration(labelText: "Lote"),
                validator: (v) => (v == null || v.isEmpty) ? "Insira o lote" : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _saveMedication,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Salvar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
