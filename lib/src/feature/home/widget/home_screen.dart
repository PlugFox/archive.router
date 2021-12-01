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
          title: const Text('Routing'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () => AppRouter.navigate(context, (configuration) => configuration.add(AboutPage())),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => AppRouter.navigate(context, (configuration) => configuration.add(SettingsPage())),
            ),
            const SizedBox(width: 12),
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
              children: <Widget>[
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Select color',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline4!.copyWith(height: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const SizedBox(
                  height: 50,
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
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: _ColorChip(
                title: 'Red',
                color: Colors.red,
                onTap: () => AppRouter.navigate(
                  context,
                  (configuration) => configuration.add(ColorPage.red()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ColorChip(
                title: 'Green',
                color: Colors.green,
                onTap: () => AppRouter.navigate(
                  context,
                  (configuration) => configuration.add(ColorPage.green()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ColorChip(
                title: 'Blue',
                color: Colors.blue,
                onTap: () => AppRouter.navigate(
                  context,
                  (configuration) => configuration.add(ColorPage.blue()),
                ),
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
  Widget build(BuildContext context) => Center(
        child: OutlinedButton(
          onPressed: onTap,
          child: Center(
            child: Text(title),
          ),
        ),
      );
}
