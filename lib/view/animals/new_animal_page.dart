import 'package:anshinpet/configs/theme/app_colors.dart';
import 'dart:io';
import 'package:anshinpet/view_model/animal_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

const List<Map<String, String>> sexoList = [
  {'label': 'Macho', 'value': 'M'},
  {'label': 'Fêmea', 'value': 'F'}
];
const List<Map<String, String>> porteList = [
  {'label': 'Pequeno', 'value': 'P'},
  {'label': 'Médio', 'value': 'M'},
  {'label': 'Grande', 'value': 'G'}
];
const List<Map<String, String>> castradoList = [
  {'label': 'Sim', 'value': 'S'},
  {'label': 'Não', 'value': 'N'}
];
const List<Map<String, String>> adocaoList = [
  {'label': 'Sim', 'value': 'S'},
  {'label': 'Não', 'value': 'N'}
];
const List<Map<String, String>> tipoList = [
  {'label': 'Cachorro', 'value': 'C'},
  {'label': 'Gato', 'value': 'G'},
  {'label': 'Ave', 'value': 'A'}
];

class NewAnimalPage extends StatefulWidget {
  const NewAnimalPage({super.key});

  @override
  State<NewAnimalPage> createState() => _NewAnimalPageState();
}

class _NewAnimalPageState extends State<NewAnimalPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _corController = TextEditingController();

  String? _selectedSexo;
  String? _selectedPorte;
  String? _selectedCastrado;
  String? _selectedAdocao;
  String? _selectedTipo;

  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedImage == null) return;
    setState(() {
      _imageFile = File(pickedImage.path);
    });
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Por favor, preencha todos os campos e selecione uma imagem.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _formKey.currentState!.save();

    final animalViewModel = context.read<AnimalViewModel>();

    final animalData = {
      'nome': _nomeController.text,
      'raca': _racaController.text,
      'cor': _corController.text,
      'sexo': _selectedSexo!,
      'porte': _selectedPorte!,
      'castrado': _selectedCastrado!,
      'para_adocao': _selectedAdocao!,
      'tipo': _selectedTipo!,
    };

    final success = await animalViewModel.createAnimal(animalData, _imageFile!);

    if (mounted) {
      if (true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Animal cadastrado com sucesso!'),
              backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erro ao cadastrar animal.'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _racaController.dispose();
    _corController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AnimalViewModel>().loading;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Cadastrar Novo Animal',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary),
                      image: _imageFile != null
                          ? DecorationImage(
                              image: FileImage(_imageFile!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: _imageFile == null
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt,
                                    size: 40, color: AppColors.primary),
                                SizedBox(height: 8),
                                Text('Adicionar Foto',
                                    style: TextStyle(color: AppColors.primary)),
                              ],
                            ),
                          )
                        : null),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Animal'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Insira um nome.' : null,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Tipo',
                value: _selectedTipo,
                items: tipoList,
                onChanged: (v) => setState(() => _selectedTipo = v),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Sexo',
                value: _selectedSexo,
                items: sexoList,
                onChanged: (v) => setState(() => _selectedSexo = v),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Porte',
                value: _selectedPorte,
                items: porteList,
                onChanged: (v) => setState(() => _selectedPorte = v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _racaController,
                decoration: const InputDecoration(labelText: 'Raça'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Insira a raça.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _corController,
                decoration:
                    const InputDecoration(labelText: 'Cor Predominante'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Insira a cor.' : null,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'É Castrado?',
                value: _selectedCastrado,
                items: castradoList,
                onChanged: (v) => setState(() => _selectedCastrado = v),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Disponível para Adoção?',
                value: _selectedAdocao,
                items: adocaoList,
                onChanged: (v) => setState(() => _selectedAdocao = v),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Salvar',
                            style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<Map<String, String>> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
            value: item['value'], child: Text(item['label']!));
      }).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Selecione uma opção.' : null,
    );
  }
}
