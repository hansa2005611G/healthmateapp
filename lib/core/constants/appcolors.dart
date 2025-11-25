// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// App-wide color constants following Material Design principles
/// and health/medical theme aesthetics
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ==================== PRIMARY THEME COLORS ====================
  
  /// Main brand color - Medical/Health blue
  static const Color primary = Color(0xFF2196F3);
  
  /// Darker shade of primary color
  static const Color primaryDark = Color(0xFF1976D2);
  
  /// Lighter shade of primary color
  static const Color primaryLight = Color(0xFF64B5F6);
  
  /// Accent color - Health/Vitality green
  static const Color accent = Color(0xFF4CAF50);
  
  /// Accent color dark shade
  static const Color accentDark = Color(0xFF388E3C);

  // ==================== METRIC-SPECIFIC COLORS ====================
  
  /// Steps metric color - Energy/Movement orange
  static const Color stepsColor = Color(0xFFFF9800);
  
  /// Calories metric color - Fire/Burn red
  static const Color caloriesColor = Color(0xFFF44336);
  
  /// Water metric color - Water theme blue
  static const Color waterColor = Color(0xFF2196F3);

  // ==================== SEMANTIC COLORS ====================
  
  /// Success state color
  static const Color success = Color(0xFF4CAF50);
  
  /// Error state color
  static const Color error = Color(0xFFF44336);
  
  /// Warning state color
  static const Color warning = Color(0xFFFF9800);
  
  /// Info state color
  static const Color info = Color(0xFF2196F3);

  // ==================== BACKGROUND COLORS ====================
  
  /// Main app background
  static const Color background = Color(0xFFF5F5F5);
  
  /// Card/surface background
  static const Color surface = Color(0xFFFFFFFF);
  
  /// Light grey background for sections
  static const Color backgroundLight = Color(0xFFFAFAFA);

  // ==================== TEXT COLORS ====================
  
  /// Primary text color - Dark grey
  static const Color textPrimary = Color(0xFF212121);
  
  /// Secondary text color - Medium grey
  static const Color textSecondary = Color(0xFF757575);
  
  /// Disabled text color - Light grey
  static const Color textDisabled = Color(0xFFBDBDBD);
  
  /// Text on primary color backgrounds
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ==================== BORDER & DIVIDER COLORS ====================
  
  /// Default border color
  static const Color border = Color(0xFFE0E0E0);
  
  /// Divider color
  static const Color divider = Color(0xFFBDBDBD);
  
  /// Focus/Active border color
  static const Color borderActive = primary;

  // ==================== SHADOW COLORS ====================
  
  /// Light shadow for cards
  static const Color shadowLight = Color(0x1A000000);
  
  /// Medium shadow for elevated elements
  static const Color shadowMedium = Color(0x33000000);

  // ==================== GRADIENT COLORS ====================
  
  /// Gradient for primary buttons/elements
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Gradient for success elements
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== METRIC COLOR GETTERS ====================
  
  /// Get color for specific health metric type
  static Color getMetricColor(String metricType) {
    switch (metricType.toLowerCase()) {
      case 'steps':
        return stepsColor;
      case 'calories':
        return caloriesColor;
      case 'water':
        return waterColor;
      default:
        return primary;
    }
  }
  
  /// Get lighter version of metric color (for backgrounds)
  static Color getMetricColorLight(String metricType) {
    switch (metricType.toLowerCase()) {
      case 'steps':
        return stepsColor.withOpacity(0.1);
      case 'calories':
        return caloriesColor.withOpacity(0.1);
      case 'water':
        return waterColor.withOpacity(0.1);
      default:
        return primary.withOpacity(0.1);
    }
  }
}