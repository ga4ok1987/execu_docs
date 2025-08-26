import 'package:execu_docs/core/constants/index.dart';
import 'package:flutter/material.dart';
import 'hover_button.dart';

Future<void> confirmDialog({
  required BuildContext context,
  required String title,
  String? message,
  required VoidCallback onConfirm,
}) {
  return showDialog(
    context: context,

    builder: (dialogContext) {
      return Dialog(
        child: ConstrainedBox(
          constraints: AppConstraints.maxWidth400,
          child: Container(
            padding: AppPadding.all16,
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: AppBorderRadius.all16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                message == null ? AppGaps.h8 : AppGaps.shrink,
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppTextSizes.big,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                message != null ? AppGaps.h12 : AppGaps.shrink,
                message != null
                    ? Text(
                        message,
                        style: const TextStyle(fontSize: AppTextSizes.big),
                        textAlign: TextAlign.center,
                      )
                    : AppGaps.shrink,
                AppGaps.h12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HoverButton(
                      color: AppColors.backgroundButtonRed,
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text(
                        AppTexts.cancel,
                        style: TextStyle(color: AppColors.textButtonWhite),
                      ),
                    ),
                    AppGaps.w12,
                    HoverButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        onConfirm();
                      },
                      child: const Text(
                        AppTexts.accept,
                        style: TextStyle(color: AppColors.textButtonWhite),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
