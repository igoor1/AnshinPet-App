import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/resources/components/appbar_custom.dart';
import 'package:anshinpet/resources/components/bottom_navigation_bar_custom.dart';
import 'package:anshinpet/resources/components/drawer_custom.dart';
import 'package:anshinpet/viewmodels/animal_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anshinpet/view/animals/new_animal_page.dart';

class AnimalPage extends StatefulWidget {
  const AnimalPage({super.key});

  @override
  State<AnimalPage> createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  void _fetchData() {
    context.read<AnimalViewModel>().fetchAnimals();
  }

  String _getAnimalTypeName(String? typeCode) {
    switch (typeCode) {
      case 'C':
        return 'Cachorro';
      case 'G':
        return 'Gato';
      case 'A':
        return 'Ave';
      default:
        return 'Tipo não informado';
    }
  }

  IconData _getAnimalIcon(String? typeCode) {
    switch (typeCode) {
      case 'C':
        return Icons.pets;
      case 'G':
        return Icons.cruelty_free;
      case 'A':
        return Icons.flutter_dash;
      default:
        return Icons.question_mark;
    }
  }

  void _openAddExpensiveOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      context: context,
      builder: (ctx) => NewAnimalPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final animalProvider = Provider.of<AnimalViewModel>(context);
    final animals = animalProvider.animals;
    final isLoading = animalProvider.loading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppbarCustom(),
      drawer: DrawerCustom(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenWidth * 0.02),
                  child: const Text(
                    "Animais",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: animals.isEmpty
                      ? const Center(child: Text('Nenhum animal encontrado.'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          itemCount: animals.length,
                          itemBuilder: (context, index) {
                            final animal = animals[index];
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      AppColors.primary.withOpacity(0.1),
                                  foregroundColor: AppColors.primary,
                                  child: Icon(_getAnimalIcon(animal.tipo)),
                                ),
                                title: Text(
                                  animal.nome ?? 'Sem nome',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  '${_getAnimalTypeName(animal.tipo)} - ${animal.raca ?? 'Raça não informada'}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right,
                                  color: AppColors.primary,
                                ),
                                onTap: () {
                                  print('Ver mais sobre: ${animal.nome}');
                                },
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
      bottomNavigationBar: BottomNavigationBarCustom(valueIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpensiveOverlay,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
