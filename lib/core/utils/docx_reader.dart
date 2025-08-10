import 'dart:io';

import 'package:docx_template/docx_template.dart';

class DocxReader {
  Future<String> readFile(String path) async {
    final docx = await  DocxTemplate.fromBytes(await File(path).readAsBytes());
    return docx.toString();
  }
}