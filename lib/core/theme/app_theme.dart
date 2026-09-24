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
        primaryContainer: Color(0xFF0C243B),
        onPrimaryContainer: AppColors.neonCyan,
        secondary: AppColors.neonPurple,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFF24143D),
        onSecondaryContainer: Color(0xFFE9D5FF),
        tertiary: AppColors.neonPink,
        onTertiary: Colors.white,
        surface: AppColors.cardDark,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: Color(0xFF16203D),
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
        color: AppColors.cardDark.withOpacity(0.85),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.glassBorder, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.glassSurface,
        disabledColor: Colors.transparent,
        selectedColor: AppColors.neonCyan.withOpacity(0.2),
        secondarySelectedColor: AppColors.neonPurple.withOpacity(0.2),
        labelStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
        secondaryLabelStyle: const TextStyle(color: AppColors.neonPurple, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.glassBorder, width: 0.8),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.neonCyan,
        inactiveTrackColor: AppColors.glassBorder,
        thumbColor: AppColors.neonCyan,
        overlayColor: AppColors.neonCyan.withOpacity(0.18),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.primaryDark,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
      barBackgroundColor: Color(0x99000000),
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
        tabLabelTextStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          fontFamily: '.SF Pro Text',
        ),
        navTitleTextStyle: TextStyle(
          color: CupertinoColors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: '.SF Pro Display',
          letterSpacing: -0.4,
        ),
        navLargeTitleTextStyle: TextStyle(
          color: CupertinoColors.white,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          fontFamily: '.SF Pro Display',
          letterSpacing: 0.3,
        ),
        pickerTextStyle: TextStyle(
          color: CupertinoColors.white,
          fontSize: 21,
          fontFamily: '.SF Pro Display',
        ),
        dateTimePickerTextStyle: TextStyle(
          color: CupertinoColors.white,
          fontSize: 21,
          fontFamily: '.SF Pro Display',
        ),
      ),
    );
  }
}
