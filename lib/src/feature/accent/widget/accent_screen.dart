import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:router/src/common/router/router.dart';

@immutable
class AccentScreen extends StatelessWidget {
  const AccentScreen({
    required final this.colorName,
    required final this.accent,
    required final this.color,
    Key? key,
  }) : super(key: key);

  final String colorName;
  final int accent;
  final Color color;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => AppRouter.pop(context),
          ),
          title: Text('${colorName.toUpperCase()}[$accent]'),
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
                    'Цвет: $colorName[$accent]',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Center(
                      child: _ColorBox(),
                    ),
                  ),
                ),
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
    final color = context.findAncestorWidgetOfExactType<AccentScreen>()!.color;
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
