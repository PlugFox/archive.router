import 'package:flutter/material.dart';

@immutable
class RouterDebugView extends StatefulWidget {
  const RouterDebugView({
    Key? key,
  }) : super(key: key);

  @override
  State<RouterDebugView> createState() => _RouterDebugViewState();
}

class _RouterDebugViewState extends State<RouterDebugView> {
  //region Lifecycle
  @override
  void initState() {
    super.initState();
    // Первичная инициализация виджета
  }

  @override
  void didUpdateWidget(RouterDebugView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Конфигурация виджета изменилась
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Изменилась конфигурация InheritedWidget'ов
    // Также вызывается после initState, но до build'а
  }

  @override
  void dispose() {
    // Перманетное удаление стейта из дерева
    super.dispose();
  }
  //endregion

  @override
  Widget build(BuildContext context) => Center(
        child: AspectRatio(
          aspectRatio: 3 / 1,
          child: ColoredBox(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const Placeholder(),
          ),
        ),
      );
}
