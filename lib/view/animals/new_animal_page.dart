import 'dart:io';
import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/model/animal_model.dart';
import 'package:anshinpet/model/animal_status_model.dart';
import 'package:anshinpet/model/animal_type_model.dart';
import 'package:anshinpet/resources/components/appbar_custom.dart';
import 'package:anshinpet/viewmodels/animal_status_view_model.dart';
import 'package:anshinpet/viewmodels/animal_type_view_model.dart';
import 'package:anshinpet/viewmodels/animal_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewAnimalPage extends StatefulWidget {
  const NewAnimalPage({super.key});

  @override
  State<NewAnimalPage> createState() => _NewAnimalPageState();
}

class _NewAnimalPageState extends State<NewAnimalPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _colorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _rescueDateController = TextEditingController();

  AnimalTypeModel? _selectedType;
  AnimalStatusModel? _selectedStatus;
  String? _selectedGender;
  
  File? _selectedImage;
  
  final ImagePicker _picker = ImagePicker();
  bool _isPageLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDropdownData();
    });
  }

  Future<void> _fetchDropdownData() async {
    setState(() { _isPageLoading = true; });

    try {
      final typeVM = Provider.of<AnimalTypeViewModel>(context, listen: false);
      final statusVM = Provider.of<AnimalStatusViewModel>(context, listen: false);

      await Future.wait([
        typeVM.fetchAnimalTypes(),
        statusVM.fetchAnimalStatus(),
      ]);

      if (!mounted) return;

      if (typeVM.filteredTypes.isNotEmpty) {
        _selectedType = typeVM.filteredTypes.first;
      }
      if (statusVM.filteredStatus.isNotEmpty) {
        _selectedStatus = statusVM.filteredStatus.first;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao carregar dados: ${e.toString()}'),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      if (mounted) {
        setState(() { _isPageLoading = false; });
      }
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    _descriptionController.dispose();
    _birthDateController.dispose();
    _rescueDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  String? _formatDateForAPI(String dateText) {
    if (dateText.isEmpty) return null;
    try {
      DateTime date = DateFormat('dd/MM/yyyy').parse(dateText);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final animalViewModel = Provider.of<AnimalViewModel>(context, listen: false);

    String? birthDateAPI = _formatDateForAPI(_birthDateController.text);
    String? rescueDateAPI = _formatDateForAPI(_rescueDateController.text);

    Map<String, dynamic> animalData = {
      'name': _nameController.text, 'breed': _breedController.text,
      'color': _colorController.text, 'gender': _selectedGender,
      'description': _descriptionController.text, 'birth_date': birthDateAPI,
      'rescue_date': rescueDateAPI, 'type': _selectedType?.id,
      'status': _selectedStatus?.id,
    };

    AnimalModel? newAnimal;

    try {
      newAnimal = await animalViewModel.createAnimal(animalData);
      
      if (newAnimal == null) {
        throw Exception(animalViewModel.error ?? "Falha ao criar animal.");
      }

      if (_selectedImage != null) {
        try {
          await animalViewModel.uploadAnimalImage(
            newAnimal.id!,
            _selectedImage!,
            "Imagem de ${newAnimal.name}",
          );
        } catch (imgError) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Animal criado, mas falha ao enviar imagem: $imgError'),
              backgroundColor: Colors.orange,
            ));
          }
          
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${newAnimal.name} criado com sucesso!'),
          backgroundColor: Colors.green,
        ));
        Navigator.of(context).pop();
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(animalViewModel.error ?? 'Erro ao criar animal: ${e.toString()}'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeVM = Provider.of<AnimalTypeViewModel>(context);
    final statusVM = Provider.of<AnimalStatusViewModel>(context);
    final animalVM = Provider.of<AnimalViewModel>(context);

    const inputDecoration = InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.primary, width: 2.0),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarCustom(),
      
      body: _isPageLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cadastrar Novo Animal',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Área da Imagem
                            Center(
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundColor: AppColors.primary.withOpacity(0.1),
                                  foregroundColor: AppColors.primary,
                                  child: _selectedImage == null
                                      ? const Icon(Icons.camera_alt, size: 50, color: AppColors.primary)
                                      : ClipOval(
                                          child: Image.file(
                                            _selectedImage!,
                                            fit: BoxFit.cover, width: 140, height: 140,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Campos do Formulário
                            TextFormField(
                              controller: _nameController,
                              decoration: inputDecoration.copyWith(labelText: 'Nome'),
                              validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _breedController,
                              decoration: inputDecoration.copyWith(labelText: 'Raça'),
                              validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                            ),
                            const SizedBox(height: 16),
                            
                            TextFormField(
                              controller: _colorController,
                              decoration: inputDecoration.copyWith(labelText: 'Cor'),
                              validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                            ),
                            const SizedBox(height: 16),
                            
                            DropdownButtonFormField<String>(
                              value: _selectedGender,
                              hint: const Text('Selecione o Gênero'),
                              decoration: inputDecoration.copyWith(labelText: 'Gênero'),
                              icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              items: ['Macho', 'Fêmea'].map((String gender) {
                                return DropdownMenuItem<String>(value: gender, child: Text(gender));
                              }).toList(),
                              onChanged: (newValue) { setState(() { _selectedGender = newValue; }); },
                              validator: (value) => value == null ? 'Campo obrigatório' : null,
                            ),
                            const SizedBox(height: 16),
                            
                            DropdownButtonFormField<AnimalTypeModel>(
                              value: _selectedType,
                              isExpanded: true,
                              decoration: inputDecoration.copyWith(labelText: 'Tipo de Animal'),
                              icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              items: typeVM.filteredTypes.map((AnimalTypeModel type) {
                                return DropdownMenuItem<AnimalTypeModel>(value: type, child: Text(type.name, overflow: TextOverflow.ellipsis));
                              }).toList(),
                              onChanged: (newValue) { setState(() { _selectedType = newValue; }); },
                              validator: (value) => value == null ? 'Campo obrigatório' : null,
                            ),
                            const SizedBox(height: 16),

                            DropdownButtonFormField<AnimalStatusModel>(
                              value: _selectedStatus,
                              isExpanded: true,
                              decoration: inputDecoration.copyWith(labelText: 'Status do Animal'),
                              icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              items: statusVM.filteredStatus.map((AnimalStatusModel status) {
                                return DropdownMenuItem<AnimalStatusModel>(value: status, child: Text(status.name, overflow: TextOverflow.ellipsis));
                              }).toList(),
                              onChanged: (newValue) { setState(() { _selectedStatus = newValue; }); },
                              validator: (value) => value == null ? 'Campo obrigatório' : null,
                            ),
                            const SizedBox(height: 16),

                            // Datas
                            TextFormField(
                              controller: _birthDateController,
                              decoration: inputDecoration.copyWith(
                                labelText: 'Data de Nascimento (dd/MM/yyyy)',
                                suffixIcon: const Icon(Icons.calendar_today, color: AppColors.primary),
                              ),
                              readOnly: true,
                              onTap: () => _pickDate(_birthDateController),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _rescueDateController,
                              decoration: inputDecoration.copyWith(
                                labelText: 'Data de Resgate (dd/MM/yyyy)',
                                suffixIcon: const Icon(Icons.calendar_today, color: AppColors.primary),
                              ),
                              readOnly: true,
                              onTap: () => _pickDate(_rescueDateController),
                            ),
                            const SizedBox(height: 16),

                            // Descrição
                            TextFormField(
                              controller: _descriptionController,
                              decoration: inputDecoration.copyWith(labelText: 'Descrição'),
                              maxLines: 4,
                              validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Botão Salvar (fixo na parte inferior)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: animalVM.loading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: animalVM.loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Salvar Novo Animal', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}