import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DonationTypeSelector extends StatelessWidget {
   final String selectedType;
  final ValueChanged<String> onChanged;

  const DonationTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildButton("D", "Dinheiro", Icons.savings_outlined),
        const SizedBox(width: 20),
        _buildButton("R", "Ração", Icons.inventory_2_outlined),
      ],
    );
  }

  Widget _buildButton(String type, String label, IconData icon) {
    return Expanded(
      child: TextButton.icon(
        onPressed: () => onChanged(type),
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 16)),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(15),
          backgroundColor:
              selectedType == type ? AppColors.primary : Colors.grey[300],
          foregroundColor: selectedType == type ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}