import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:l/l.dart';
import 'package:router/src/common/constant/pubspec.yaml.g.dart' as pubspec;
import 'package:router/src/common/router/router.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

@immutable
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  void pop(BuildContext context) => AppRouter.canPop(context) ? AppRouter.maybePop(context) : AppRouter.goHome(context);

  void launch(String url) {
    try {
      launcher.launch(url);
    } on Object catch (err) {
      l.w('При открытии сайта произошла ошибка: $err');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => pop(context),
          ),
          title: const Text('About'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Center(
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    height: 1,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: math.max((MediaQuery.of(context).size.width - 550) / 2, 8),
                  vertical: 24,
                ),
                children: <Widget>[
                  Text(
                    '${pubspec.name} v${pubspec.version}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const Divider(height: 24),
                  TextButton(
                    onPressed: () => launch('https://example.plugfox.dev/router#home/about'),
                    child: const Text('example.plugfox.dev/router'),
                  ),
                  TextButton(
                    onPressed: () => launch('https://github.com/PlugFox/router'),
                    child: const Text('github.com/plugfox/router'),
                  ),
                  TextButton(
                    onPressed: () => launch('https://api.flutter.dev/flutter/widgets/Router-class.html'),
                    child: const Text('api.flutter.dev'),
                  ),
                  const Divider(height: 24),
                ],
              ),
            ),
          ),
        ),
      );
}
