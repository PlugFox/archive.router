import 'dart:async';

import 'package:flutter/material.dart';

@immutable
class DebugComponentContainer extends StatelessWidget {
  const DebugComponentContainer({
    required final String title,
    final List<Widget> children = const <Widget>[],
    Key? key,
  })  : _title = title,
        _children = children,
        super(key: key);

  final String _title;
  final List<Widget> _children;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: _children.isEmpty ? Colors.lightGreenAccent : Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: _children.isEmpty ? Colors.lightGreen : Colors.lightBlue,
            style: BorderStyle.solid,
          ),
          boxShadow: kElevationToShadow[2],
        ),
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    _title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              if (_children.isNotEmpty)
                const Divider(
                  height: 1,
                  thickness: 0.5,
                  color: Colors.black54,
                ),
              for (final child in _children)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: child,
                  ),
                ),
            ],
          ),
        ),
      );
}

@immutable
class DebugStatusRectangle extends StatefulWidget {
  const DebugStatusRectangle({
    required final String title,
    required final Stream<String> stream,
    Key? key,
  })  : _title = title,
        _stream = stream,
        super(key: key);

  final String _title;
  final Stream<String> _stream;

  @override
  State<DebugStatusRectangle> createState() => _DebugStatusRectangleState();
}

class _DebugStatusRectangleState extends State<DebugStatusRectangle> with SingleTickerProviderStateMixin {
  static final Animatable<Color?> _background = TweenSequence<Color?>(
    <TweenSequenceItem<Color?>>[
      TweenSequenceItem<Color?>(
        weight: 3,
        tween: ColorTween(
          begin: Colors.transparent,
          end: Colors.green.withOpacity(0.25),
        ),
      ),
      TweenSequenceItem(
        weight: 2,
        tween: ColorTween(
          begin: Colors.green.withOpacity(0.25),
          end: Colors.green.withOpacity(0.75),
        ),
      ),
    ],
  );

  late AnimationController _controller;
  StreamSubscription<String>? _sub;

  //region Lifecycle
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 0,
      reverseDuration: const Duration(milliseconds: 1000),
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _controller.reverse();
          }
        },
      );
    _sub = widget._stream.listen((event) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    _sub?.cancel();
    super.dispose();
  }
  //endregion

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => SizedBox.shrink(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: ColoredBox(
              color: _background.evaluate(
                    AlwaysStoppedAnimation<double>(_controller.value),
                  ) ??
                  Colors.transparent,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: child,
                ),
              ),
            ),
          ),
        ),
        child: StreamBuilder<String>(
          stream: widget._stream,
          builder: (context, snapshot) {
            final data = snapshot.data;
            final fallback = Text(
              widget._title,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.black,
              ),
            );
            return data != null && data.isNotEmpty
                ? AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      if (_controller.isAnimating) {
                        return Text(
                          data,
                          maxLines: 1,
                          key: ValueKey<String>(data),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        );
                      }
                      return fallback;
                    },
                  )
                : fallback;
          },
        ),
      );
}
