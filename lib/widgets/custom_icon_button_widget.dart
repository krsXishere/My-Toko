import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomIconButtonWidget extends StatelessWidget {
  Function()? onTap;
  Color color;
  IconData icon;

  CustomIconButtonWidget({
    super.key,
    required this.onTap,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: color,
      ),
    );
  }
}
