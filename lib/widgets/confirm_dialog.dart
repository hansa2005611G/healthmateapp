// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_strings.dart';

/// Confirmation dialog widget
/// Used for confirming destructive or important actions
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final IconData? icon;
  final bool isDangerous;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.icon,
    this.isDangerous = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveConfirmColor = confirmColor ??
        (isDangerous ? AppColors.error : AppColors.primary);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.dialogRadius),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: effectiveConfirmColor,
              size: AppDimensions.iconL,
            ),
            const SizedBox(width: AppDimensions.spacingS),
          ],
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            onCancel?.call();
          },
          child: Text(cancelText),
        ),

        // Confirm button
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveConfirmColor,
            foregroundColor: AppColors.textOnPrimary,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }

  /// Show the dialog and return result
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    IconData? icon,
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmColor: confirmColor,
        icon: icon,
        isDangerous: isDangerous,
      ),
    );

    return result ?? false;
  }
}

/// Pre-configured delete confirmation dialog
class DeleteConfirmDialog extends StatelessWidget {
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const DeleteConfirmDialog({
    Key? key,
    this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfirmDialog(
      title: AppStrings.deleteConfirmTitle,
      message: AppStrings.deleteConfirmMessage,
      confirmText: AppStrings.deleteButton,
      cancelText: AppStrings.cancelButton,
      onConfirm: onConfirm,
      onCancel: onCancel,
      icon: Icons.delete_outline,
      isDangerous: true,
    );
  }

  /// Show delete confirmation dialog
  static Future<bool> show({
    required BuildContext context,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmDialog(
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );

    return result ?? false;
  }
}

/// Pre-configured unsaved changes dialog
class UnsavedChangesDialog extends StatelessWidget {
  final VoidCallback? onDiscard;
  final VoidCallback? onKeepEditing;

  const UnsavedChangesDialog({
    Key? key,
    this.onDiscard,
    this.onKeepEditing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfirmDialog(
      title: AppStrings.unsavedChangesTitle,
      message: AppStrings.unsavedChangesMessage,
      confirmText: AppStrings.discardButton,
      cancelText: AppStrings.keepEditingButton,
      onConfirm: onDiscard,
      onCancel: onKeepEditing,
      icon: Icons.warning_outlined,
      isDangerous: true,
    );
  }

  /// Show unsaved changes dialog
  static Future<bool> show({
    required BuildContext context,
    VoidCallback? onDiscard,
    VoidCallback? onKeepEditing,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => UnsavedChangesDialog(
        onDiscard: onDiscard,
        onKeepEditing: onKeepEditing,
      ),
    );

    return result ?? false;
  }
}

/// Pre-configured exit app confirmation dialog
class ExitAppDialog extends StatelessWidget {
  final VoidCallback? onExit;
  final VoidCallback? onStay;

  const ExitAppDialog({
    Key? key,
    this.onExit,
    this.onStay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfirmDialog(
      title: AppStrings.exitAppTitle,
      message: AppStrings.exitAppMessage,
      confirmText: AppStrings.exitButton,
      cancelText: AppStrings.stayButton,
      onConfirm: onExit,
      onCancel: onStay,
      icon: Icons.exit_to_app,
    );
  }

  /// Show exit app dialog
  static Future<bool> show({
    required BuildContext context,
    VoidCallback? onExit,
    VoidCallback? onStay,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ExitAppDialog(
        onExit: onExit,
        onStay: onStay,
      ),
    );

    return result ?? false;
  }
}