import 'package:anshinpet/resources/components/medication_dart.dart';
import 'package:anshinpet/view/medications/new_medication_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anshinpet/viewmodels/medication_view_model.dart';
import 'package:anshinpet/resources/components/appbar_custom.dart';
import 'package:anshinpet/configs/theme/app_colors.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MedicationViewModel>(context, listen: false).fetchMedications();
    });
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    Provider.of<MedicationViewModel>(context, listen: false)
        .filterMedications(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Provider.of<MedicationViewModel>(context, listen: false).fetchMedications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarCustom(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Medicamentos",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Buscar medicamentos...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<MedicationViewModel>(
                  builder: (context, vm, child) {
                    if (vm.loading && vm.filteredMedications.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (vm.error != null) {
                      return Center(child: Text("Erro: ${vm.error}"));
                    }
                    if (vm.filteredMedications.isEmpty) {
                      return const Center(child: Text("Nenhum medicamento encontrado."));
                    }
                    return ListView.builder(
                      itemCount: vm.filteredMedications.length,
                      itemBuilder: (context, index) {
                        final med = vm.filteredMedications[index];
                        return MedicationCard(medication: med);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewMedicationPage()),
        ).then((_) => _refresh()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
