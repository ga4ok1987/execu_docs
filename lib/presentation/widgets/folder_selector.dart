import 'package:execu_docs/core/widgets/hover_button.dart';
import 'package:flutter/material.dart';

import '../../core/constants/index.dart';

class FolderSelector extends StatelessWidget {

  final String? path;
  final VoidCallback onSelect;

  const FolderSelector({
    super.key,

    required this.path,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.vertical8,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: AppPadding.all8,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderColorGrey),
                borderRadius: AppBorderRadius.all4,
              ),
              child: Text(
                path ?? AppTexts.folderNotSelected,
                maxLines: 1,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          AppGaps.w20,
          HoverButton(
            onPressed: onSelect,
            child: const Text(AppTexts.selectFolder),
          ),
          AppGaps.w12,
        ],
      ),
    );
  }
}
