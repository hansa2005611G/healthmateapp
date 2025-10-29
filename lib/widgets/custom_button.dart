import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../widgets/loading_indicator.dart';

/// Custom button widget with consistent styling and loading state
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool fullWidth;
  final double? height;
  final ButtonType type;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.fullWidth = true,
    this.height,
    this.type = ButtonType.elevated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? AppDimensions.buttonHeight;
    final minSize = fullWidth
        ? Size(double.infinity, buttonHeight)
        : Size(120, buttonHeight);

    // Disable button if loading or onPressed is null
    final isEnabled = !isLoading && onPressed != null;

    // Button content (text + optional icon + loading indicator)
    Widget buttonChild = isLoading
        ? const SmallLoadingIndicator(color: Colors.white)
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppDimensions.buttonIconSize),
                const SizedBox(width: AppDimensions.spacingXS),
              ],
              Text(text),
            ],
          );

    switch (type) {
      case ButtonType.elevated:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.primary,
            foregroundColor: textColor ?? AppColors.textOnPrimary,
            minimumSize: minSize,
            disabledBackgroundColor: AppColors.textDisabled,
            disabledForegroundColor: AppColors.textOnPrimary,
          ),
          child: buttonChild,
        );

      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: backgroundColor ?? AppColors.primary,
            side: BorderSide(
              color: backgroundColor ?? AppColors.primary,
              width: AppDimensions.borderWidth,
            ),
            minimumSize: minSize,
            disabledForegroundColor: AppColors.textDisabled,
          ),
          child: buttonChild,
        );

      case ButtonType.text:
        return TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor: backgroundColor ?? AppColors.primary,
            minimumSize: minSize,
            disabledForegroundColor: AppColors.textDisabled,
          ),
          child: buttonChild,
        );
    }
  }
}

/// Primary button (elevated style)
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      backgroundColor: AppColors.primary,
      type: ButtonType.elevated,
    );
  }
}

/// Secondary button (outlined style)
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const SecondaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      backgroundColor: AppColors.primary,
      type: ButtonType.outlined,
    );
  }
}

/// Danger/destructive button (red color)
class DangerButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const DangerButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      backgroundColor: AppColors.error,
      type: ButtonType.elevated,
    );
  }
}

/// Success button (green color)
class SuccessButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const SuccessButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      backgroundColor: AppColors.success,
      type: ButtonType.elevated,
    );
  }
}

/// Button type enum
enum ButtonType {
  elevated,
  outlined,
  text,
}