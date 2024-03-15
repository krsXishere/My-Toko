import 'package:flutter/material.dart';
import '../common/theme.dart';

class DrawerItem extends StatelessWidget {
  final String? text;
  final Function()? onTap;
  final Icon icon;

  const DrawerItem({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        focusColor: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        leading: icon,
        title: Text(
          text.toString(),
          style: primaryTextStyle.copyWith(
            fontWeight: regular,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}