import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/model/vaccine_model.dart';
import 'package:anshinpet/viewmodels/vaccine_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VaccineCard extends StatelessWidget {
  final VaccineModel vaccine;

  const VaccineCard({
    super.key,
    required this.vaccine,
  });

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir Vacina"),
        content: Text("Deseja realmente excluir '${vaccine.name}'?"),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: Text(
              "Excluir",
              style: TextStyle(color: Colors.red.shade700),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await Provider.of<VaccineViewModel>(context, listen: false)
                  .deleteVaccine(vaccine.id);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shadowColor: Colors.deepPurple.shade50,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.healing_outlined,
                      color: Color.fromRGBO(124, 84, 217, 1),
                      size: 20.0,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      vaccine.name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(124, 84, 217, 1),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade600),
                  onPressed: () => _confirmDelete(context),
                )
              ],
            ),
            const Divider(
              height: 24.0,
              thickness: 0.5,
              color: Color.fromARGB(255, 230, 221, 248),
            ),
            Row(
              children: [
                Icon(
                  Icons.factory_outlined,
                  size: 16.0,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6.0),
                Text(
                  vaccine.manufacturer,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
