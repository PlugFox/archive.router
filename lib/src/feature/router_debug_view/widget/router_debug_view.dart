import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:router/src/feature/router_debug_view/widget/debug_view_rectangle.dart';
import 'package:router/src/feature/router_debug_view/widget/router_debug_view_controller.dart';

@immutable
class RouterDebugView extends StatelessWidget {
  const RouterDebugView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: AspectRatio(
          aspectRatio: 3 / 1,
          child: ColoredBox(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Scaffold(
              body: LayoutBuilder(
                builder: (context, constraints) => DefaultTextStyle(
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        //color: Theme.of(context).textTheme.bodyText1!.color,
                        fontSize: math.min(16, constraints.maxWidth / 55),
                        height: 1,
                        letterSpacing: -.3,
                      ),
                  child: const _RouterDebugViewLayout(),
                ),
              ),
            ),
          ),
        ),
      );
}

@immutable
class _RouterDebugViewLayout extends StatelessWidget {
  const _RouterDebugViewLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _RouterDebugViewRow(
        children: <Widget>[
          // Операционная система
          const Expanded(
            flex: 2,
            child: DebugComponentContainer(
              title: 'OS',
            ),
          ),
          const SizedBox(width: 6),
          // RouteInformationProvider
          Expanded(
            flex: 6,
            child: DebugComponentContainer(
              title: 'RouteInformationProvider',
              children: <Widget>[
                DebugStatusRectangle(
                  title: 'routerReportsNewRouteInformation()',
                  stream: RouterDebugViewController.instance.onRouterReportsNewRouteInformation,
                ),
                DebugStatusRectangle(
                  title: 'didPushRouteInformation()',
                  stream: RouterDebugViewController.instance.onDidPushRouteInformation,
                ),
                DebugStatusRectangle(
                  title: 'didPushRoute()',
                  stream: RouterDebugViewController.instance.onDidPushRoute,
                ),
                DebugStatusRectangle(
                  title: 'didPopRoute()',
                  stream: RouterDebugViewController.instance.onDidPopRoute,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // RouteInformationParser
          Expanded(
            flex: 6,
            child: DebugComponentContainer(
              title: 'RouteInformationParser',
              children: <Widget>[
                DebugStatusRectangle(
                  title: 'restoreRouteInformation()',
                  stream: RouterDebugViewController.instance.onRestoreRouteInformation,
                ),
                DebugStatusRectangle(
                  title: 'parseRouteInformation()',
                  stream: RouterDebugViewController.instance.onParseRouteInformation,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // RouterDelegate
          Expanded(
            flex: 6,
            child: DebugComponentContainer(
              title: 'RouterDelegate',
              children: <Widget>[
                DebugStatusRectangle(
                  title: 'setNewRoutePath()',
                  stream: RouterDebugViewController.instance.onSetNewRoutePath,
                ),
                DebugStatusRectangle(
                  title: 'setRestoredRoutePath()',
                  stream: RouterDebugViewController.instance.onSetRestoredRoutePath,
                ),
                DebugStatusRectangle(
                  title: 'setInitialRoutePath()',
                  stream: RouterDebugViewController.instance.onSetInitialRoutePath,
                ),
                DebugStatusRectangle(
                  title: 'popRoute()',
                  stream: RouterDebugViewController.instance.onPopRoute,
                ),
                DebugStatusRectangle(
                  title: 'onPopPage()',
                  stream: RouterDebugViewController.instance.onPopPage,
                ),
                DebugStatusRectangle(
                  title: 'build()',
                  stream: RouterDebugViewController.instance.onBuild,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Колонка состояния и роутера
          const Expanded(
            flex: 2,
            child: DebugComponentContainer(
              title: 'Router',
            ),
          ),
        ],
      );
}

@immutable
class _RouterDebugViewRow extends StatelessWidget {
  const _RouterDebugViewRow({
    required final this.children,
    Key? key,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
}
/*
@immutable
class _RouterDebugViewColumn extends StatelessWidget {
  const _RouterDebugViewColumn({
    required final this.children,
    Key? key,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
}
*/
