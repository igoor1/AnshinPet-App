import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/model/disease_model.dart';
import 'package:anshinpet/res/components/appbar_custom.dart';
import 'package:anshinpet/view_model/disease_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiseaseEditPage extends StatefulWidget {
  const DiseaseEditPage({super.key, required this.disease});

  final DiseaseModel disease;

  @override
  State<DiseaseEditPage> createState() => _DiseaseEditPageState();
}

class _DiseaseEditPageState extends State<DiseaseEditPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.disease.name);
    _descriptionController = TextEditingController(text: _getSeverityTextFromCode(widget.disease.description));
  }

    String _getSeverityCodeFromText(String? inputText) {
    if (inputText == null) return '';

    final lowercasedInput = inputText.toLowerCase().trim();
    switch (lowercasedInput) {
      case 'alta':
      case 'a':
        return 'A';
      case 'media':
      case 'média':
      case 'm':
        return 'M';
      case 'baixa':
      case 'b':
        return 'B';
      default:
        return '';
    }
  }

    String _getSeverityTextFromCode(String code) {
    switch (code.toUpperCase()) {
      case 'A':
        return 'Alta';
      case 'M':
        return 'Média';
      case 'B':
        return 'Baixa';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome da Doença',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                  ),
                ),
                validator: (value) {
                  if( value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Gravidade (Alta, Média, Baixa)',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (_getSeverityCodeFromText(value).isEmpty) {
                    return 'Insira Alta, Média ou Baixa.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (!mounted) return;
                        Navigator.pop(context);
                        }, 
                      child: const Text('Cancelar')
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(124, 84, 217, 1),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      onPressed: _saveChanges,
                      child: Text(
                        'Salvar Alterações',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ), 
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final severityCode = _getSeverityCodeFromText(_descriptionController.text);

      final updatedDisease = DiseaseModel(
        id: widget.disease.id, 
        name: _nameController.text,
        description: severityCode,
      );

      Provider.of<DiseaseViewModel>(context, listen: false)
          .updateDisease(updatedDisease);

      Navigator.pop(context);
    }
  }
}
