// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/date_helper.dart';
import '../../../data/models/health_record_model.dart';
import '../../../widgets/date_picker_field.dart';
import '../../../widgets/health_input_field.dart';
import '../../../widgets/custom_button.dart';
import '../viewmodels/health_record_viewmodel.dart';

/// Add Record Screen
/// Form for adding a new health record
class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({Key? key}) : super(key: key);

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _stepsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _waterController = TextEditingController();
  
  // Focus nodes
  final _stepsFocusNode = FocusNode();
  final _caloriesFocusNode = FocusNode();
  final _waterFocusNode = FocusNode();
  
  // Selected date
  DateTime _selectedDate = DateTime.now();
  
  // Loading state
  bool _isSubmitting = false;

  @override
  void dispose() {
    _stepsController.dispose();
    _caloriesController.dispose();
    _waterController.dispose();
    _stepsFocusNode.dispose();
    _caloriesFocusNode.dispose();
    _waterFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addRecordTitle),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info card
              _buildInfoCard(),
              const SizedBox(height: AppDimensions.spacingL),

              // Date picker
              DatePickerField(
                label: AppStrings.dateLabel,
                selectedDate: _selectedDate,
                onDateChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 1)),
              ),
              const SizedBox(height: AppDimensions.spacingM),

              // Steps input
              StepsInputField(
                controller: _stepsController,
                validator: Validators.validateSteps,
                focusNode: _stepsFocusNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_caloriesFocusNode);
                },
              ),
              const SizedBox(height: AppDimensions.spacingM),

              // Calories input
              CaloriesInputField(
                controller: _caloriesController,
                validator: Validators.validateCalories,
                focusNode: _caloriesFocusNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_waterFocusNode);
                },
              ),
              const SizedBox(height: AppDimensions.spacingM),

              // Water input
              WaterInputField(
                controller: _waterController,
                validator: Validators.validateWater,
                focusNode: _waterFocusNode,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submitForm(),
              ),
              const SizedBox(height: AppDimensions.spacingXL),

              // Save button
              PrimaryButton(
                text: AppStrings.saveButton,
                onPressed: _isSubmitting ? null : _submitForm,
                isLoading: _isSubmitting,
                icon: Icons.save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: AppColors.primary.withOpacity(0.1),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.primary,
              size: AppDimensions.iconL,
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Text(
                'Enter your daily health metrics to track your progress.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    // Unfocus all fields
    FocusScope.of(context).unfocus();

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final viewModel = context.read<HealthRecordViewModel>();

    // Parse values
    final steps = int.parse(_stepsController.text.trim());
    final calories = int.parse(_caloriesController.text.trim());
    final water = int.parse(_waterController.text.trim());
    final dateString = DateHelper.toIsoString(_selectedDate);

    // Check if record already exists for this date
    final canAdd = await viewModel.canAddRecordForDate(dateString);
    
    if (!canAdd && mounted) {
      setState(() {
        _isSubmitting = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.duplicateRecordError),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Create record
    final record = HealthRecord.create(
      date: dateString,
      steps: steps,
      calories: calories,
      water: water,
    );

    // Save to database
    final success = await viewModel.addRecord(record);

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.recordAdded),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate back
         Navigator.pop(context);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              viewModel.errorMessage ?? AppStrings.errorSavingRecord,
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}