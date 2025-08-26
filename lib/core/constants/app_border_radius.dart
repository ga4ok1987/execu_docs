import 'package:flutter/material.dart';

class AppBorderRadius {
  static const all4 = BorderRadius.all(Radius.circular(4));
  static const all8 = BorderRadius.all(Radius.circular(8));
  static const all12 = BorderRadius.all(Radius.circular(12));
  static const all16 = BorderRadius.all(Radius.circular(16));
  static const all20 = BorderRadius.all(Radius.circular(20));
  static const all24 = BorderRadius.all(Radius.circular(24));
  static const all32 = BorderRadius.all(Radius.circular(32));
  static const all48 = BorderRadius.all(Radius.circular(48));

  static const circular = BorderRadius.all(Radius.circular(1000));

  // Якщо треба заокруглення тільки певних кутів
  static const top16 = BorderRadius.vertical(top: Radius.circular(16));
  static const bottom16 = BorderRadius.vertical(bottom: Radius.circular(16));
  static const top16bot16 = BorderRadius.only(
    topLeft: Radius.circular(16),
    bottomLeft: Radius.circular(16),
  );

  static const onlyTopLeft12 = BorderRadius.only(topLeft: Radius.circular(12));

  static const onlyBottomRight16 = BorderRadius.only(
    bottomRight: Radius.circular(16),
  );
}