import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/resources/components/appbar_custom.dart';
import 'package:anshinpet/viewmodels/animal_status_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimalStatusPage extends StatefulWidget {
  const AnimalStatusPage({super.key});

  @override
  State<AnimalStatusPage> createState() => _AnimalStatusPageState();
}

class _AnimalStatusPageState extends State<AnimalStatusPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnimalStatusViewModel>(context, listen: false).fetchAnimalStatus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    Provider.of<AnimalStatusViewModel>(context, listen: false).fetchAnimalStatus();
  }

  @override
  Widget build(BuildContext context) {
    final statusViewModel = Provider.of<AnimalStatusViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppbarCustom(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Status de Animais",
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
                  hintText: 'Buscar status...',
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
                  statusViewModel.filterStatus(value);
                },
              ),
            ),
            
            Expanded(
              child: Consumer<AnimalStatusViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading && viewModel.filteredStatus.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewModel.error != null) {
                    return Center(child: Text(viewModel.error!));
                  }
                  if (viewModel.filteredStatus.isEmpty) {
                    return const Center(child: Text("Nenhum status de animal encontrado."));
                  }

                  return RefreshIndicator(
                    onRefresh: _fetchData,
                    child: ListView.builder(
                      itemCount: viewModel.filteredStatus.length,
                      itemBuilder: (context, index) {
                        final status = viewModel.filteredStatus[index];
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
                              child: Text(status.id.toString()),
                            ),
                            title: Text(
                              status.name,
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