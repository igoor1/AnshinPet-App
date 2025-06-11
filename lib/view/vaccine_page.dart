import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/res/components/appbar_custom.dart';
import 'package:anshinpet/res/components/vaccine_card.dart';
import 'package:anshinpet/view/vaccine/new_vaccine_page.dart';
import 'package:anshinpet/view_model/vaccine_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VaccinePage extends StatefulWidget {
  const VaccinePage({super.key});

  @override
  State<VaccinePage> createState() => _VaccinePageState();
}

class _VaccinePageState extends State<VaccinePage> {
   final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VaccineViewModel>(context, listen: false).fetchVaccines();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vaccineViewModel = Provider.of<VaccineViewModel>(context);
    return Scaffold(
      appBar: AppbarCustom(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "vacinas",
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
                    hintText: 'Buscar vacinas...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onChanged: (value) {
                    vaccineViewModel.filterVaccines(value);
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Consumer<VaccineViewModel>(
                builder: (context, viewModel, child) {
                  if(viewModel.loading){
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewModel.error != null) {
                    return Center(child: Text(viewModel.error!));
                  }
                  if (viewModel.filteredVaccines.isEmpty) {
                    return const Center(child: Text("Nenhuma vacina encontrada."));
                  }
                  return ListView.builder(
                    itemCount: viewModel.filteredVaccines.length,
                    itemBuilder: (context, index) {
                      final vaccine = viewModel.filteredVaccines[index];
                      return VaccineCard(vaccine: vaccine);
                    },
                  );
                }
              )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => NewVaccinePage()
                )
              ), 
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: CircleBorder(),
              child: Icon(Icons.add),
            )
    );
  }
}