import 'package:flutter/material.dart';

class StackChip extends StatelessWidget {
  final String label;
  final VoidCallback? onDeleted;

  const StackChip({super.key, required this.label, this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: onDeleted,
    );
  }
}
