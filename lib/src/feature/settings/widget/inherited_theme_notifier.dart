import 'package:flutter/widgets.dart';
import 'package:router/src/feature/settings/widget/theme_controller.dart';

@immutable
class InheritedThemeNotifier extends InheritedNotifier<ThemeController> {
  const InheritedThemeNotifier({
    required final ThemeController themeController,
    required final Widget child,
    Key? key,
  }) : super(
          key: key,
          child: child,
          notifier: themeController,
        );

  static ThemeController? maybeOf(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<InheritedThemeNotifier>()?.notifier;
    } else {
      final inhW = context.getElementForInheritedWidgetOfExactType<InheritedThemeNotifier>()?.widget;
      return inhW is InheritedThemeNotifier ? inhW.notifier : null;
    }
  }
}
