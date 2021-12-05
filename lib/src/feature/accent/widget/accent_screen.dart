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
          centerTitle: true,
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
                  height: 50,
                  child: Center(
                    child: Text(
                      'Selected accent: $colorName[$accent]',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6,
                    ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: 200,
          child: SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 5,
                  color: color.withOpacity(0.5),
                  style: BorderStyle.solid,
                ),
                boxShadow: kElevationToShadow[6],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
