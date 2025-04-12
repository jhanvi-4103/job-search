import 'package:flutter/material.dart';

class DynamicListSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final TextEditingController controller;
  final VoidCallback onAdd;
  final Function(int) onRemove;

  const DynamicListSection({
    super.key,
    required this.title,
    required this.items,
    required this.controller,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter $title",
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAdd,
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: List.generate(
            items.length,
            (index) => Chip(
              label: Text(items[index]),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => onRemove(index),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
