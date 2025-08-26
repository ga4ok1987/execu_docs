import 'dart:io';
import 'package:execu_docs/core/constants/index.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class WordMerger {
  static Future<void> mergeDocs(String folderPath) async {
    try {
      final tempDir = await getTemporaryDirectory();

      // 1. Копіюємо скрипт
      final scriptBytes = await rootBundle.load(AppAssets.mergeDocxScript);
      final scriptFile = File(
        '${tempDir.path}${AppPaths.tempMergeDocxScript}',
      );
      await scriptFile.writeAsBytes(scriptBytes.buffer.asUint8List());

      // 2. Копіюємо empty_template.docx
      final baseBytes = await rootBundle.load(AppAssets.emptyTemplate);
      final baseFile = File('${tempDir.path}${AppPaths.baseFile}');
      await baseFile.writeAsBytes(baseBytes.buffer.asUint8List());

      // 3. Запускаємо VBS, передаючи тимчасову папку

      final result = await Process.run(AppPaths.scriptPath, [
        '//nologo',
        scriptFile.path,
        folderPath,
        baseFile.path,
      ], runInShell: true);

      if (result.exitCode != 0) {
        print("❌ Error: ${result.stderr}");
        print("❌ Output: ${result.stdout}");
      } else {
        print("✅ Success: merged.docx created in $folderPath");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}
