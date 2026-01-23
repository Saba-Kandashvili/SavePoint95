import 'package:flutter/material.dart';
import 'package:savepoint95/core/theme/app_colors.dart';

class W95ProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double height;

  const W95ProgressBar({super.key, required this.value, this.height = 20.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          // sunken Look
          top: const BorderSide(color: AppColors.darkShadow, width: 2),
          left: const BorderSide(color: AppColors.darkShadow, width: 2),
          right: const BorderSide(color: AppColors.highlight, width: 2),
          bottom: const BorderSide(color: AppColors.highlight, width: 2),
        ),
      ),
      padding: const EdgeInsets.all(2),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double avaliableWidth = constraints.maxWidth;
          const double blockWidth = 10.0;
          const double gap = 2.0;

          // how many blocks fit in the avaliable width
          final int totalBlockPossible = (avaliableWidth / (blockWidth + gap))
              .floor();

          // active blocks
          final int activeBlocks = (totalBlockPossible * value)
              .clamp(0, totalBlockPossible)
              .toInt();

          return Row(
            children: List.generate(totalBlockPossible, (index) {
              return Container(
                margin: const EdgeInsets.only(right: gap),
                width: blockWidth,
                height: double.infinity,
                color: index < activeBlocks
                    ? AppColors.winBlue
                    : Colors.transparent,
              );
            }),
          );
        },
      ),
    );
  }
}
