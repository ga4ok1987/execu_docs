import 'package:execu_docs/domain/entities/region_entity.dart';

extension PathShortener on String {
  /// Залишає ліву частину до другого '\' і праву частину після останніх двох '\', між ними '...'
  String shortenFolderPath({int rightParts = 2}) {
    List<String> parts = split(r'\');
    if (parts.length <= rightParts + 2) return this;

    // Ліва частина до другого '\'
    String left = parts.sublist(0, 2).join(r'\');

    // Права частина після останніх [rightParts] сегментів
    String right = parts.sublist(parts.length - rightParts).join(r'\');

    return '$left\\...\\$right';
  }
}
extension StringCleaner on String {
  /// Прибрати всі нові рядки (\n, \r\n, \r)
  String removeNewLines() => replaceAll(RegExp(r'(\r\n|\r|\n)'), '');

  /// Замінити нові рядки на пробіл
  String replaceNewLinesWithSpace() => replaceAll(RegExp(r'(\r\n|\r|\n)'), ' ');

  /// Прибрати зайві пробіли і переноси, залишивши один пробіл
  String normalizeSpaces() => replaceAll(RegExp(r'\s+'), ' ').trim();
}

extension ExtractFromString on String {
  /// Повертає текст після першої двокрапки, обрізає пробіли
  String get extractName {
    final regex = RegExp(
      r'Притягнути гр\.-на\(ку\)\s+(.*?)\s+до',
      caseSensitive: false,
      dotAll: true,
    );
    final match = regex.firstMatch(this);
    return match?.group(1)?.trim()??'';
  }

  String get extractDecree {
    return replaceAll('серія ', '')  // видаляємо тільки слово "серія " з пробілом
        .replaceAll('№ ', '') // видаляємо "№ " з пробілом
        .replaceAll(' ', ''); // видаляємо решту пробілів
  }

  String get extractAddress {
    final index = indexOf(':');
    if (index == -1) return this;

    // беремо все після двокрапки
    String afterColon = substring(index + 1).trim();

    // видаляємо початковий код (цифри з пробілом)
    final match = RegExp(r'^\d+\s+').firstMatch(afterColon);
    if (match != null) {
      afterColon = afterColon.substring(match.end);
    }

    return afterColon;
  }

  String get extractAmount {
    final regExp = RegExp(r'(\d+(?:\.\d+)?)\s*грн');
    final matches = regExp.allMatches(this);
    if (matches.isEmpty) return '';
    return matches.last.group(1)?.substring(0,matches.last.group(1)!.length-3) ?? '';
  }

  int? extractRegion(List<RegionEntity>? regions) {
    final normalized = toUpperCase().trim();
    if (regions == null) return null;
    for (final region in regions) {
      final normRegion = region.name.toUpperCase();
      if (normalized.contains(normRegion.split(' ').first)) {
        return region
            .id; // повертаємо з оригінального списку, щоб зберегти формат
      }
    }

    return null; // якщо не знайдено
  }
}
