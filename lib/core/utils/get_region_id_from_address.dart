import '../../data/datasources/local/database.dart';

Future<int?> detectRegionIdFromAddress(AppDatabase db, String address) async {
  if (address.trim().isEmpty) return null;
  final regs = await db.select(db.regions).get();
  final low = address.toLowerCase();
  for (final r in regs) {
    if (low.contains(r.name.toLowerCase().replaceAll('область', '').trim())) {
      return r.id;
    }
    // also check short names: e.g. 'Київ'
    final regionShort = r.name.split(' ').first.toLowerCase();
    if (low.contains(regionShort)) return r.id;
  }
  return null;
}