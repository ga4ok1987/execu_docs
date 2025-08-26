import 'package:execu_docs/core/constants/index.dart';
import 'package:execu_docs/core/widgets/confirm_dialog.dart';
import 'package:execu_docs/core/widgets/hover_button.dart';
import 'package:execu_docs/presentation/widgets/custom_expansion_tile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/highlight_container.dart';
import '../blocs/debtor_cubit.dart';
import '../blocs/folder_cubit.dart';
import '../blocs/panels_cubit.dart';
import 'debtors_table.dart';
import 'dialogs/add_debtor_dialog.dart';

class MainPanel extends StatelessWidget {
  const MainPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedRowNotifier = ValueNotifier<SelectedDebtor?>(null);

    final folderPath = context.watch<FolderCubit>().state;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: AppPadding.all16,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              SizedBox(
                height: 80,
                width: 953,
                child: HighlightContainer(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        AppTexts.tittle,
                        style: TextStyle(
                          color: AppColors.texBlack,
                          fontSize: AppTextSizes.big,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      HoverButton(
                        onPressed: () =>
                            context.read<PanelsCubit>().toggleRegionPanel(),
                        child: Text(
                          AppTexts.executors,
                          style: TextStyle(color: AppColors.textButtonWhite),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 66,
                    width: 1000 / 2.1,
                    child: HighlightContainer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HoverButton(
                            child: Text(
                              AppTexts.loadFiles,
                              style: TextStyle(
                                color: AppColors.textButtonWhite,
                              ),
                            ),
                            onPressed: () async {
                              if (folderPath.path1 != null) {
                                context.read<DebtorCubit>().importFromDocx(
                                  folderPath.path1!,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(AppTexts.selectFolderFirst),
                                  ),
                                );
                              }
                            },
                          ),

                          HoverButton(
                            child: Text(
                              AppTexts.createDocs,
                              style: TextStyle(
                                color: AppColors.textButtonWhite,
                              ),
                            ),
                            onPressed: () async {
                              context.read<DebtorCubit>().exportDebtors(
                                folderPath.path2!,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 1000 / 2.1,

                    child: HighlightContainer(
                      child: CustomExpansionTile(
                        title: AppTexts.settings,
                        expandedNotifier: settingsExpanded,

                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppTexts.pathToDocs),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: AppPadding.all8,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.borderColorGrey,
                                        ),
                                        borderRadius: AppBorderRadius.all4,
                                      ),
                                      child: Text(
                                        (folderPath.path1 ??
                                            AppTexts.folderNotSelected),
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
                                    onPressed: () => _selectFolder(context, 1),
                                    child: const Text(AppTexts.selectFolder),
                                  ),
                                  AppGaps.w12,
                                ],
                              ),
                              Text(AppTexts.pathToResults),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: AppPadding.all8,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.borderColorGrey,
                                    ),
                                    borderRadius: AppBorderRadius.all4,
                                  ),
                                  child: Text(
                                    (folderPath.path2 ??
                                        AppTexts.folderNotSelected),
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
                                onPressed: () => _selectFolder(context, 2),
                                child: const Text('Вибрати папку'),
                              ),
                              AppGaps.w12,
                            ],
                          ),
                          AppGaps.h16,
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                width: 450,
                child: HighlightContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: AppPadding.all8,
                        child: HoverButton(
                          onPressed: () => addDebtorDialog(context),
                          isCircle: true,
                          child: Icon(Icons.add, color: AppColors.primaryWhite),
                        ),
                      ),
                      Padding(
                        padding: AppPadding.all8,
                        child: HoverButton(
                          isCircle: true,
                          child: Icon(
                            Icons.edit,
                            color: AppColors.primaryWhite,
                          ),
                        ),
                      ),
                      Padding(
                        padding: AppPadding.all8,
                        child: HoverButton(
                          onPressed: () async {
                            final selected = selectedRowNotifier.value;
                            if (selected != null) {
                              await confirmDialog(
                                context: context,
                                title: AppTexts.deleteDebtorConfirm(
                                  selected.debtor.fullName,
                                ),
                                onConfirm: () {
                                  context.read<DebtorCubit>().deleteDebtor(
                                    selected.debtor.id,
                                  );
                                },
                              );

                              selectedRowNotifier.value = null;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(AppTexts.firstSelectDebtor),
                                ),
                              );
                            }
                          },
                          isCircle: true,
                          child: Icon(
                            Icons.delete,
                            color: AppColors.primaryWhite,
                          ),
                        ),
                      ),
                      Padding(
                        padding: AppPadding.all8,
                        child: HoverButton(
                          onPressed: () => confirmDialog(
                            context: context,
                            title: AppTexts.clearAllAlert,
                            message: AppTexts.deleteAlert,
                            onConfirm: () =>
                                context.read<DebtorCubit>().clearDebtors(),
                          ),
                          child: Text(
                            AppTexts.clearAll,
                            style: TextStyle(color: AppColors.textButtonWhite),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: HighlightContainer(
                  child: DebtorsTable(
                    selectedRowNotifier: selectedRowNotifier,
                    rowCount: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _selectFolder(BuildContext context, int index) async {
  final folderCubit = context.read<FolderCubit>();
  final result = await FilePicker.platform.getDirectoryPath();
  if (result != null) {
    if (index == 1) {
      folderCubit.setFolder1(result);
    } else if (index == 2) {
      folderCubit.setFolder2(result);
    }
  }
}
