import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/model/animal_model.dart';
import 'package:anshinpet/resources/components/appbar_custom.dart';
import 'package:anshinpet/view/animals/edit_animal_page.dart';
import 'package:anshinpet/viewmodels/animal_view_model.dart';
import 'package:anshinpet/viewmodels/token_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AnimalDetailPage extends StatefulWidget {
  final AnimalModel animal;
  const AnimalDetailPage({super.key, required this.animal});

  @override
  State<AnimalDetailPage> createState() => _AnimalDetailPageState();
}

class _AnimalDetailPageState extends State<AnimalDetailPage> {
  late AnimalModel _currentAnimal;
  String? _token;
  bool _isPanelOpen = false;

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

  void _togglePanel() {
    setState(() {
      _isPanelOpen = !_isPanelOpen;
    });
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

  void _showFullScreenImage(BuildContext context) {
    final heroTag = 'animalImage-${_currentAnimal.id}';
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (_) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
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
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 100, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
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

    final screenWidth = MediaQuery.of(context).size.width;
    final heroTag = 'animalImage-${_currentAnimal.id}';
    final panelWidth = screenWidth * 0.65;
    
    // Calcula a posição para o botão
    final buttonRightPosition = _isPanelOpen ? panelWidth : 0; 

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppbarCustom(),
      body: Stack(
        children: [
          // --- 1. Conteúdo principal (ESTÁTICO, não se move e fica embaixo) ---
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnimalInfo(heroTag),
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
                  _buildInfoCard('Descrição', [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _currentAnimal.description!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      ),
                    )
                  ]),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditAnimalPage(animal: _currentAnimal),
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
                        onPressed: () {}, // Função de deletar
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
              ],
            ),
          ),

          // --- 2. Painel Lateral (Flutuante) ---
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 0,
            bottom: 0,
            right: _isPanelOpen ? 0 : -panelWidth, // Desliza para a direita/esquerda
            width: panelWidth,
            child: Material(
              elevation: 8,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 56, 
                    color: AppColors.primary,
                    child: Center(
                      child: Text(
                        'Informações Médicas',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDataSection('Vacinas', 
                                  context.read<AnimalViewModel>().fetchAnimalVaccines(_currentAnimal.id!)),
                          const SizedBox(height: 20),
                          _buildDataSection('Doenças', 
                                  context.read<AnimalViewModel>().fetchAnimalDiseases(_currentAnimal.id!)),
                          const SizedBox(height: 20),
                          _buildDataSection('Medicações', 
                                  context.read<AnimalViewModel>().fetchAnimalMedications(_currentAnimal.id!)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- 3. Botão lateral para abrir/fechar ---
          Positioned(
            top: 180,
            right: _isPanelOpen ? panelWidth : 0, // A posição 'right' agora é o limite esquerdo do painel
            child: GestureDetector(
              onTap: _togglePanel,
              child: Container(
                width: 25,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                ),
                child: Icon(
                  _isPanelOpen ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- MÉTODOS AUXILIARES ---
  Widget _buildAnimalInfo(String heroTag) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
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
                      headers: {'Authorization': 'Bearer $_token'},
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.pets, size: 60, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_currentAnimal.name ?? 'Nome Desconhecido',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  if (_currentAnimal.animalType != null)
                    Text(_currentAnimal.animalType!.name,
                        style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                  const SizedBox(height: 8),
                  if (_currentAnimal.animalStatus?.name != null)
                    Chip(
                      label: Text(_currentAnimal.animalStatus!.name,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      backgroundColor: AppColors.primary,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const Divider(),
          ...children
        ]),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text('$label:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]))),
          Expanded(child: Text(value, style: TextStyle(color: Colors.grey[900]))),
        ],
      ),
    );
  }
  
  Widget _buildDataSection(String title, Future<List<dynamic>> futureData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
        const Divider(),
        FutureBuilder<List<dynamic>>(
          future: futureData, 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return const Center(child: LinearProgressIndicator());
              
            if (snapshot.hasError) return Text('Erro ao carregar $title: ${snapshot.error}');
            
            final items = snapshot.data;
            if (items == null || items.isEmpty) return Text('Sem $title registradas.');

            return Column(
              children: items.map((dynamic item) {
                if (item == null || item is! Map<String, dynamic>) {
                    return const SizedBox.shrink(); 
                }
                
                String name = item['name'] ?? 'N/A';
                String subtitle = '';
                
                if (title == 'Vacinas') {
                  name = item['nome'] ?? item['name'] ?? 'Vacina sem nome';
                  subtitle = 'Produtor: ${item['produtor'] ?? item['producer'] ?? 'N/A'}';
                } else if (title == 'Doenças') {
                  name = item['name'] ?? 'Doença sem nome';
                  subtitle = 'Severidade: ${item['severity'] ?? 'N/A'}';
                } else if (title == 'Medicações') {
                  name = item['name'] ?? 'Medicação sem nome';
                  subtitle = 'Dosagem: ${item['dosage'] ?? 'N/A'}';
                }
                
                return ListTile(title: Text(name), subtitle: Text(subtitle));
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}