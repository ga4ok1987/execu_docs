import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../constants/index.dart';

class ProgressLoader extends StatelessWidget {
  final double progress;

  const ProgressLoader({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AbsorbPointer(
        absorbing: true,
        child: Container(
          color: AppColors.overlayBlack50,
          child: Center(
            child: SizedBox(
              width: AppSizes.progressWidth, // ширина індикатора
              child: LinearPercentIndicator(
                lineHeight: AppSizes.progressHeight,
                percent: progress,
                center: Text(
                  "${(progress * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(color: Colors.white),
                ),
                barRadius: AppBorderRadius.r8,
                backgroundColor: AppColors.backgroundColor,
                progressColor: AppColors.primaryDarkMain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
