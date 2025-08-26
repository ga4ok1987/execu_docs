import 'package:execu_docs/core/widgets/hover_button.dart';

class FolderSelector extends StatelessWidget {
  final String label;
  final String? path;
  final VoidCallback onSelect;

  const FolderSelector({
    super.key,
    required this.label,
    required this.path,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
