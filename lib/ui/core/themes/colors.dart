import 'package:flutter/material.dart';

abstract final class AppColors {
  static const black = Color(0xFF121212);
  static const white = Color(0xFFFCFAFA);
  static const primary = Color(0xFF0081C9);
  static const secondary = Color(0xFF86E5FF);
  static const tertiary = Color(0xFF86E5FF);
  static const accent = Color(0xFFFFC93C);
  static const grey1 = Color(0xFFF2F2F2);
  static const grey2 = Color(0xFF4D4D4D);
  static const grey3 = Color(0xFFA4A4A4);
  static const whiteTransparent = Color(0x4DFFFFFF);
  static const blackTransparent = Color(0x4D000000);

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: white,
    secondary: secondary,
    onSecondary: black,
    tertiary: tertiary,
    onTertiary: black,
    error: Colors.red,
    onError: white,
    surface: grey1,
    onSurface: black,
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: white,
    secondary: secondary,
    onSecondary: black,
    tertiary: tertiary,
    onTertiary: black,
    error: Colors.red,
    onError: white,
    surface: grey2,
    onSurface: white,
  );
}
