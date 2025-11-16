import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/resources/components/appbar_custom.dart';
import 'package:anshinpet/viewmodels/animal_type_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimalTypePage extends StatefulWidget {
  const AnimalTypePage({super.key});

  @override
  State<AnimalTypePage> createState() => _AnimalTypePageState();
}

class _AnimalTypePageState extends State<AnimalTypePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnimalTypeViewModel>(context, listen: false).fetchAnimalTypes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    Provider.of<AnimalTypeViewModel>(context, listen: false).fetchAnimalTypes();
  }

  @override
  Widget build(BuildContext context) {
    final typeViewModel = Provider.of<AnimalTypeViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppbarCustom(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tipos de Animais",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar tipos...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: AppColors.primary, width: 2.0)
                  ),
                ),
                onChanged: (value) {
                  typeViewModel.filterTypes(value);
                },
              ),
            ),
            
            Expanded(
              child: Consumer<AnimalTypeViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading && viewModel.filteredTypes.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewModel.error != null) {
                    return Center(child: Text(viewModel.error!));
                  }
                  if (viewModel.filteredTypes.isEmpty) {
                    return const Center(child: Text("Nenhum tipo de animal encontrado."));
                  }
                  
                  return RefreshIndicator(
                    onRefresh: _fetchData,
                    child: ListView.builder(
                      itemCount: viewModel.filteredTypes.length,
                      itemBuilder: (context, index) {
                        final type = viewModel.filteredTypes[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              foregroundColor: AppColors.primary,
                              child: Text(type.id.toString()),
                            ),
                            title: Text(
                              type.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}