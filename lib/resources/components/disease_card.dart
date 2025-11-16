import 'package:anshinpet/model/disease_model.dart';
import 'package:anshinpet/viewmodels/disease_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiseaseCard extends StatelessWidget {
  final DiseaseModel disease;

  const DiseaseCard({
    super.key,
    required this.disease,
  });

  Color _getSeverityColor(String code) {
    switch (code.toUpperCase()) {
      case 'ALTA':
        return Colors.red.shade400;
      case 'MEDIA':
        return Colors.orange.shade400;
      case 'BAIXA':
        return Colors.green.shade400;
      default:
        return Colors.grey;
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir Doença"),
        content: Text("Deseja realmente excluir '${disease.name}'?"),
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

              await Provider.of<DiseaseViewModel>(context, listen: false)
                  .deleteDisease(disease.id);
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
                      Icons.assignment_outlined,
                      color: Color.fromRGBO(124, 84, 217, 1),
                      size: 20.0,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      disease.name,
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

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: _getSeverityColor(disease.severity).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getSeverityColor(disease.severity),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    disease.severity,
                    style: TextStyle(
                      color: _getSeverityColor(disease.severity),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
