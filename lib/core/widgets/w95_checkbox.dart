import 'package:flutter/material.dart';
import 'package:savepoint95/core/theme/app_colors.dart';

class W95Checkbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;

  const W95Checkbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.highlight, width: 2.0),
                left: BorderSide(color: AppColors.highlight, width: 2.0),
                right: BorderSide(color: AppColors.darkShadow, width: 2.0),
                bottom: BorderSide(color: AppColors.darkShadow, width: 2.0),
              ),
            ),
            child: Icon(value ? Icons.check : null, size: 16.0),
          ),
          SizedBox(width: 8.0),
          Text(label),
        ],
      ),
    );
  }
}
