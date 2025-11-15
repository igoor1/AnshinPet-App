import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/model/disease_model.dart';
import 'package:anshinpet/resources/components/appbar_custom.dart';
import 'package:anshinpet/viewmodels/disease_view_model.dart';
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
      case 'alta': case 'Alta':
        return 'A';
      case 'Media': case 'media':
      case 'm':
        return 'M';
      case 'Baixa': case 'baixa':
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showConfirmationDialog,
        backgroundColor: Colors.red.shade700, 
        foregroundColor: Colors.white,
        tooltip: 'Excluir Doença',
        child: const Icon(Icons.delete_outline),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Deseja realmente excluir esta doença?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
              child: const Text('Excluir'),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _deleteDisease();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDisease() async {
    await Provider.of<DiseaseViewModel>(context, listen: false)
        .deleteDisease(widget.disease.id);

    if (!mounted) return;
    Navigator.of(context).pop();
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
