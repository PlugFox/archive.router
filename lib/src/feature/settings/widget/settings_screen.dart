import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:router/src/common/router/router.dart';
import 'package:router/src/feature/settings/widget/inherited_theme_notifier.dart';

@immutable
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void pop(BuildContext context) => AppRouter.canPop(context) ? AppRouter.maybePop(context) : AppRouter.goHome(context);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => pop(context),
          ),
          title: const Text('Settings'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: math.max((MediaQuery.of(context).size.width - 550) / 2, 8),
              vertical: 14,
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Switch theme',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6!.copyWith(height: 1),
                  ),
                  const SizedBox(width: 8),
                  Builder(
                    builder: (context) => Switch(
                      value: InheritedThemeNotifier.maybeOf(context)?.isLight ?? true,
                      onChanged: (value) => InheritedThemeNotifier.maybeOf(context)?.switchTheme(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
