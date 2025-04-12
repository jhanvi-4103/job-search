import 'package:flutter/material.dart';

class SearchFilterBar extends StatelessWidget {
  final String searchQuery;
  final String selectedLocation;
  final List<String> locations;
  final Function(String) onSearchChanged;
  final Function(String) onLocationChanged;

  const SearchFilterBar({
    super.key,
    required this.searchQuery,
    required this.selectedLocation,
    required this.locations,
    required this.onSearchChanged,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: "Search jobs...",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: selectedLocation,
          items:
              locations.map((location) {
                return DropdownMenuItem(value: location, child: Text(location));
              }).toList(),
          onChanged: (value) {
            if (value != null) onLocationChanged(value);
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Select Location",
          ),
        ),
      ],
    );
  }
}