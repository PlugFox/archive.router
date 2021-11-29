import 'package:path/path.dart' as p;

abstract class RouteInformationUtil {
  RouteInformationUtil._();

  /// Выбросить из локации повторяющиеся сегменты
  /// Роут всегда должен начинаться с /
  static String normalize(String? sourceLocation) {
    if (sourceLocation == null) return 'home';
    final segments = <String>[];
    sourceLocation
        .toLowerCase()
        .split('/')
        .map<String>((e) => e.trim())
        .where((e) => e.isNotEmpty && e != 'home')
        .forEach(
          (e) => segments
            ..remove(e)
            ..add(e),
        );
    return p.normalize(
      p.joinAll(
        <String>[
          'home',
          ...segments,
        ],
      ),
    );
  }
}
