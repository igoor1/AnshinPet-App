import 'package:anshinpet/model/disease_model.dart';
import 'package:anshinpet/view/disease/disease_edit_page.dart';
import 'package:flutter/material.dart';

class DiseaseCard extends StatelessWidget {
  final DiseaseModel disease;

  const DiseaseCard({
    super.key,
    required this.disease,
  });

  String _getSeverityText(String code) {
    switch (code) {
      case 'A':
        return 'Alta';
      case 'M':
        return 'Média';
      case 'B':
        return 'Baixa';
      default:
        return 'Não informada'; 
    }
  }

  Color _getSeverityColor(String code) {
    switch (code.toUpperCase()) {
      case 'A':
        return Colors.red.shade400; 
      case 'M':
        return Colors.orange.shade400;
      case 'B':
        return Colors.green.shade400;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => DiseaseEditPage(disease: disease)
          )
        )
      },
      child: Card(
        elevation: 2.0,
        shadowColor: Colors.deepPurple.shade50, 
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.healing_outlined,
                    color: Color.fromRGBO(124, 84, 217, 1),
                    size: 18.0,
                  ),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: Text(
                      disease.name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(124, 84, 217, 1),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 24.0,
                thickness: 0.5,
                color: Color.fromARGB(255, 230, 221, 248), 
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ 
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(disease.description).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row( 
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getSeverityColor(disease.description),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          _getSeverityText(disease.description),
                          style: TextStyle(
                            color: _getSeverityColor(disease.description),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          )
                        )
                      ]
                    )
                  ),
                  Text(
                    'Ver mais',
                    style: TextStyle(
                      fontWeight: FontWeight.w600
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
