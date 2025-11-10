import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_helper.dart';
import '../../../widgets/health_metric_card.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/custom_button.dart';
import '../../health_records/viewmodels/health_record_viewmodel.dart';
import '../../health_records/views/records_list_screen.dart';

/// Dashboard Screen
/// Shows today's health summary with quick stats
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthRecordViewModel>().refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboardTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HealthRecordViewModel>().refreshData();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<HealthRecordViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && !viewModel.hasRecords) {
            return const LoadingIndicator(
              message: AppStrings.loadingRecords,
            );
          }

          if (viewModel.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.screenPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: AppDimensions.iconXXL,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: AppDimensions.spacingM),
                    Text(
                      viewModel.errorMessage ?? AppStrings.errorGeneric,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppDimensions.spacingL),
                    PrimaryButton(
                      text: 'Retry',
                      onPressed: () => viewModel.refreshData(),
                      icon: Icons.refresh,
                    ),
                  ],
                ),
              ),
            );
          }

          // Empty state - REMOVED the onAddEntry callback
          if (!viewModel.hasTodayData) {
            return EmptyStateWidget(
              icon: Icons.calendar_today,
              message: 'No data for today',
              subtitle: 'Add your first health entry to see your daily summary',
              iconColor: AppColors.accent,
            );
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.refreshData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateHeader(context),
                  const SizedBox(height: AppDimensions.spacingL),

                  Text(
                    AppStrings.todaySummary,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: AppDimensions.spacingM),

                  _buildMetricsGrid(viewModel),
                  const SizedBox(height: AppDimensions.spacingL),

                  if (viewModel.hasRecords) ...[
                    PrimaryButton(
                      text: AppStrings.viewAllButton,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecordsListScreen(),
                          ),
                        );
                      },
                      icon: Icons.list,
                    ),
                  ],

                  const SizedBox(height: AppDimensions.spacingL),

                  _buildQuickStats(context, viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            color: AppColors.textOnPrimary,
            size: AppDimensions.iconL,
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateHelper.toDayDateString(DateTime.now()),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  'Your Health Summary',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textOnPrimary.withOpacity(0.8),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(HealthRecordViewModel viewModel) {
    return GridView.count(
      crossAxisCount: AppDimensions.gridCrossAxisCount,
      crossAxisSpacing: AppDimensions.gridSpacing,
      mainAxisSpacing: AppDimensions.gridSpacing,
      childAspectRatio: AppDimensions.gridChildAspectRatio,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        StepsMetricCard(value: viewModel.todaySteps),
        CaloriesMetricCard(value: viewModel.todayCalories),
        WaterMetricCard(value: viewModel.todayWater),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, HealthRecordViewModel viewModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.insights,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Text(
                  'Quick Stats',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingM),
            _buildStatRow(
              context,
              icon: Icons.check_circle_outline,
              label: 'Total Records',
              value: '${viewModel.recordCount}',
            ),
            const Divider(height: AppDimensions.spacingL),
            _buildStatRow(
              context,
              icon: Icons.trending_up,
              label: 'Steps Goal',
              value: viewModel.todaySteps >= 10000 ? 'Achieved! 🎉' : '${(viewModel.todaySteps / 10000 * 100).toInt()}%',
            ),
            const Divider(height: AppDimensions.spacingL),
            _buildStatRow(
              context,
              icon: Icons.water_drop,
              label: 'Water Goal',
              value: viewModel.todayWater >= 2000 ? 'Achieved! 💧' : '${(viewModel.todayWater / 2000 * 100).toInt()}%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppDimensions.iconM,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
        ),
      ],
    );
  }
}