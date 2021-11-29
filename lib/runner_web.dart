// ignore_for_file: unnecessary_lambdas
import 'dart:async';
import 'dart:html' as html;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:l/l.dart';
import 'package:router/src/app.dart';

/// Запуск для веба
void run() =>
    // Зона перехвата всех ошибок верхнего уровня
    l.capture<void>(
      () => runZonedGuarded<void>(
        () async {
          // https://docs.flutter.dev/development/ui/navigation/url-strategies
          //setUrlStrategy(PathUrlStrategy());
          setUrlStrategy(const HashUrlStrategy());

          // Запустить приложение
          App.run();

          // Удалить прогресс индикатор после запуска приложения
          Future<void>.delayed(
            const Duration(seconds: 1),
            () {
              html.document
                  .getElementsByClassName('loading')
                  .toList(growable: false)
                  .forEach((element) => element.remove());
            },
          );
        },
        (final error, final stackTrace) {
          l.e(
            'web_top_level_error: ${error.toString()}',
            stackTrace,
          );
        },
      ),
      const LogOptions(
        printColors: true,
        handlePrint: true,
        outputInRelease: true,
      ),
    );
