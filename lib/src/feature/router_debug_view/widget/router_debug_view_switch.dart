import 'package:flutter/widgets.dart';

@immutable
class RouterDebugViewSwitch extends InheritedWidget {
  const RouterDebugViewSwitch({
    required final this.enabled,
    required final Widget child,
    Key? key,
  }) : super(key: key, child: child);

  final bool enabled;

  static bool of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<RouterDebugViewSwitch>()?.enabled ?? false;
    } else {
      final inhW = context.getElementForInheritedWidgetOfExactType<RouterDebugViewSwitch>()?.widget;
      return inhW is RouterDebugViewSwitch && inhW.enabled;
    }
  }

  @override
  bool updateShouldNotify(RouterDebugViewSwitch oldWidget) => enabled != oldWidget.enabled;
}
