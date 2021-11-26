import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:router/src/common/router/pages.dart';
import 'package:router/src/common/router/router.dart';

@immutable
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Демонстрация роутинга'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => AppRouter.navigate(context, (configuration) => configuration.add(SettingsPage())),
            ),
          ],
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
              children: const <Widget>[
                SizedBox(
                  height: 25,
                  child: Center(
                    child: Text(
                      'Выберите цвет',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 75,
                  child: _ColorsList(),
                ),
              ],
            ),
          ),
        ),
      );
}

@immutable
class _ColorsList extends StatelessWidget {
  const _ColorsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            _ColorChip(
              title: 'Red',
              color: Colors.red,
              onTap: () => AppRouter.navigate(
                context,
                (configuration) => configuration.add(ColorPage.red()),
              ),
            ),
            _ColorChip(
              title: 'Green',
              color: Colors.green,
              onTap: () => AppRouter.navigate(
                context,
                (configuration) => configuration.add(ColorPage.green()),
              ),
            ),
            _ColorChip(
              title: 'Blue',
              color: Colors.blue,
              onTap: () => AppRouter.navigate(
                context,
                (configuration) => configuration.add(ColorPage.blue()),
              ),
            ),
          ],
        ),
      );
}

@immutable
class _ColorChip extends StatelessWidget {
  const _ColorChip({
    required final this.title,
    required final this.color,
    required final this.onTap,
    Key? key,
  }) : super(key: key);

  final String title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: ActionChip(
          label: Text(title),
          padding: const EdgeInsets.all(8),
          backgroundColor: color,
          onPressed: onTap,
        ),
      );
}
