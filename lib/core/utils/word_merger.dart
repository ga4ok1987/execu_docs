import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:execu_docs/core/constants/index.dart';

class WordMerger {
  /// Зливає DOCX-файли з прогресом (0..1)
  /// [folderPath] — директорія з DOCX для злиття
  /// [templateAsset] — asset-шаблон DOCX (наприклад, 'assets/empty.docx')
  /// [isResolution] — якщо true, використовує uniteFilesScript, інакше mergeDocxScript
  static Stream<double> mergeDocsWithProgress(
      String folderPath,
      String templateAsset,
      bool isResolution,
      ) async* {
    final tempDir = await getTemporaryDirectory();

    // 1. Копіюємо VBS скрипт з assets у тимчасову папку
    final scriptAsset = isResolution
        ? AppAssets.uniteFilesScript
        : AppAssets.mergeDocxScript;
    final scriptData = await rootBundle.load(scriptAsset);
    final scriptFile = File('${tempDir.path}/${scriptAsset.split("/").last}');
    await scriptFile.writeAsBytes(scriptData.buffer.asUint8List());

    // 2. Копіюємо шаблон DOCX з assets у тимчасову папку
    final templateData = await rootBundle.load(templateAsset);
    final templateFile = File('${tempDir.path}/${templateAsset.split("/").last}');
    await templateFile.writeAsBytes(templateData.buffer.asUint8List());

    // 3. Запуск процесу через скрипт
    final process = await Process.start(
      'cscript', // або 'wscript', залежно від твоїх скриптів
      ['//nologo', scriptFile.path, folderPath, templateFile.path],
      runInShell: true,
    );

    // 4. Читаємо stdout для прогресу
    await for (final line in process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())) {
      if (line.startsWith("PROGRESS:")) {
        final percent = double.tryParse(line.split(":")[1]) ?? 0;
        yield percent / 100;
      }
      if (line == "DONE") {
        yield 1.0;
      }
    }

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      throw Exception("mergeDocs failed, code $exitCode");
    }
  }
}
