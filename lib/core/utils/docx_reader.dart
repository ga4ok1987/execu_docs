import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

class DocxReader {
  Future<List<String>> readDocxParagraphs(String path) async {
    final bytes = File(path).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    final docFile = archive.files.firstWhere(
      (f) => f.name == 'word/document.xml',
    );
    final xmlString = utf8.decode(docFile.content as List<int>);
    final xmlDoc = XmlDocument.parse(xmlString);

    // Кожен <w:p> — параграф
    final paragraphs = xmlDoc.findAllElements('w:p').map((p) {
      return p.innerText; // текст параграфа
    }).toList();

    return paragraphs;
  }
}
