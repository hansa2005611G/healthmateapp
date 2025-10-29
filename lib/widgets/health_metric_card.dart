import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/theme/app_theme.dart';

/// Health metric card widget
/// Displays a single health metric (steps, calories, or water)
class HealthMetricCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int value;
  final String label;
  final String unit;
  final VoidCallback? onTap;
  final bool showIcon;

  const HealthMetricCard({
    Key? key,
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    required this.unit,
    this.onTap,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimensions.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Container(
          height: AppDimensions.metricCardHeight,
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              if (showIcon) ...[
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spacingS),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  ),
                  child: Icon(
                    icon,
                    size: AppDimensions.metricIconSize,
                    color: color,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingS),
              ],

              // Value
              Text(
                _formatValue(value),
                style: AppTheme.metricValueStyle.copyWith(
                  fontSize: showIcon ? 28 : 32,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Label
              Text(
                label,
                style: AppTheme.metricLabelStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
    }
  }

  /// Format large numbers with commas
  String _formatValue(int value) {
    if (value >= 1000) {
      return value.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }
    return value.toString();
  }


/// Compact health metric card (horizontal layout)
class CompactHealthMetricCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int value;
  final String label;
  final String unit;

  const CompactHealthMetricCard({
    Key? key,
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(
            icon,
            size: AppDimensions.iconL,
            color: color,
          ),
          const SizedBox(width: AppDimensions.spacingS),

          // Value and label
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_formatValue(value)} $unit',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatValue(int value) {
    if (value >= 1000) {
      return value.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }
    return value.toString();
  }
}

/// Pre-configured metric cards for specific types

class StepsMetricCard extends StatelessWidget {
  final int value;
  final VoidCallback? onTap;

  const StepsMetricCard({
    Key? key,
    required this.value,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HealthMetricCard(
      icon: Icons.directions_walk,
      color: AppColors.stepsColor,
      value: value,
      label: 'Steps',
      unit: 'steps',
      onTap: onTap,
    );
  }
}

class CaloriesMetricCard extends StatelessWidget {
  final int value;
  final VoidCallback? onTap;

  const CaloriesMetricCard({
    Key? key,
    required this.value,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HealthMetricCard(
      icon: Icons.local_fire_department,
      color: AppColors.caloriesColor,
      value: value,
      label: 'Calories',
      unit: 'kcal',
      onTap: onTap,
    );
  }
}

class WaterMetricCard extends StatelessWidget {
  final int value;
  final VoidCallback? onTap;

  const WaterMetricCard({
    Key? key,
    required this.value,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HealthMetricCard(
      icon: Icons.water_drop,
      color: AppColors.waterColor,
      value: value,
      label: 'Water',
      unit: 'ml',
      onTap: onTap,
    );
  }
}