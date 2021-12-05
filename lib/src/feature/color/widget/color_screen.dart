import 'dart:math' as math;
import 'dart:ui';

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
                      'Selected color: $colorName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6!.copyWith(height: 1),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                  child: _ColorBox(),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      'Select accent',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6!.copyWith(height: 1),
                    ),
                  ),
                ),
                const _AccentContainer(),
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

@immutable
class _AccentContainer extends StatelessWidget {
  const _AccentContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parent = context.findAncestorWidgetOfExactType<ColorScreen>()!;
    final color = parent.color;
    final colorName = parent.colorName;
    return Center(
      child: SizedBox(
        height: 75,
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (bounds) => LinearGradient(
            begin: AlignmentDirectional.centerStart,
            end: AlignmentDirectional.centerEnd,
            stops: const <double>[
              0,
              0.1,
              0.2,
              0.8,
              0.9,
              1,
            ],
            colors: <Color>[
              Colors.transparent,
              Colors.white.withOpacity(0.5),
              Colors.white,
              Colors.white,
              Colors.white.withOpacity(0.5),
              Colors.transparent,
            ],
          ).createShader(
            bounds.shift(Offset(-bounds.left, -bounds.top)),
            textDirection: Directionality.of(context),
          ),
          child: _AccentList(colorName: colorName, color: color),
        ),
      ),
    );
  }
}

class _AccentList extends StatefulWidget {
  const _AccentList({
    required final this.colorName,
    required final this.color,
    Key? key,
  }) : super(key: key);

  final String colorName;
  final MaterialColor color;

  @override
  State<StatefulWidget> createState() => _AccentListState();
}

class _AccentListState extends State<_AccentList> {
  final ScrollBehavior scrollBehavior = const _AccentListScrollBehavior();
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) => ScrollConfiguration(
        behavior: scrollBehavior,
        child: ListView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 50),
          itemExtent: 75,
          children: <Widget>[
            _AccentChip(
              colorName: widget.colorName,
              accent: 50,
              color: widget.color,
            ),
            for (var i = 100; i < 1000; i = i + 100)
              _AccentChip(
                colorName: widget.colorName,
                color: widget.color,
                accent: i,
              ),
          ],
        ),
      );
}

class _AccentListScrollBehavior extends MaterialScrollBehavior {
  const _AccentListScrollBehavior()
      : super(
          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
        );

  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
      };
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
  Widget build(BuildContext context) => SizedBox.square(
        dimension: 75,
        child: IconButton(
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
          icon: CircleAvatar(
            backgroundColor: color[accent],
          ),
        ),
      );
}
