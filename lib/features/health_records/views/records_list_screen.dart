import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_helper.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/record_list_tile.dart';
import '../../../widgets/confirm_dialog.dart';
import '../viewmodels/health_record_viewmodel.dart';
import 'add_record_screen.dart' show EditRecordScreen;
import 'edit_record_screen.dart';

/// Records List Screen
/// Displays all health records with search and filter capabilities
class RecordsListScreen extends StatefulWidget {
  const RecordsListScreen({Key? key}) : super(key: key);

  @override
  State<RecordsListScreen> createState() => _RecordsListScreenState();
}

class _RecordsListScreenState extends State<RecordsListScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthRecordViewModel>().refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.recordsListTitle),
        actions: [
          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showDatePicker,
            tooltip: AppStrings.searchByDate,
          ),
          // Refresh button
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
          // Loading state
          if (viewModel.isLoading && !viewModel.hasRecords) {
            return const LoadingIndicator(
              message: AppStrings.loadingRecords,
            );
          }

          // Error state
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
                    ElevatedButton.icon(
                      onPressed: () => viewModel.refreshData(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Empty state
          if (viewModel.displayedRecords.isEmpty) {
            return viewModel.hasActiveFilter
                ? NoSearchResultsEmptyState(
                    onClearSearch: () => viewModel.clearSearch(),
                  )
                : const NoRecordsEmptyState();
          }

          // Main content
          return Column(
            children: [
              // Filter chip (if active)
              if (viewModel.hasActiveFilter) _buildFilterChip(viewModel),

              // Records list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => viewModel.refreshData(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppDimensions.screenPadding),
                    itemCount: viewModel.displayedRecords.length,
                    itemBuilder: (context, index) {
                      final record = viewModel.displayedRecords[index];
                      return RecordListTile(
                        record: record,
                        onEdit: () => _navigateToEdit(record.id!),
                        onDelete: () => _confirmDelete(viewModel, record.id!),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(HealthRecordViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: AppDimensions.spacingS,
      ),
      color: AppColors.primary.withOpacity(0.1),
      child: Wrap(
        spacing: AppDimensions.spacingS,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(
            Icons.filter_alt,
            size: AppDimensions.iconM,
            color: AppColors.primary,
          ),
          Text(
            '${AppStrings.showingRecordsFor} ${DateHelper.toShortDateString(viewModel.filterDate!)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(width: AppDimensions.spacingS),
          InkWell(
            onTap: () => viewModel.clearSearch(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingS,
                vertical: AppDimensions.spacingXXS,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.textOnPrimary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppStrings.clearFilter,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final viewModel = context.read<HealthRecordViewModel>();
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: viewModel.filterDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
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

    if (picked != null) {
      viewModel.searchByDate(picked);
    }
  }

  void _navigateToEdit(int recordId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecordScreen(recordId: recordId),
      ),
    );
  }

  Future<void> _confirmDelete(HealthRecordViewModel viewModel, int recordId) async {
    final confirmed = await DeleteConfirmDialog.show(context: context);

    if (confirmed && mounted) {
      final success = await viewModel.deleteRecord(recordId);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.recordDeleted),
              backgroundColor: AppColors.success,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                viewModel.errorMessage ?? AppStrings.errorDeletingRecord,
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}