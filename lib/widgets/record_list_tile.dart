import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/utils/date_helper.dart';
import '../data/models/health_record_model.dart';

/// Record list tile widget
/// Displays a single health record in a list
class RecordListTile extends StatelessWidget {
  final HealthRecord record;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool showDate;

  const RecordListTile({
    Key? key,
    required this.record,
    required this.onEdit,
    required this.onDelete,
    this.showDate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.listItemSpacing),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date header
              if (showDate) ...[
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: AppDimensions.iconM,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppDimensions.spacingXS),
                    Expanded(
                      child: Text(
                        DateHelper.getRelativeDateString(record.dateTime),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                      ),
                    ),
                    // Action buttons
                    IconButton(
                      icon: const Icon(Icons.edit),
                      iconSize: AppDimensions.iconM,
                      color: AppColors.primary,
                      onPressed: onEdit,
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      iconSize: AppDimensions.iconM,
                      color: AppColors.error,
                      onPressed: onDelete,
                      tooltip: 'Delete',
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingM),
              ],

              // Metrics
              _buildMetricRow(
                context: context,
                icon: Icons.directions_walk,
                color: AppColors.stepsColor,
                value: record.steps,
                unit: 'steps',
              ),
              const SizedBox(height: AppDimensions.spacingS),
              _buildMetricRow(
                context: context,
                icon: Icons.local_fire_department,
                color: AppColors.caloriesColor,
                value: record.calories,
                unit: 'kcal',
              ),
              const SizedBox(height: AppDimensions.spacingS),
              _buildMetricRow(
                context: context,
                icon: Icons.water_drop,
                color: AppColors.waterColor,
                value: record.water,
                unit: 'ml',
              ),

              // Action buttons (if date not shown)
              if (!showDate) ...[
                const SizedBox(height: AppDimensions.spacingM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: AppDimensions.iconM),
                      label: const Text('Edit'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingS),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, size: AppDimensions.iconM),
                      label: const Text('Delete'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricRow({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required int value,
    required String unit,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingXS),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Icon(
            icon,
            size: AppDimensions.listIconSize,
            color: color,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: Text(
            '${_formatValue(value)} $unit',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
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

/// Compact record list tile (minimal design)
class CompactRecordListTile extends StatelessWidget {
  final HealthRecord record;
  final VoidCallback onTap;

  const CompactRecordListTile({
    Key? key,
    required this.record,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.listItemSpacing),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: const Icon(
            Icons.health_and_safety,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          DateHelper.getDisplayString(record.dateTime),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${record.steps} steps • ${record.calories} kcal • ${record.water} ml',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}