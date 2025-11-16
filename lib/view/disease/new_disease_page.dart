import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/resources/components/appbar_custom.dart';
import 'package:anshinpet/viewmodels/disease_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewDiseasePage extends StatefulWidget {
  const NewDiseasePage({super.key});

  @override
  State<NewDiseasePage> createState() => _NewDiseasePageState();
}

class _NewDiseasePageState extends State<NewDiseasePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _severityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _severityController.dispose();
    super.dispose();
  }

  String _getSeverityCodeFromText(String? text) {
    if (text == null) return "";

    final normalized = text.trim().toUpperCase();

    if (normalized.contains("ALTA")) return "ALTA";
    if (normalized.contains("MEDIA") || normalized.contains("MÉDIA")) return "MEDIA";
    if (normalized.contains("BAIXA")) return "BAIXA";

    return "";
  }

  void _createDisease() async {
    if (_formKey.currentState!.validate()) {

      final severityCode = _getSeverityCodeFromText(_severityController.text);

      final newDisease = {
        "name": _nameController.text,
        "severity": severityCode,
      };

      await Provider.of<DiseaseViewModel>(context, listen: false)
          .createDisease(newDisease);

      Navigator.pop(context);
    }
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
              const Text(
                "Cadastrar Nova Doença",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(124, 84, 217, 1),
                ),
              ),
              const SizedBox(height: 20),

              // --- INPUT NOME ---
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome da Doença',
                  prefixIcon: const Icon(Icons.assignment_outlined,
                      color: Color.fromRGBO(124, 84, 217, 1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Insira um nome.' : null,
              ),
              const SizedBox(height: 20),

              // --- INPUT GRAVIDADE ---
              TextFormField(
                controller: _severityController,
                decoration: InputDecoration(
                  labelText: 'Gravidade (ALTA, MEDIA, BAIXA)',
                  prefixIcon: const Icon(Icons.warning_amber_rounded,
                      color: Color.fromRGBO(124, 84, 217, 1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) {
                  if (_getSeverityCodeFromText(value).isEmpty) {
                    return 'Insira Alta, Média ou Baixa.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // --- BOTÃO ---
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  'Cadastrar Doença',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _createDisease,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
