import 'dart:io';
import 'package:archive/archive.dart';
import 'package:cleartec_docx_template/cleartec_docx_template.dart';
import 'package:execu_docs/core/utils/extensions.dart';
import 'package:flutter/services.dart';
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
      orElse: () =>
      const ExecutorEntity(id: 0,
          name: '',
          address: '',
          isPrimary: false,
          regionId: 0),
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
      orElse: () =>
      const ExecutorEntity(id: 0,
          name: '',
          address: '',
          isPrimary: false,
          regionId: 0),
    )
        .address;
  }

  Future<void> generateDebtorsDoc(List<DebtorEntity> debtors,
      String path) async {
    // 1. Зчитуємо шаблон
    final bytes = File('assets/template.docx').readAsBytesSync();
    final docx = await DocxTemplate.fromBytes(bytes);






    final debtorContents = ListContent('postanovy', [
      for (var debtor in debtors)
        Content()
        ..add(TextContent("year", DateTime
            .now()
            .year
            .toString()))..add(TextContent(
          "executor",
          executorNameById(debtor.regionId, debtor.executorId) ?? '',
        ))..add(TextContent(
          "address",
          executorAddressById(debtor.regionId, debtor.executorId) ?? '',
        ))..add(TextContent("amount", debtor.amount))..add(
            TextContent("words", debtor.amount))..add(
            TextContent("name", debtor.fullName))..add(
            TextContent("decree", debtor.decree.decreeConvert)),
    ]);



    final generated = await docx.generate(debtorContents);

    final outputFile = File('output.docx');
    if (generated != null) {
      outputFile.writeAsBytesSync(generated);
    }
  }
}
