import 'package:flutter/material.dart';
import 'package:savepoint95/core/theme/app_colors.dart';

class W95Panel extends StatelessWidget {
  final Widget child;

  const W95Panel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.highlight, width: 2.0),
          left: BorderSide(color: AppColors.highlight, width: 2.0),
          right: BorderSide(color: AppColors.darkShadow, width: 2.0),
          bottom: BorderSide(color: AppColors.darkShadow, width: 2.0),
        ),
      ),
      child: child,
    );
  }
}
