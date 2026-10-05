import 'package:flutter/material.dart';

class PortfolioColors {
  const PortfolioColors._();

  static const Color primary = Color(0xFF25D99A);
  static const Color primaryDark = Color(0xFF12AA76);
  static const Color secondary = Color(0xFF58A6FF);

  static const Color darkBackground = Color(0xFF07111F);
  static const Color darkBackgroundSoft = Color(0xFF0C1828);
  static const Color darkSurface = Color(0xD10F1E31);
  static const Color darkSurfaceSolid = Color(0xFF0F1E31);
  static const Color darkSurfaceLight = Color(0xFF142840);
  static const Color darkText = Color(0xFFF5F7FB);
  static const Color darkMuted = Color(0xFFAAB6C6);

  static const Color lightBackground = Color(0xFFF4F7FB);
  static const Color lightBackgroundSoft = Color(0xFFEAF0F7);
  static const Color lightSurface = Color(0xE6FFFFFF);
  static const Color lightSurfaceSolid = Color(0xFFFFFFFF);
  static const Color lightSurfaceLight = Color(0xFFF1F5F9);
  static const Color lightText = Color(0xFF122033);
  static const Color lightMuted = Color(0xFF5F6F82);
}

class PortfolioPalette {
  const PortfolioPalette({required this.isLight});

  final bool isLight;

  Color get background => isLight
      ? PortfolioColors.lightBackground
      : PortfolioColors.darkBackground;

  Color get backgroundSoft => isLight
      ? PortfolioColors.lightBackgroundSoft
      : PortfolioColors.darkBackgroundSoft;

  Color get surface =>
      isLight ? PortfolioColors.lightSurface : PortfolioColors.darkSurface;

  Color get surfaceSolid => isLight
      ? PortfolioColors.lightSurfaceSolid
      : PortfolioColors.darkSurfaceSolid;

  Color get surfaceLight => isLight
      ? PortfolioColors.lightSurfaceLight
      : PortfolioColors.darkSurfaceLight;

  Color get text =>
      isLight ? PortfolioColors.lightText : PortfolioColors.darkText;

  Color get muted =>
      isLight ? PortfolioColors.lightMuted : PortfolioColors.darkMuted;

  Color get border => isLight
      ? const Color.fromRGBO(15, 23, 42, 0.12)
      : const Color.fromRGBO(255, 255, 255, 0.10);

  List<BoxShadow> get shadow => [
        BoxShadow(
          color: isLight
              ? const Color.fromRGBO(38, 57, 77, 0.12)
              : const Color.fromRGBO(0, 0, 0, 0.28),
          blurRadius: 65,
          offset: const Offset(0, 22),
        ),
      ];
}

ThemeData buildPortfolioTheme({required bool isLight}) {
  final palette = PortfolioPalette(isLight: isLight);

  return ThemeData(
    brightness: isLight ? Brightness.light : Brightness.dark,
    scaffoldBackgroundColor: palette.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: PortfolioColors.primary,
      brightness: isLight ? Brightness.light : Brightness.dark,
      primary: PortfolioColors.primary,
      secondary: PortfolioColors.secondary,
      surface: palette.surfaceSolid,
    ),
    fontFamily: 'Inter',
    textTheme: ThemeData(
      brightness: isLight ? Brightness.light : Brightness.dark,
    ).textTheme.apply(
          bodyColor: palette.text,
          displayColor: palette.text,
          fontFamily: 'Inter',
        ),
    useMaterial3: true,
  );
}
