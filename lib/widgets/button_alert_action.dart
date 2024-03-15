import 'package:flutter/material.dart';
import '../common/theme.dart';

class ButtonAlertActionWidget extends StatelessWidget {
  final Color backgroundColor;
  final Color colorBorderSide;
  final Function() onPressed;
  final String text;
  final Color colorText;
  final bool isBorderSide;

  const ButtonAlertActionWidget({
    super.key,
    required this.backgroundColor,
    required this.colorBorderSide,
    required this.onPressed,
    required this.text,
    required this.colorText,
    this.isBorderSide = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          side: isBorderSide
              ? BorderSide(color: colorBorderSide)
              : BorderSide.none,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: primaryTextStyle.copyWith(
          color: colorText,
        ),
      ),
    );
  }
}
