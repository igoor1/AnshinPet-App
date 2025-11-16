import 'package:anshinpet/model/medication_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anshinpet/viewmodels/medication_view_model.dart';
import 'package:anshinpet/configs/theme/app_colors.dart';

class MedicationCard extends StatelessWidget {
  final MedicationModel medication;

  const MedicationCard({super.key, required this.medication});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir Medicamento"),
        content: Text("Deseja realmente excluir '${medication.name}'?"),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: Text("Excluir", style: TextStyle(color: Colors.red.shade700)),
            onPressed: () async {
              Navigator.pop(ctx);
              await Provider.of<MedicationViewModel>(context, listen: false)
                  .deleteMedication(medication.id!);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.medical_services_outlined, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        medication.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade600),
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 0.5, color: Color(0xFFE6DDFC)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Icon(Icons.factory_outlined, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          medication.manufacturer,
                          style: TextStyle(color: Colors.grey.shade700),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Lote: ${medication.batch}",
                  style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
