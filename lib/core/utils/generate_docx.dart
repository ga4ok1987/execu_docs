import 'dart:io';
import 'package:cleartec_docx_template/cleartec_docx_template.dart';
import 'package:execu_docs/core/constants/index.dart';
import 'package:execu_docs/core/utils/extensions.dart';
import '../../domain/entities/debtor_entity.dart';
import '../../domain/entities/region_entity.dart';
import '../../domain/entities/executor_entity.dart';

class DebtorDocxGenerator {
  final List<RegionEntity> regions;

  DebtorDocxGenerator(this.regions);

  String? executorNameById(int? regionId, int? executorId) {
    if (regionId == null || executorId == null) return null;
    final region = regions.firstWhere(
      (r) => r.id == regionId,
      orElse: () => const RegionEntity(id: 0, name: '', executorOffices: []),
    );
    return region.executorOffices
        .firstWhere(
          (e) => e.id == executorId,
          orElse: () => const ExecutorEntity(
            id: 0,
            name: '',
            address: '',
            isPrimary: false,
            regionId: 0,
          ),
        )
        .name;
  }

  String? executorAddressById(int? regionId, int? executorId) {
    if (regionId == null || executorId == null) return null;
    final region = regions.firstWhere(
      (r) => r.id == regionId,
      orElse: () => const RegionEntity(id: 0, name: '', executorOffices: []),
    );
    return region.executorOffices
        .firstWhere(
          (e) => e.id == executorId,
          orElse: () => const ExecutorEntity(
            id: 0,
            name: '',
            address: '',
            isPrimary: false,
            regionId: 0,
          ),
        )
        .address;
  }

  String debtorsFromTernopil(List<DebtorEntity> debtors) {
    return debtors
        .where((d) => d.regionId == 19)
        .map((d) => '${d.decree}  ${d.fullName}')
        .join('\n');
  }

  Future<String> createAppFolder(String path, String folderName) async {
    final dir = Directory('$path/$folderName');
    dir.create(recursive: true);
    return dir.path;
  }

  Future<void> generateTernopilDebtorsListDoc(
    List<DebtorEntity> debtors,
    String path,
  ) async {
    final templateBytes = await File(AppAssets.templateTernopil).readAsBytes();
    final template = await DocxTemplate.fromBytes(templateBytes);
    final debtor = debtors.firstWhere((d) => d.regionId == 19);

    final outputDir = Directory(path);
    if (!outputDir.existsSync()) outputDir.createSync();

    final content = Content()
      ..add(TextContent('year', DateTime.now().year.toString()))
      ..add(
        TextContent(
          "executor",
          executorNameById(debtor.regionId, debtor.executorId) ?? '',
        ),
      )
      ..add(
        TextContent(
          "address",
          executorAddressById(debtor.regionId, debtor.executorId) ?? '',
        ),
      )
      ..add(TextContent("debtors", debtorsFromTernopil(debtors)));

    final generated = await template.generate(content);
    if (generated != null) {
      final filePath = '${outputDir.path}/${AppTexts.ternopilList}.docx';
      await File(filePath).writeAsBytes(generated);
    }
  }

  Future<void> generateDebtorsDoc(DebtorEntity debtor, String path) async {
    final templateBytes = await File(AppAssets.template).readAsBytes();
    final template = await DocxTemplate.fromBytes(templateBytes);

    final outputDir = Directory(await createAppFolder(path, AppTexts.coverDocs));
    if (!outputDir.existsSync()) outputDir.createSync();

    final content = Content()
      ..add(TextContent('year', DateTime.now().year.toString()))
      ..add(
        TextContent(
          "executor",
          executorNameById(debtor.regionId, debtor.executorId) ?? '',
        ),
      )
      ..add(
        TextContent(
          "address",
          executorAddressById(debtor.regionId, debtor.executorId) ?? '',
        ),
      )
      ..add(TextContent("amount", debtor.amount.toString()))
      ..add(TextContent("words", debtor.amount.toWords()))
      ..add(TextContent("name", debtor.fullName))
      ..add(TextContent("decree", debtor.decree));

    final generated = await template.generate(content);
    if (generated != null) {
      final filePath = '${outputDir.path}/${debtor.decree}.docx';
      await File(filePath).writeAsBytes(generated);
    }
  }
}
