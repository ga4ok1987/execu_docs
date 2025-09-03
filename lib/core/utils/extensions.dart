import 'package:execu_docs/core/constants/index.dart';
import 'package:execu_docs/domain/entities/region_entity.dart';

extension StringCleaner on String {
  /// Прибрати всі нові рядки (\n, \r\n, \r)
  String removeNewLines() => replaceAll(RegExp(r'(\r\n|\r|\n)'), '');

  /// Замінити нові рядки на пробіл
  String replaceNewLinesWithSpace() => replaceAll(RegExp(r'(\r\n|\r|\n)'), ' ');

  /// Прибрати зайві пробіли і переноси, залишивши один пробіл
  String normalizeSpaces() => replaceAll(RegExp(r'\s+'), ' ').trim();
}

extension ExtractFromString on String {
  String get decreeConvert {
    if (length > 2) {
      return '${substring(0, 2)} № ${substring(2)}';
    }
    return this; // якщо рядок менше 3 символів, залишаємо як є
  }
  /// Повертає текст після першої двокрапки, обрізає пробіли
  String get extractName {
    final regex = RegExp(
      r'Притягнути гр\.-на\(ку\)\s*(.+?)\s*до адміністративної',
      caseSensitive: false,
      dotAll: true,
    );

    final match = regex.firstMatch(this);
    if (match == null) return '';

    return match.group(1)
        ?.replaceAll(RegExp(r'\s*\(.*?\)'), '') // видаляємо дужки та текст всередині
        .trim() ?? '';
  }




  String get extractDecree {
    return replaceAll(
          'серія ',
          '',
        ) // видаляємо тільки слово "серія " з пробілом
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
    return matches.last
            .group(1)
            ?.substring(0, matches.last.group(1)!.length - 3) ??
        '';
  }

  int? extractRegion(List<RegionEntity>? regions) {
    if (regions == null) return null;

    String normalize(String input) => input.toUpperCase()
        .replaceAll('.', ' ')
        .replaceAll('ОБЛАСТЬ', 'ОБЛ')
        .replaceAll('ОБЛ', 'ОБЛ') // уніфікація
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final normalized = normalize(toUpperCase());

    for (final region in regions) {
      final normRegion = normalize(region.name);

      if (normRegion == 'КИЇВ') {
        // спеціально для Києва — перевіряємо як слово
        final words = normalized.split(' ');
        if (words.contains('КИЇВ')) {
          return region.id;
        }
      } else {
        // для областей перевіряємо повну назву
        if (normalized.startsWith(normRegion)) {
          return region.id;
        }
      }
    }
    return null;
  }

}

extension SimpleNumberToWords on String {
  String toWords() {
    switch (this) {

      case '600':
        return AppTexts.fine600;
      case '680':
        return AppTexts.fine680;
      case '1360':
        return AppTexts.fine1360;
      default:
        return '$this ${AppTexts.uah}'; // на випадок інших чисел
    }
  }
}


