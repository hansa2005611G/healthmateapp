import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/utils/user_preferences.dart';
import '../../../widgets/health_metric_card.dart';
import '../../../widgets/loading_indicator.dart';
import '../../health_records/viewmodels/health_record_viewmodel.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserName();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthRecordViewModel>().refreshData();
    });
  }

  Future<void> _loadUserName() async {
    final name = await UserPreferences.getUserName();
    if (mounted) {
      setState(() {
        _userName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboardTitle),
        automaticallyImplyLeading: false,
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
            return const LoadingIndicator(message: AppStrings.loadingRecords);
          }

          if (viewModel.hasError) {
            return _buildErrorState(viewModel);
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.refreshData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeHeader(context),
                  const SizedBox(height: AppDimensions.spacingL),

                  if (viewModel.hasTodayData) ...[
                    Text(
                      AppStrings.todaySummary,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppDimensions.spacingM),
                    _buildMetricsGrid(viewModel),
                    const SizedBox(height: AppDimensions.spacingL),
                  ] else ...[
                    _buildNoDataCard(),
                    const SizedBox(height: AppDimensions.spacingL),
                  ],

                  if (viewModel.hasRecords) ...[
                    _buildQuickStats(context, viewModel),
                    const SizedBox(height: AppDimensions.spacingL),
                  ],

                  _buildHealthTips(context),
                  const SizedBox(height: AppDimensions.spacingXXL), // Extra padding at bottom
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting = 'Good Morning';
    IconData greetingIcon = Icons.wb_sunny;

    if (hour >= 12 && hour < 17) {
      greeting = 'Good Afternoon';
      greetingIcon = Icons.wb_sunny_outlined;
    } else if (hour >= 17 && hour < 21) {
      greeting = 'Good Evening';
      greetingIcon = Icons.nights_stay;
    } else if (hour >= 21 || hour < 5) {
      greeting = 'Good Night';
      greetingIcon = Icons.bedtime;
    }

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                greetingIcon,
                color: AppColors.textOnPrimary,
                size: AppDimensions.iconXL,
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textOnPrimary,
                          ),
                    ),
                    Text(
                      _userName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            DateHelper.toShortDateString(DateTime.now()),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textOnPrimary.withOpacity(0.9),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding * 1.5),
        child: Column(
          children: [
            Icon(
              Icons.calendar_today,
              size: 60,
              color: AppColors.primary.withOpacity(0.5),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'No data for today',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              'Start tracking by adding your health metrics',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(HealthRecordViewModel viewModel) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate card width to prevent overflow
        final cardWidth = (constraints.maxWidth - AppDimensions.gridSpacing) / 2;
        final cardHeight = cardWidth * 0.7; // Adjusted aspect ratio

        return Wrap(
          spacing: AppDimensions.gridSpacing,
          runSpacing: AppDimensions.gridSpacing,
          children: [
            SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: StepsMetricCard(value: viewModel.todaySteps),
            ),
            SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: CaloriesMetricCard(value: viewModel.todayCalories),
            ),
            SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: WaterMetricCard(value: viewModel.todayWater),
            ),
          ],
        );
      },
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
                const Icon(Icons.insights, color: AppColors.primary, size: 20),
                const SizedBox(width: AppDimensions.spacingS),
                Text('Quick Stats', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingM),
            _buildStatRow(context, Icons.check_circle_outline, 'Total Records', '${viewModel.recordCount}'),
            const Divider(height: AppDimensions.spacingL),
            _buildStatRow(
              context,
              Icons.trending_up,
              'Steps Goal',
              viewModel.todaySteps >= 10000 ? 'Achieved! 🎉' : '${(viewModel.todaySteps / 10000 * 100).toInt()}%',
            ),
            const Divider(height: AppDimensions.spacingL),
            _buildStatRow(
              context,
              Icons.water_drop,
              'Water Goal',
              viewModel.todayWater >= 2000 ? 'Achieved! 💧' : '${(viewModel.todayWater / 2000 * 100).toInt()}%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthTips(BuildContext context) {
    final tips = [
      {'icon': Icons.directions_walk, 'tip': 'Take 10,000 steps daily', 'color': AppColors.stepsColor},
      {'icon': Icons.water_drop, 'tip': 'Drink 2 liters of water', 'color': AppColors.waterColor},
      {'icon': Icons.restaurant, 'tip': 'Eat fruits and vegetables', 'color': AppColors.accent},
      {'icon': Icons.bedtime, 'tip': 'Get 7-8 hours of sleep', 'color': AppColors.primary},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, color: AppColors.accent, size: 20),
                const SizedBox(width: AppDimensions.spacingS),
                Text('Health Tips', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingM),
            ...tips.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(tip['icon'] as IconData, color: tip['color'] as Color, size: 18),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: Text(
                      tip['tip'] as String,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
        ),
      ],
    );
  }

  Widget _buildErrorState(HealthRecordViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: AppColors.error),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              viewModel.errorMessage ?? AppStrings.errorGeneric,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingL),
            ElevatedButton(
              onPressed: () => viewModel.refreshData(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}