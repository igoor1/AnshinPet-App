import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/res/components/appbar_custom.dart';
import 'package:anshinpet/view_model/vaccine_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewVaccinePage extends StatefulWidget {
  const NewVaccinePage({super.key});

  @override
  State<NewVaccinePage> createState() => _NewVaccinePageState();
}

class _NewVaccinePageState extends State<NewVaccinePage> {
   final TextEditingController _nameController = TextEditingController();
  final TextEditingController _producerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _producerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome da Vacina',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _producerController,
                decoration: InputDecoration(
                  labelText: 'fabricante da vacina',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o Fabricante';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30.0),
              ElevatedButton.icon(
                label: const Text('Cadastrar Vacina'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  foregroundColor: Colors.white,
                ),
                onPressed: _createVaccine,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
   void _createVaccine() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'nome': _nameController.text,
        'gravidade': _producerController.text,
      };

      Provider.of<VaccineViewModel>(context, listen: false)
          .createVaccine(data);

      Navigator.pop(context);
    }
  }
}