import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/model/animal_model.dart';

class AnimalCard extends StatelessWidget {
  final AnimalModel animal;
  final String? token;
  final VoidCallback onTap;

  const AnimalCard({
    super.key,
    required this.animal,
    required this.onTap,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    final status = animal.animalStatus?.name ?? "Não informado";
    final statusColor = getStatusColor(status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              AppUrl.animalImageUrl(animal.id!),
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              headers: {
                'Authorization': 'Bearer $token',
              },
              errorBuilder: (_, __, ___) => Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.pets, color: AppColors.primary, size: 32),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  animal.name ?? "Nome indisponível",
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 6),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: onTap,
            child: const Text(
              "Ver mais",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color getStatusColor(String status) {
  switch (status.toUpperCase()) {
    case "ADOÇÃO":
      return const Color(0xFF4CAF50); // Verde
    case "MEDICAMENTO":
      return const Color(0xFFFFC107); // Amarelo
    case "ADOTADO":
      return const Color(0xFF2196F3); // Azul
    case "DOENTE":
      return const Color(0xFFE91E63); // Rosa/Red
    case "NÃO DISPONÍVEL":
      return const Color(0xFF9C27B0); // Roxo
    default:
      return const Color(0xFF9E9E9E); // Cinza
  }
}
