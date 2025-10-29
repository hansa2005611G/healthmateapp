import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/utils/date_helper.dart';

/// Date picker field widget
/// Displays a read-only field that opens a date picker dialog
class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime selectedDate;
  final void Function(DateTime) onDateChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;
  final String? Function(DateTime?)? validator;

  const DatePickerField({
    Key? key,
    required this.label,
    required this.selectedDate,
    required this.onDateChanged,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveFirstDate = firstDate ?? 
        DateTime.now().subtract(const Duration(days: 365));
    final effectiveLastDate = lastDate ?? 
        DateTime.now().add(const Duration(days: 1));

    return TextFormField(
      readOnly: true,
      enabled: enabled,
      controller: TextEditingController(
        text: DateHelper.toFullDateString(selectedDate),
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(
          Icons.calendar_today,
          color: AppColors.primary,
          size: AppDimensions.iconM,
        ),
        suffixIcon: enabled
            ? IconButton(
                icon: const Icon(
                  Icons.edit_calendar,
                  color: AppColors.primary,
                  size: AppDimensions.iconM,
                ),
                onPressed: () => _selectDate(
                  context,
                  effectiveFirstDate,
                  effectiveLastDate,
                ),
              )
            : null,
        filled: true,
        fillColor: enabled ? AppColors.surface : AppColors.backgroundLight,
      ),
      onTap: enabled
          ? () => _selectDate(
                context,
                effectiveFirstDate,
                effectiveLastDate,
              )
          : null,
      validator: validator != null
          ? (value) => validator!(selectedDate)
          : null,
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime firstDate,
    DateTime lastDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textOnPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      onDateChanged(picked);
    }
  }
}

/// Compact date picker field (smaller, for inline use)
class CompactDatePickerField extends StatelessWidget {
  final DateTime selectedDate;
  final void Function(DateTime) onDateChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CompactDatePickerField({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveFirstDate = firstDate ?? 
        DateTime.now().subtract(const Duration(days: 365));
    final effectiveLastDate = lastDate ?? 
        DateTime.now().add(const Duration(days: 1));

    return InkWell(
      onTap: () => _selectDate(
        context,
        effectiveFirstDate,
        effectiveLastDate,
      ),
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today,
              color: AppColors.primary,
              size: AppDimensions.iconM,
            ),
            const SizedBox(width: AppDimensions.spacingS),
            Text(
              DateHelper.getDisplayString(selectedDate),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(width: AppDimensions.spacingXS),
            const Icon(
              Icons.arrow_drop_down,
              color: AppColors.primary,
              size: AppDimensions.iconM,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime firstDate,
    DateTime lastDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textOnPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      onDateChanged(picked);
    }
  }
}