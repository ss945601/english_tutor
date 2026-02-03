import 'package:flutter/material.dart';

class AppTheme {
  static const Color _seedColor = Color(0xFF4F46E5); // Indigo
  static const Color _appBackground = Color(0xFF0B1220);
  static const Color _cardBackground = Color(0xFF0E1626);
  static const Color _dialogBackground = Color(0xFF0E1626);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      // Force a consistent dark app background for clearer, modern look
      scaffoldBackgroundColor: _appBackground,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: _appBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      // Typography: clear, larger body text and lighter colors for readability on dark backgrounds
      textTheme: TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white60),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.primary),
      ),

      // Icons: light icons for dark backgrounds
      iconTheme: const IconThemeData(color: Colors.white70, size: 20),

      // Cards: gentle elevation, roomy shape and comfortable margins
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: _cardBackground,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
      ),

      // Dialogs: larger radius and subtle elevation for focus
      dialogTheme: DialogThemeData(
        backgroundColor: _dialogBackground,
        elevation: 6,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.center,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(44, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(44, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: colorScheme.outline),
          foregroundColor: colorScheme.primary,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(44, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          foregroundColor: colorScheme.primary,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.primaryContainer,
        selectedColor: colorScheme.primary,
        disabledColor: colorScheme.surfaceVariant,
        labelStyle: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );

    return light().copyWith(
      colorScheme: colorScheme,
      // Keep the forced dark background in dark mode as well
      scaffoldBackgroundColor: _appBackground,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: _appBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardColor: colorScheme.surfaceContainerHighest,
      // Improve contrast for dark mode: ensure text and icons are readable against darker surfaces
      textTheme: light().textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white70, size: 20),
      primaryIconTheme: const IconThemeData(color: Colors.white),
    );
  }
}
