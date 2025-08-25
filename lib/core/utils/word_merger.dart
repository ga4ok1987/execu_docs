import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class WordMerger {
  static Future<void> mergeDocs(String folderPath) async {
    try {
      final tempDir = await getTemporaryDirectory();

      // 1. Копіюємо скрипт
      final scriptBytes = await rootBundle.load('assets/scripts/merge_docs.vbs');
      final scriptFile = File('${tempDir.path}/merge_docs.vbs');
      await scriptFile.writeAsBytes(scriptBytes.buffer.asUint8List());

      // 2. Копіюємо empty_template.docx
      final baseBytes = await rootBundle.load('assets/templates/empty_template.docx');
      final baseFile = File('${tempDir.path}/Base.docx');
      await baseFile.writeAsBytes(baseBytes.buffer.asUint8List());

      // 3. Запускаємо VBS, передаючи тимчасову папку
      final cscriptPath = r'C:\Windows\System32\cscript.exe';

      final result = await Process.run(
        cscriptPath,
        ['//nologo', scriptFile.path, folderPath, baseFile.path],
        runInShell: true,
      );

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
