import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

double defaultPadding = 20;
double defaultBorderRadius = 15;

// Color primaryGreen = const Color(0XFF66806A);
Color primaryPurple = const Color(0XFFBA68C8);
Color secodaryPurple = const Color.fromARGB(255, 134, 59, 147);
Color backgroundColor = const Color.fromARGB(255, 45, 43, 43);
Color white = const Color(0xffffffff);
Color black = const Color(0xff000000);
Color grey = const Color(0xff808080);
Color greySecond = const Color(0xff797979);
Color greyThird = const Color(0xff767676);
Color unClickColor = const Color(0XFFD9D9D9);
Color appbarColor = primaryPurple;

TextStyle primaryTextStyle = GoogleFonts.poppins(
  color: black,
);

TextStyle secondaryTextStyle = GoogleFonts.poppins(
  color: unClickColor,
);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
