import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:router/src/common/router/pages.dart';
import 'package:router/src/common/router/router.dart';

@immutable
class ColorScreen extends StatelessWidget {
  const ColorScreen({
    required final this.colorName,
    required final this.color,
    Key? key,
  }) : super(key: key);

  final String colorName;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => AppRouter.pop(context),
          ),
          title: Text(colorName.toUpperCase()),
        ),
        body: SafeArea(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: math.max((MediaQuery.of(context).size.width - 550) / 2, 8),
                vertical: 14,
              ),
              children: <Widget>[
                SizedBox(
                  height: 25,
                  child: Text(
                    'Цвет: $colorName',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: 100,
                  height: 100,
                  child: _ColorBox(),
                ),
                const SizedBox(height: 50),
                const SizedBox(
                  height: 25,
                  child: Center(
                    child: Text(
                      'Выберите оттенок',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const _AccentWrapList(),
              ],
            ),
          ),
        ),
      );
}

@immutable
class _ColorBox extends StatelessWidget {
  const _ColorBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = context.findAncestorWidgetOfExactType<ColorScreen>()!.color;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ColoredBox(
        color: color,
        child: Center(
          child: Text(
            color.toString(),
            style: const TextStyle(
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _AccentWrapList extends StatelessWidget {
  const _AccentWrapList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parent = context.findAncestorWidgetOfExactType<ColorScreen>()!;
    final color = parent.color;
    final colorName = parent.colorName;
    return Center(
      child: Wrap(
        children: <Widget>[
          _AccentChip(
            colorName: colorName,
            accent: 50,
            color: color,
          ),
          for (var i = 100; i < 1000; i = i + 100)
            _AccentChip(
              colorName: colorName,
              color: color,
              accent: i,
            ),
        ],
      ),
    );
  }
}

@immutable
class _AccentChip extends StatelessWidget {
  const _AccentChip({
    required final this.colorName,
    required final this.color,
    required final this.accent,
    Key? key,
  }) : super(key: key);

  final String colorName;
  final MaterialColor color;
  final int accent;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: ActionChip(
          label: Text('$colorName[$accent]'),
          padding: const EdgeInsets.all(8),
          backgroundColor: color[accent],
          onPressed: () => AppRouter.navigate(
            context,
            (configuration) => configuration.add(
              AccentPage(
                colorName: colorName,
                accent: accent,
                color: color,
              ),
            ),
          ),
        ),
      );
}
