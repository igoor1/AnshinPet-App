import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DonationCard extends StatelessWidget {
  final String tipo;
  final String valor;
  final String? descricao;
  final String? quantidade;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DonationCard({
    super.key,
    required this.tipo,
    required this.valor,
    required this.quantidade,
    required this.descricao,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tipo == "D" ? "Dinheiro" : tipo == "R" ? "Ração" : tipo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),

            if (tipo == "D") Text("Valor: R\$ $valor"),
            if (tipo == "R" && quantidade != null && quantidade!.isNotEmpty)
              Text("Quantidade: $quantidade"),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("Descrição: $descricao"),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text("Editar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2CD390),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text("Deletar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffD32C2F),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
