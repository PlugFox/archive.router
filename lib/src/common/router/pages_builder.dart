import 'package:flutter/widgets.dart';
import 'package:l/l.dart';
import 'package:router/src/common/router/configuration.dart';
import 'package:router/src/common/router/pages.dart';

/// {@template pages_builder.PagesBuilder}
/// Собирает список маршрутов из текущей конфигурации роутера приложения
/// Также сокращает или перенаправляет недоступные роуты в текущем контексте
/// {@endtemplate}
@immutable
class PagesBuilder extends StatelessWidget {
  /// {@macro pages_builder.PagesBuilder}
  const PagesBuilder({
    required final this.configuration,
    required final this.builder,
    final this.child,
    Key? key,
  }) : super(key: key);

  /// Текущая конфигурация навигации
  final IRouteConfiguration configuration;

  final ValueWidgetBuilder<List<AppPage<Object?>>> builder;
  final Widget? child;

  /// Вызывается для создания из конфигурации страниц, проверки и исключения дубликатов и не разрешенных пользователю
  static List<AppPage<Object?>> buildAndReduce(
    BuildContext context,
    IRouteConfiguration configuration,
  ) {
    final segments = Uri.parse(configuration.location).pathSegments;
    final state = Map<String, Map<String, Object?>?>.of(
      configuration.state ?? <String, Map<String, Object?>?>{},
    );
    final home = HomePage();
    final pages = <String, AppPage<Object?>>{
      home.path: home,
    };
    for (final path in segments) {
      try {
        if (path.isEmpty) continue;
        final page = AppPage.fromPath(
          path: path,
          arguments: state.remove(path),
        );
        pages[page.path] = page;
      } on Object catch (err) {
        l.w('Ошибка разбора роута "$path": $err');
      }
    }
    return pages.values.toList(growable: false);
  }

  @override
  Widget build(BuildContext context) => builder(
        context,
        buildAndReduce(context, configuration),
        child,
      );
}
