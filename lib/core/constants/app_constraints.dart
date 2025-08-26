import 'package:flutter/material.dart';

class AppConstraints {
  static const maxWidth400 = BoxConstraints(maxWidth: 400);
  static const maxWidth600 = BoxConstraints(maxWidth: 600);

  static const minHeight100 = BoxConstraints(minHeight: 100);
  static const minHeight200 = BoxConstraints(minHeight: 200);
  static const minHeight300 = BoxConstraints(minHeight: 300);

  static const box400x300 = BoxConstraints(maxWidth: 400, maxHeight: 300);
}
