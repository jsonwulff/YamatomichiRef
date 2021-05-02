import 'package:flutter/material.dart';

class CustomChipsSelector extends StatelessWidget {
  final List<String> categories;
  final List<bool> selectedCategories;
  final void Function(bool selected, int index) onSelected;

  CustomChipsSelector({
    Key key,
    this.categories,
    this.selectedCategories,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildCategoriesSelector() {
      List<Widget> chips = [];

      for (int i = 0; i < categories.length; i++) {
        FilterChip filterChip = FilterChip(
          showCheckmark: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedColor: Theme.of(context).scaffoldBackgroundColor,
          label: Text(
            categories[i],
            style: TextStyle(
                color: selectedCategories[i] ? Colors.blue : Color(0xFF818181)),
          ),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w400,
          ),
          selected: selectedCategories[i],
          onSelected: (bool selected) {
            onSelected(selected, i);
          },
        );
        chips.add(filterChip);
      }
      return chips;
    }

    return Wrap(
      direction: Axis.horizontal,
      spacing: 6.0,
      runSpacing: 6.0,
      children: _buildCategoriesSelector(),
    );
  }
}
