import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PostLoadButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isFloating;

  const PostLoadButton({
    super.key,
    required this.onPressed,
    this.isFloating = true,
  });

  @override
  Widget build(BuildContext context) {
    return isFloating ? _buildFloatingButton() : _buildRegularButton();
  }

  Widget _buildFloatingButton() {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      elevation: 4,
      icon: CustomIconWidget(
        iconName: 'add',
        size: 24,
        color: AppTheme.lightTheme.colorScheme.onPrimary,
      ),
      label: Text(
        'Post Load',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRegularButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        icon: CustomIconWidget(
          iconName: 'add_box',
          size: 24,
          color: AppTheme.lightTheme.colorScheme.onPrimary,
        ),
        label: Text(
          'Post New Load',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
