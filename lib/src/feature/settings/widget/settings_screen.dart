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
              child: IconButton(
                iconSize: 64,
                onPressed: () => InheritedThemeNotifier.maybeOf(context, listen: false)?.switchTheme(),
                icon: Tooltip(
                  message: 'Switch theme',
                  child: Builder(
                    builder: (context) => (InheritedThemeNotifier.maybeOf(context)?.isLight ?? true)
                        ? const Icon(
                            Icons.dark_mode,
                            color: Colors.black87,
                          )
                        : const Icon(
                            Icons.light_mode,
                            color: Colors.orange,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
