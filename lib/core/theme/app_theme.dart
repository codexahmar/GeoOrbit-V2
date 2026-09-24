import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  // Material 3 Dark Expressive Theme
  static ThemeData get materialDarkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;
    final outfitTheme = GoogleFonts.outfitTextTheme(baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.voidBlack,
      primaryColor: AppColors.neonCyan,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonCyan,
        onPrimary: AppColors.voidBlack,
        primaryContainer: Color(0xFF141A26),
        onPrimaryContainer: AppColors.neonCyan,
        secondary: AppColors.neonPurple,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFF201630),
        onSecondaryContainer: Color(0xFFE9D5FF),
        tertiary: AppColors.neonPink,
        onTertiary: Colors.white,
        surface: AppColors.cardDark,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: Color(0xFF1A1C24),
        outline: AppColors.glassBorder,
        outlineVariant: AppColors.glassBorderSubtle,
      ),
      textTheme: outfitTheme.copyWith(
        displayLarge: outfitTheme.displayLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.0,
        ),
        displayMedium: outfitTheme.displayMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineMedium: outfitTheme.headlineMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: outfitTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        titleMedium: outfitTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: outfitTheme.bodyLarge?.copyWith(
          color: AppColors.textPrimary,
          letterSpacing: 0.15,
        ),
        bodyMedium: outfitTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
        labelLarge: outfitTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.glassBorder, width: 0.8),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.primaryDark,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          side: BorderSide(color: AppColors.glassBorder, width: 1),
        ),
        dragHandleColor: AppColors.textTertiary,
        showDragHandle: true,
      ),
    );
  }

  // Cupertino Dark Native Theme (Apple Human Interface Guidelines)
  static CupertinoThemeData get cupertinoDarkTheme {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: CupertinoColors.activeBlue,
      primaryContrastingColor: CupertinoColors.black,
      barBackgroundColor: Color(0xCC000000),
      scaffoldBackgroundColor: CupertinoColors.black,
      textTheme: CupertinoTextThemeData(
        primaryColor: CupertinoColors.white,
        textStyle: TextStyle(
          color: CupertinoColors.white,
          fontSize: 15,
          fontFamily: '.SF Pro Text',
          letterSpacing: -0.2,
        ),
        actionTextStyle: TextStyle(
          color: CupertinoColors.activeBlue,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: '.SF Pro Text',
        ),
        navTitleTextStyle: TextStyle(
          color: CupertinoColors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: '.SF Pro Display',
          letterSpacing: -0.4,
        ),
      ),
    );
  }
}
