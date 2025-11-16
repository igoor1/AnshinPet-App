import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;

  final List<T> items;

  final String Function(T)? itemLabel;

  final dynamic Function(T)? itemValue;

  final Function(dynamic)? onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    this.itemLabel,
    this.itemValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: items.map((item) {
        final displayedLabel =
            itemLabel != null ? itemLabel!(item) : item.toString();

        final value =
            itemValue != null ? itemValue!(item) : item;

        return DropdownMenuItem(
          value: value,
          child: Text(displayedLabel),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
