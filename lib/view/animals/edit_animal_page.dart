import 'dart:io';
import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/model/animal_model.dart';
import 'package:anshinpet/model/animal_status_model.dart';
import 'package:anshinpet/viewmodels/animal_status_view_model.dart';
import 'package:anshinpet/viewmodels/animal_view_model.dart';
import 'package:anshinpet/viewmodels/token_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditAnimalPage extends StatefulWidget {
  final AnimalModel animal;
  const EditAnimalPage({super.key, required this.animal});
  @override
  State<EditAnimalPage> createState() => _EditAnimalPageState();
}

class _EditAnimalPageState extends State<EditAnimalPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _colorController;
  late TextEditingController _descriptionController;
  late TextEditingController _birthDateController;
  late TextEditingController _rescueDateController;
  late TextEditingController _animalTypeController;
  AnimalStatusModel? _selectedStatus;
  String? _selectedGender;
  
  File? _selectedImage;
  String? _token;
  final ImagePicker _picker = ImagePicker();
  bool _isPageLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.animal.name);
    _breedController = TextEditingController(text: widget.animal.breed);
    _colorController = TextEditingController(text: widget.animal.color);
    _descriptionController = TextEditingController(text: widget.animal.description);
    _birthDateController = TextEditingController(text: _formatDateForInput(widget.animal.birthDate));
    _rescueDateController = TextEditingController(text: _formatDateForInput(widget.animal.rescueDate));
    _animalTypeController = TextEditingController(text: widget.animal.animalType?.name ?? 'Não informado');
    _selectedGender = _normalizeGender(widget.animal.gender);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  String? _normalizeGender(String? gender) {
    if (gender == null) return null;
    final lower = gender.toLowerCase();
    if (lower == 'm' || lower == 'male' || lower == 'macho') return 'Macho';
    if (lower == 'f' || lower == 'female' || lower == 'fêmea') return 'Fêmea';
    return null;
  }

  void _loadInitialData() async {
    setState(() { _isPageLoading = true; });
    final tokenModel = await context.read<TokenViewModel>().getToken();
    if (!mounted) return;
    _token = tokenModel.token;
    final statusVM = Provider.of<AnimalStatusViewModel>(context, listen: false);
    await statusVM.fetchAnimalStatus();
    if (!mounted) return;
    if (statusVM.filteredStatus.isNotEmpty) {
      _selectedStatus = statusVM.filteredStatus.firstWhere(
        (s) => s.id == widget.animal.animalStatus?.id,
        orElse: () => statusVM.filteredStatus.first,
      );
    }
    setState(() { _isPageLoading = false; });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    _descriptionController.dispose();
    _birthDateController.dispose();
    _rescueDateController.dispose();
    _animalTypeController.dispose();
    super.dispose();
  }

  String _formatDateForInput(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    
    final animalViewModel = Provider.of<AnimalViewModel>(context, listen: false);
    
    String? birthDateISO;
    if (_birthDateController.text.isNotEmpty) {
      birthDateISO = DateFormat('dd/MM/yyyy').parse(_birthDateController.text).toIso8601String();
    }
    String? rescueDateISO;
    if (_rescueDateController.text.isNotEmpty) {
      rescueDateISO = DateFormat('dd/MM/yyyy').parse(_rescueDateController.text).toIso8601String();
    }

    Map<String, dynamic> updatedData = {
      'name': _nameController.text,
      'breed': _breedController.text,
      'color': _colorController.text,
      'gender': _selectedGender,
      'description': _descriptionController.text,
      'birth_date': birthDateISO,
      'rescue_date': rescueDateISO,
      'type': widget.animal.animalType?.id,
      'status': _selectedStatus?.id,   
    };

    try {
      AnimalModel? animalAtualizado = await animalViewModel.updateAnimal(widget.animal.id!, updatedData);
      
      if (animalAtualizado != null && _selectedImage != null) {
    
        await animalViewModel.uploadAnimalImage(
          animalAtualizado.id!,
          _selectedImage!,
          "Imagem de ${animalAtualizado.name}",
        );
      }

      if (animalAtualizado != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${animalAtualizado.name} atualizado com sucesso!'),
          backgroundColor: Colors.green,
        ));
        Navigator.of(context).pop(animalAtualizado);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(animalViewModel.error ?? 'Erro ao atualizar: ${e.toString()}'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusVM = Provider.of<AnimalStatusViewModel>(context);
    final animalVM = Provider.of<AnimalViewModel>(context, listen: true);

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
      appBar: AppBar(
        title: Text('Editar ${widget.animal.name}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isPageLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Área da imagem (Preview com Image.file)
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          foregroundColor: AppColors.primary,
                          child: _selectedImage != null
                              ? ClipOval( 
                                  child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover, width: 140, height: 140,
                                    ),
                                )
                              : ClipOval( 
                                  child: Image.network(
                                    AppUrl.animalImageUrl(widget.animal.id!),
                                    fit: BoxFit.cover, width: 140, height: 140,
                                    headers: {'Authorization': 'Bearer $_token'}, 
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.camera_alt, size: 50, color: AppColors.primary);
                                    },
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
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
                    ),
                    const SizedBox(height: 16),
                    
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: inputDecoration.copyWith(labelText: 'Gênero'),
                      icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      items: ['Macho', 'Fêmea'].map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() { _selectedGender = newValue; });
                      },
                      validator: (value) => value == null ? 'Campo obrigatório' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _animalTypeController,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Tipo de Animal',
                        filled: true,
                        fillColor: Colors.grey[200],
                        suffixIcon: const Icon(Icons.lock),
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),

                    if (statusVM.filteredStatus.isNotEmpty)
                      DropdownButtonFormField<AnimalStatusModel>(
                        value: _selectedStatus,
                        isExpanded: true,
                        decoration: inputDecoration.copyWith(labelText: 'Status do Animal'),
                        icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        items: statusVM.filteredStatus.map((AnimalStatusModel status) {
                          return DropdownMenuItem<AnimalStatusModel>(
                            value: status,
                            child: Text(status.name, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() { _selectedStatus = newValue; });
                        },
                        validator: (value) => value == null ? 'Campo obrigatório' : null,
                      ),
                    const SizedBox(height: 16),

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

                    TextFormField(
                      controller: _descriptionController,
                      decoration: inputDecoration.copyWith(labelText: 'Descrição'),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: animalVM.loading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: animalVM.loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Salvar Alterações', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}