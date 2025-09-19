import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:execu_docs/core/constants/index.dart';

class WordMerger {
  static Stream<double> mergeDocsWithProgress(
    String folderPath,
    String tempFile,
    bool isResolution,
  ) async* {
    final tempDir = await getTemporaryDirectory();

    // Копіюємо VBS
    final scriptBytes = isResolution
        ? await rootBundle.load(AppAssets.uniteFilesScript)
        : await rootBundle.load(AppAssets.mergeDocxScript);
    final scriptFile = File('${tempDir.path}${AppPaths.tempMergeDocxScript}');
    await scriptFile.writeAsBytes(scriptBytes.buffer.asUint8List());

    // Копіюємо Base.docx
    final baseBytes = await rootBundle.load(tempFile);
    final baseFile = File('${tempDir.path}${AppPaths.baseFile}');
    await baseFile.writeAsBytes(baseBytes.buffer.asUint8List());

    final process = await Process.start(AppPaths.scriptPath, [
      '//nologo',
      scriptFile.path,
      folderPath,
      baseFile.path,
    ], runInShell: true);

    await for (final line
        in process.stdout
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
      throw Exception("mergeDocs failed");
    }
  }
}
