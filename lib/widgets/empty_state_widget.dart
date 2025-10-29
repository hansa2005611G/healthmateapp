import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

/// Empty state widget
/// Displays when there's no data to show
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final Color? iconColor;

  const EmptyStateWidget({
    Key? key,
    required this.icon,
    required this.message,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppDimensions.emptyStateMaxWidth,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Icon(
                icon,
                size: AppDimensions.emptyStateIconSize,
                color: iconColor ?? AppColors.textDisabled,
              ),
              const SizedBox(height: AppDimensions.spacingL),

              // Main message
              Text(
                message,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),

              // Subtitle (optional)
              if (subtitle != null) ...[
                const SizedBox(height: AppDimensions.spacingS),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],

              // Action button (optional)
              if (actionText != null && onAction != null) ...[
                const SizedBox(height: AppDimensions.spacingL),
                ElevatedButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.add, size: AppDimensions.buttonIconSize),
                  label: Text(actionText!),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, AppDimensions.buttonHeight),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Pre-configured empty state for no records
class NoRecordsEmptyState extends StatelessWidget {
  final VoidCallback? onAddRecord;

  const NoRecordsEmptyState({
    Key? key,
    this.onAddRecord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.health_and_safety_outlined,
      message: 'No health records yet',
      subtitle: 'Start tracking your health journey today!',
      actionText: onAddRecord != null ? 'Add First Entry' : null,
      onAction: onAddRecord,
      iconColor: AppColors.primary,
    );
  }
}

/// Pre-configured empty state for no search results
class NoSearchResultsEmptyState extends StatelessWidget {
  final VoidCallback? onClearSearch;

  const NoSearchResultsEmptyState({
    Key? key,
    this.onClearSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      message: 'No records found',
      subtitle: 'Try selecting a different date',
      actionText: onClearSearch != null ? 'Clear Filter' : null,
      onAction: onClearSearch,
      iconColor: AppColors.textSecondary,
    );
  }
}

/// Pre-configured empty state for no data today
class NoDashboardDataEmptyState extends StatelessWidget {
  final VoidCallback? onAddEntry;

  const NoDashboardDataEmptyState({
    Key? key,
    this.onAddEntry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.calendar_today,
      message: 'No data for today',
      subtitle: 'Add your first health entry to see your daily summary',
      actionText: onAddEntry != null ? 'Add Entry' : null,
      onAction: onAddEntry,
      iconColor: AppColors.accent,
    );
  }
}