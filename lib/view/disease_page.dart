import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/res/components/appbar_custom.dart';
import 'package:anshinpet/res/components/disease_card.dart';
import 'package:anshinpet/view_model/disease_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiseasePage extends StatefulWidget {
  const DiseasePage({super.key});

  @override
  State<DiseasePage> createState() => _DiseasePageState();
}

class _DiseasePageState extends State<DiseasePage> {

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DiseaseViewModel>(context, listen: false).fetchDiseases();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diseaseViewModel = Provider.of<DiseaseViewModel>(context);
    return Scaffold(
      appBar: AppbarCustom(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Doenças",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.primary
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar doenças...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onChanged: (value) {
                    diseaseViewModel.filterDiseases(value);
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Consumer<DiseaseViewModel>(
                builder: (context, viewModel, child) {
                  if(viewModel.loading){
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewModel.error != null) {
                    return Center(child: Text(viewModel.error!));
                  }
                  if (viewModel.filteredDiseases.isEmpty) {
                    return const Center(child: Text("Nenhuma doença encontrada."));
                  }
                  return ListView.builder(
                    itemCount: viewModel.filteredDiseases.length,
                    itemBuilder: (context, index) {
                      final disease = viewModel.filteredDiseases[index];
                      return DiseaseCard(disease: disease);
                    },
                  );
                }
              )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
              onPressed: (){}, 
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: CircleBorder(),
              child: Icon(Icons.add),
            )
    );
  }
}