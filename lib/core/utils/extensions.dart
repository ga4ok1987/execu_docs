extension PathShortener on String {
  /// Залишає ліву частину до другого '\' і праву частину після останніх двох '\', між ними '...'
  String shortenFolderPath({int rightParts = 2}) {
    List<String> parts = split(r'\');
    if (parts.length <= rightParts + 2) return this; // мало сегментів, не обрізати

    // Ліва частина до другого '\'
    String left = parts.sublist(0, 2).join(r'\');

    // Права частина після останніх [rightParts] сегментів
    String right = parts.sublist(parts.length - rightParts).join(r'\');

    return '$left\\...\\$right';
  }
}
