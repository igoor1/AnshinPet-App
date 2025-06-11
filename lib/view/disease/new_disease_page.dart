import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/res/components/appbar_custom.dart';
import 'package:anshinpet/view_model/disease_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewDiseasePage extends StatefulWidget {
  const NewDiseasePage({super.key});

  @override
  State<NewDiseasePage> createState() => _NewDiseasePageState();
}

class _NewDiseasePageState extends State<NewDiseasePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _getSeverityCodeFromText(String? inputText) {
    if (inputText == null) return '';
    final lowercasedInput = inputText.toLowerCase().trim();
    switch (lowercasedInput) {
      case 'alta': case 'Alta':
        return 'A';
      case 'media': case 'Media': case 'm':
        return 'M';
      case 'baixa': case 'Baixa':
        return 'B';
      default:
        return '';
    }
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
                  labelText: 'Nome da Doença',
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
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Gravidade (Alta, Média ou Baixa)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                validator: (value) {
                  if (_getSeverityCodeFromText(value).isEmpty) {
                    return 'Insira Alta, Media ou Baixa.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30.0),
              ElevatedButton.icon(
                label: const Text('Cadastrar Doença'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  foregroundColor: Colors.white,
                ),
                onPressed: _createDisease,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
   void _createDisease() {
    if (_formKey.currentState!.validate()) {
      final severityCode = _getSeverityCodeFromText(_descriptionController.text);
      
      final newDiseaseData = {
        'nome': _nameController.text,
        'gravidade': severityCode,
      };
      
      Provider.of<DiseaseViewModel>(context, listen: false)
          .createDisease(newDiseaseData);

      Navigator.pop(context);
    }
  }
}