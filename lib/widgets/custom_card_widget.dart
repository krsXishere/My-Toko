import 'package:flutter/material.dart';

class CustomCardWidget extends StatelessWidget {
  final Color color;
  const CustomCardWidget({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
