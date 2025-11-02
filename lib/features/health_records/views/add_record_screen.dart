// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/date_helper.dart';
import '../../../widgets/date_picker_field.dart';
import '../../../widgets/health_input_field.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/loading_indicator.dart';
import '../viewmodels/health_record_viewmodel.dart';


/// Edit Record Screen
/// Form for editing an existing health record
class EditRecordScreen extends StatefulWidget {
  final int recordId;

  const EditRecordScreen({
    Key? key,
    required this.recordId,
  }) : super(key: key);

  @override
  State<EditRecordScreen> createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {
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
  DateTime? _selectedDate;
  
  // Loading state
  bool _isSubmitting = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecord();
  }

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

  Future<void> _loadRecord() async {
    final viewModel = Provider.of<HealthRecordViewModel>(context, listen: false);
    final record = viewModel.getRecordById(widget.recordId);

    if (record == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Record not found'),
            backgroundColor: AppColors.error,
          ),
        );
        Navigator.pop(context);
      }
      return;
    }

    // Populate form fields
    setState(() {
      _stepsController.text = record.steps.toString();
      _caloriesController.text = record.calories.toString();
      _waterController.text = record.water.toString();
      _selectedDate = record.dateTime;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _selectedDate == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.editRecordTitle),
        ),
        body: const LoadingIndicator(message: 'Loading record...'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.editRecordTitle),
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
                selectedDate: _selectedDate!,
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

              // Update button
              PrimaryButton(
                text: AppStrings.updateButton,
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
      color: AppColors.accent.withOpacity(0.1),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Row(
          children: [
            const Icon(
              Icons.edit_note,
              color: AppColors.accent,
              size: AppDimensions.iconL,
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Text(
                'Update your health metrics for this day.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.accent,
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

    final viewModel = Provider.of<HealthRecordViewModel>(context, listen: false);
    final originalRecord = viewModel.getRecordById(widget.recordId);

    if (originalRecord == null) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Record not found'),
            backgroundColor: AppColors.error,
          ),
        );
        Navigator.pop(context);
      }
      return;
    }

    // Parse values
    final steps = int.parse(_stepsController.text.trim());
    final calories = int.parse(_caloriesController.text.trim());
    final water = int.parse(_waterController.text.trim());
    final dateString = DateHelper.toIsoString(_selectedDate!);

    // Check if date changed and if new date already has a record
    if (dateString != originalRecord.date) {
      final canUseDate = await viewModel.canAddRecordForDate(
        dateString,
        excludeId: widget.recordId,
      );
      
      if (!canUseDate && mounted) {
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
    }

    // Update record
    final updatedRecord = originalRecord.update(
      date: dateString,
      steps: steps,
      calories: calories,
      water: water,
    );

    // Save to database
    final success = await viewModel.updateRecord(updatedRecord);

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.recordUpdated),
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
              viewModel.errorMessage ?? AppStrings.errorUpdatingRecord,
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}