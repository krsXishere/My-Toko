import 'package:flutter/material.dart';

class CustomDropdownWidget extends StatelessWidget {
  final List<DropdownMenuItem> items;
  final Function(dynamic value) onChanged;
  const CustomDropdownWidget({
    super.key,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: DropdownButton(
        onChanged: onChanged,
        items: items,
      ),
    );
  }
}
