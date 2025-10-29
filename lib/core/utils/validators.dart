import '../constants/app_strings.dart';

/// Input validation utility class
/// Provides reusable validation functions for form inputs
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  // ==================== VALIDATION LIMITS ====================
  
  static const int stepsMin = 0;
  static const int stepsMax = 50000;
  
  static const int caloriesMin = 0;
  static const int caloriesMax = 10000;
  
  static const int waterMin = 0;
  static const int waterMax = 10000; // 10 liters in ml

  // ==================== GENERAL VALIDATORS ====================
  
  /// Validate required field (not null or empty)
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null 
          ? '$fieldName is required'
          : AppStrings.fieldRequired;
    }
    return null;
  }
  
  /// Validate number (must be a valid integer)
  static String? validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    final number = int.tryParse(value.trim());
    if (number == null) {
      return AppStrings.invalidNumber;
    }
    
    return null;
  }
  
  /// Validate positive number (greater than or equal to 0)
  static String? validatePositiveNumber(String? value) {
    // First check if it's a valid number
    final numberError = validateNumber(value);
    if (numberError != null) {
      return numberError;
    }
    
    final number = int.parse(value!.trim());
    if (number < 0) {
      return AppStrings.valueTooLow;
    }
    
    return null;
  }
  
  /// Validate number within range
  static String? validateNumberInRange(
    String? value,
    int min,
    int max, {
    String? fieldName,
  }) {
    // First check if it's a positive number
    final positiveError = validatePositiveNumber(value);
    if (positiveError != null) {
      return positiveError;
    }
    
    final number = int.parse(value!.trim());
    
    if (number < min) {
      return fieldName != null
          ? '$fieldName must be at least $min'
          : 'Value must be at least $min';
    }
    
    if (number > max) {
      return fieldName != null
          ? '$fieldName must not exceed $max'
          : 'Value must not exceed $max';
    }
    
    return null;
  }

  // ==================== HEALTH METRIC VALIDATORS ====================
  
  /// Validate steps input
  static String? validateSteps(String? value) {
    // Check required
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    // Check if valid number
    final number = int.tryParse(value.trim());
    if (number == null) {
      return AppStrings.invalidNumber;
    }
    
    // Check range
    if (number < stepsMin || number > stepsMax) {
      return AppStrings.stepsValidation;
    }
    
    return null;
  }
  
  /// Validate calories input
  static String? validateCalories(String? value) {
    // Check required
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    // Check if valid number
    final number = int.tryParse(value.trim());
    if (number == null) {
      return AppStrings.invalidNumber;
    }
    
    // Check range
    if (number < caloriesMin || number > caloriesMax) {
      return AppStrings.caloriesValidation;
    }
    
    return null;
  }
  
  /// Validate water input
  static String? validateWater(String? value) {
    // Check required
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    // Check if valid number
    final number = int.tryParse(value.trim());
    if (number == null) {
      return AppStrings.invalidNumber;
    }
    
    // Check range
    if (number < waterMin || number > waterMax) {
      return AppStrings.waterValidation;
    }
    
    return null;
  }

  // ==================== HELPER METHODS ====================
  
  /// Get validator function for specific health metric
  static String? Function(String?)? getMetricValidator(String metricType) {
    switch (metricType.toLowerCase()) {
      case 'steps':
        return validateSteps;
      case 'calories':
        return validateCalories;
      case 'water':
        return validateWater;
      default:
        return validateRequired;
    }
  }
  
  /// Check if a value is within reasonable range for a metric
  static bool isReasonableValue(String metricType, int value) {
    switch (metricType.toLowerCase()) {
      case 'steps':
        return value >= stepsMin && value <= stepsMax;
      case 'calories':
        return value >= caloriesMin && value <= caloriesMax;
      case 'water':
        return value >= waterMin && value <= waterMax;
      default:
        return true;
    }
  }
  
  /// Parse and validate integer from string
  static int? parseAndValidateInt(String? value, int min, int max) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    
    final number = int.tryParse(value.trim());
    if (number == null) {
      return null;
    }
    
    if (number < min || number > max) {
      return null;
    }
    
    return number;
  }
  
  /// Get range limits for a specific metric
  static ({int min, int max}) getMetricRange(String metricType) {
    switch (metricType.toLowerCase()) {
      case 'steps':
        return (min: stepsMin, max: stepsMax);
      case 'calories':
        return (min: caloriesMin, max: caloriesMax);
      case 'water':
        return (min: waterMin, max: waterMax);
      default:
        return (min: 0, max: 999999);
    }
  }

  // ==================== SANITIZATION ====================
  
  /// Remove non-numeric characters from string
  static String sanitizeNumericInput(String input) {
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }
  
  /// Trim and clean whitespace from input
  static String sanitizeInput(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}