import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/data/app_exceptions.dart';
import 'package:anshinpet/model/animal_model.dart';
import 'package:anshinpet/resources/components/appbar_custom.dart';
import 'package:anshinpet/viewmodels/animal_view_model.dart';
import 'package:anshinpet/viewmodels/auth_view_model.dart';
import 'package:anshinpet/viewmodels/token_view_model.dart';
import 'package:anshinpet/view/animals/edit_animal_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AnimalDetailPage extends StatefulWidget {
  const AnimalDetailPage({super.key, required this.animal});

  final AnimalModel animal; // O animal inicial

  @override
  State<AnimalDetailPage> createState() => _AnimalDetailPageState();
}

class _AnimalDetailPageState extends State<AnimalDetailPage> {
  String? _token;
  late AnimalModel _currentAnimal;

  @override
  void initState() {
    super.initState();
    _currentAnimal = widget.animal;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadToken());
  }

  void _loadToken() async {
    final tokenModel = await context.read<TokenViewModel>().getToken();
    if (mounted) {
      setState(() {
        _token = tokenModel.token;
      });
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Não informado';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _getGenderText(String? gender) {
    if (gender == null) return 'Não informado';
    switch (gender.toUpperCase()) {
      case 'M':
      case 'MALE':
        return 'Macho';
      case 'F':
      case 'FEMALE':
        return 'Fêmea';
      default:
        return gender;
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Deseja realmente excluir ${_currentAnimal.name ?? 'este animal'}?'),
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
                final viewModel = Provider.of<AnimalViewModel>(context, listen: false);
                try {
                  final success = await viewModel.deleteAnimal(_currentAnimal.id!);

                  if (mounted) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Animal excluído com sucesso!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(viewModel.error ?? 'Erro ao excluir animal'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } on UnauthorizedException catch (_) {
                  if (mounted) {
                    await Provider.of<AuthViewModel>(context, listen: false).logout(context);
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print("Erro na exclusão do animal: $e");
                  }
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao excluir: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  // --- 1. NOVO MÉTODO PARA MOSTRAR IMAGEM EM TELA CHEIA ---
  void _showFullScreenImage(BuildContext context) {
    // Tag única para a animação Hero
    final heroTag = 'animalImage-${_currentAnimal.id}';

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext dialogContext) {
        return GestureDetector(
          onTap: () {
            Navigator.of(dialogContext).pop(); 
          },
          child: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 1.0,
              maxScale: 4.0,
              child: Hero( 
                tag: heroTag,
                child: Image.network(
                  AppUrl.animalImageUrl(_currentAnimal.id!),
                  headers: {'Authorization': 'Bearer $_token'},
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, size: 100, color: Colors.white);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_token == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppbarCustom(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final heroTag = 'animalImage-${_currentAnimal.id}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppbarCustom(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    GestureDetector(
                      onTap: () => _showFullScreenImage(context), 
                      child: Hero( 
                        tag: heroTag,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary, width: 1),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.network(
                              AppUrl.animalImageUrl(_currentAnimal.id!),
                              fit: BoxFit.cover,
                              headers: {'Authorization': 'Bearer $_token'},
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: AppColors.primary.withOpacity(0.6),
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    // --- FIM DAS MUDANÇAS ---

                    const SizedBox(width: 16),
                    // Nome e tipo do animal
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentAnimal.name ?? 'Nome Desconhecido',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          if (_currentAnimal.animalType != null)
                            Text(
                              _currentAnimal.animalType!.name,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[700],
                              ),
                            ),
                          const SizedBox(height: 8),
                          if (_currentAnimal.animalStatus?.name != null)
                            Chip(
                              label: Text(
                                _currentAnimal.animalStatus!.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              'Informações Básicas',
              [
                _buildInfoRow('Raça', _currentAnimal.breed ?? 'Não informada'),
                _buildInfoRow('Cor', _currentAnimal.color ?? 'Não informada'),
                _buildInfoRow('Gênero', _getGenderText(_currentAnimal.gender)),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              'Datas',
              [
                _buildInfoRow('Nascimento', _formatDate(_currentAnimal.birthDate)),
                _buildInfoRow('Resgate', _formatDate(_currentAnimal.rescueDate)),
              ],
            ),
            const SizedBox(height: 16),
            if (_currentAnimal.description != null && _currentAnimal.description!.isNotEmpty)
              _buildInfoCard(
                'Descrição',
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: Text(
                      _currentAnimal.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            if (_currentAnimal.description != null && _currentAnimal.description!.isNotEmpty)
              const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAnimalPage(animal: _currentAnimal),
                        ),
                      );

                      if (result != null && result is AnimalModel) {
                        setState(() {
                          _currentAnimal = result;
                        });
                      }
                    },
                    icon: const Icon(Icons.edit, size: 20),
                    label: const Text('Editar', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showDeleteConfirmationDialog(context),
                    icon: const Icon(Icons.delete, size: 20),
                    label: const Text('Excluir', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[900],
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}