import 'dart:async';

import 'package:l/l.dart';
import 'package:router/src/app.dart';

/// Запуск приложения как io
void run() =>
    // Зона перехвата всех ошибок верхнего уровня
    l.capture<void>(
      () => runZonedGuarded<void>(
        () async {
          // Запустить приложение
          App.run();
        },
        (final error, final stackTrace) {
          l.e(
            'io_top_level_error: ${error.toString()}',
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
