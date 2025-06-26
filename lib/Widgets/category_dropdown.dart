import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final Function(String) onChanged;

  CategoryDropdown({required this.onChanged});

  final List<String> categories = [
    'All',
    'Electronics',
    'Fashion',
    'Home',
    'Toys'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: DropdownButtonFormField<String>(
        value: 'All',
        items: categories
            .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
            .toList(),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
        decoration: InputDecoration(
          labelText: 'Select Category',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
