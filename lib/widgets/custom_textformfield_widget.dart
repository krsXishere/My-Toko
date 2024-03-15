import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common/theme.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final bool isNumber;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.textInputType,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: primaryTextStyle,
      cursorColor: primaryPurple,
      cursorHeight: 20,
      cursorWidth: 3,
      controller: controller,
      keyboardType: textInputType,
      inputFormatters: [
        isNumber
            ? FilteringTextInputFormatter.allow(
                RegExp(r'[0-9]'),
              )
            : FilteringTextInputFormatter.allow(
                RegExp(r'[0-9A-Za-z -]'),
              ),
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        filled: false,
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: primaryTextStyle.copyWith(
          fontWeight: regular,
          color: grey,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: unClickColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(
            color: unClickColor,
          ),
        ),
      ),
    );
  }
}
