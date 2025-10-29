import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

/// Health input field widget
/// Custom text field for entering health metric values
class HealthInputField extends StatelessWidget {
  final String label;
  final String hint;
  final String unit;
  final IconData icon;
  final Color iconColor;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final int? maxValue;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;

  const HealthInputField({
    Key? key,
    required this.label,
    required this.hint,
    required this.unit,
    required this.icon,
    required this.iconColor,
    required this.controller,
    this.validator,
    this.enabled = true,
    this.maxValue,
    this.textInputAction,
    this.focusNode,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      keyboardType: TextInputType.number,
      textInputAction: textInputAction ?? TextInputAction.next,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        if (maxValue != null)
          _MaxValueInputFormatter(maxValue!),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: unit,
        suffixStyle: TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Container(
          padding: const EdgeInsets.all(AppDimensions.spacingS),
          child: Icon(
            icon,
            color: iconColor,
            size: AppDimensions.iconM,
          ),
        ),
        filled: true,
        fillColor: enabled ? AppColors.surface : AppColors.backgroundLight,
        errorMaxLines: 2,
      ),
      validator: validator,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
    );
  }
}

/// Input formatter to restrict maximum value
class _MaxValueInputFormatter extends TextInputFormatter {
  final int maxValue;

  _MaxValueInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final value = int.tryParse(newValue.text);
    if (value == null || value > maxValue) {
      return oldValue;
    }

    return newValue;
  }
}

/// Pre-configured input fields for specific metrics

class StepsInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const StepsInputField({
    Key? key,
    required this.controller,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HealthInputField(
      label: 'Steps',
      hint: 'Enter steps walked',
      unit: 'steps',
      icon: Icons.directions_walk,
      iconColor: AppColors.stepsColor,
      controller: controller,
      validator: validator,
      maxValue: 50000,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}

class CaloriesInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const CaloriesInputField({
    Key? key,
    required this.controller,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HealthInputField(
      label: 'Calories',
      hint: 'Enter calories burned',
      unit: 'kcal',
      icon: Icons.local_fire_department,
      iconColor: AppColors.caloriesColor,
      controller: controller,
      validator: validator,
      maxValue: 10000,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}

class WaterInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const WaterInputField({
    Key? key,
    required this.controller,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HealthInputField(
      label: 'Water',
      hint: 'Enter water intake',
      unit: 'ml',
      icon: Icons.water_drop,
      iconColor: AppColors.waterColor,
      controller: controller,
      validator: validator,
      maxValue: 10000,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}