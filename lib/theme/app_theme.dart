import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // THEME LOCK: dark — source: domain signal (radio/media app, spiritual worship context)
  // Scaffold.backgroundColor = AppTheme.backgroundDark — ALL screens

  // Brand colors — Misionera FM 94.9
  static const Color primary = Color(0xFF1A237E); // Deep navy blue
  static const Color primaryLight = Color(0xFF3949AB); // Lighter navy
  static const Color primaryContainer = Color(0xFF283593);
  static const Color accent = Color(0xFFC62828); // Rich red
  static const Color accentLight = Color(0xFFEF5350);
  static const Color gold = Color(0xFFF9A825); // Warm gold
  static const Color goldLight = Color(0xFFFFD54F);

  // Semantic colors
  static const Color success = Color(0xFF2D7A4F);
  static const Color warning = Color(0xFFB45309);
  static const Color error = Color(0xFFB91C1C);
  static const Color liveGreen = Color(0xFF00E676);

  // Dark theme surfaces
  static const Color surfaceDark = Color(0xFF0D1117);
  static const Color surfaceCard = Color(0xFF161B27);
  static const Color surfaceElevated = Color(0xFF1C2333);
  static const Color backgroundDark = Color(0xFF070B14);
  static const Color backgroundGradientStart = Color(0xFF0A0E1A);
  static const Color backgroundGradientMid = Color(0xFF0F1629);
  static const Color backgroundGradientEnd = Color(0xFF1A0A0A);

  // Glass surface
  static const Color glassSurface = Color(0x14FFFFFF); // 8% white
  static const Color glassBorder = Color(0x26FFFFFF); // 15% white

  // Text colors
  static const Color textPrimary = Color(0xFFF0F4FF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color textMuted = Color(0xFF607D8B);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primaryContainer,
      onPrimaryContainer: textPrimary,
      secondary: accent,
      onSecondary: Colors.white,
      surface: const Color(0xFFF5F7FF),
      onSurface: const Color(0xFF1A1A2E),
      error: error,
      onError: Colors.white,
      outline: const Color(0xFFCCCCCC),
      outlineVariant: const Color(0xFFEEEEEE),
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F7FF),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.light().textTheme,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primaryContainer,
      onPrimaryContainer: textPrimary,
      secondary: accent,
      onSecondary: Colors.white,
      tertiary: gold,
      onTertiary: const Color(0xFF1A1200),
      surface: surfaceCard,
      onSurface: textPrimary,
      error: const Color(0xFFCF6679),
      onError: Colors.white,
      outline: const Color(0xFF3A4060),
      outlineVariant: const Color(0xFF252A3D),
    ),
    scaffoldBackgroundColor: backgroundDark,
    textTheme: GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: textPrimary, displayColor: textPrimary),
    appBarTheme: AppBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
      iconTheme: const IconThemeData(color: textPrimary),
    ),
    iconTheme: const IconThemeData(color: textPrimary),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF252A3D),
      thickness: 1,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: gold,
      inactiveTrackColor: glassBorder,
      thumbColor: gold,
      overlayColor: gold.withAlpha(38),
      trackHeight: 3,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
    ),
  );
}
