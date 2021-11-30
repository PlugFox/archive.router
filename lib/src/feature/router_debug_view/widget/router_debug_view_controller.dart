import 'dart:async';

import 'package:meta/meta.dart';

abstract class _RouterDebugViewControllerBase {
  /// Контроллер
  StreamController<Message> get _sink;

  /// Поток событий с топиками
  Stream<Message> get _stream;

  /// Добавить топик
  void _addMessage(String topic, [String? message]) => _sink.add(Message(topic, message));

  /// Подписаться на топик
  Stream<String> _onTopic(String topic) =>
      _stream.where((msg) => msg.topic == topic).map<String>((msg) => '${msg.topic}(${msg.message ?? ''})');
}

@immutable
class Message {
  const Message(this.topic, [this.message]);
  final String topic;
  final String? message;
}

class RouterDebugViewController extends _RouterDebugViewControllerBase
    with
        _DebugBackButtonDispatcher,
        _DebugRouteInformationProvider,
        _DebugRouteInformationParser,
        _DebugRouterDelegate {
  // ignore: prefer_constructors_over_static_methods
  static RouterDebugViewController get instance => _instance ??= RouterDebugViewController._();
  static RouterDebugViewController? _instance;
  RouterDebugViewController._()
      : _sink = StreamController<Message>.broadcast(),
        _controller = StreamController<Message>.broadcast() {
    _sink.stream.transform<Message>(const _IntervalStreamTransformer(Duration(milliseconds: 250))).pipe(_controller);
  }

  @override
  final StreamController<Message> _sink;

  final StreamController<Message> _controller;

  @override
  Stream<Message> get _stream => _controller.stream;
}

/// BackButtonDispatcher
mixin _DebugBackButtonDispatcher on _RouterDebugViewControllerBase {
  void backButtonDispatcher() => _addMessage('backButton');
  Stream<String> get onBackButtonDispatcher => _onTopic('backButton');
}

/// RouteInformationProvider
mixin _DebugRouteInformationProvider on _RouterDebugViewControllerBase {
  void routerReportsNewRouteInformation(String message) => _addMessage('routerReportsNewRouteInformation', message);
  Stream<String> get onRouterReportsNewRouteInformation => _onTopic('routerReportsNewRouteInformation');
  void didPushRouteInformation(String message) => _addMessage('didPushRouteInformation', message);
  Stream<String> get onDidPushRouteInformation => _onTopic('didPushRouteInformation');
  void didPushRoute(String message) => _addMessage('didPushRoute', message);
  Stream<String> get onDidPushRoute => _onTopic('didPushRoute');
  void didPopRoute() => _addMessage('didPopRoute');
  Stream<String> get onDidPopRoute => _onTopic('didPopRoute');
}

/// RouteInformationParser
mixin _DebugRouteInformationParser on _RouterDebugViewControllerBase {
  void restoreRouteInformation(String message) => _addMessage('restoreRouteInformation', message);
  Stream<String> get onRestoreRouteInformation => _onTopic('restoreRouteInformation');
  void parseRouteInformation(String message) => _addMessage('parseRouteInformation', message);
  Stream<String> get onParseRouteInformation => _onTopic('parseRouteInformation');
}

/// RouterDelegate
mixin _DebugRouterDelegate on _RouterDebugViewControllerBase {
  void setNewRoutePath(String message) => _addMessage('setNewRoutePath', message);
  Stream<String> get onSetNewRoutePath => _onTopic('setNewRoutePath');
  void setRestoredRoutePath(String message) => _addMessage('setRestoredRoutePath', message);
  Stream<String> get onSetRestoredRoutePath => _onTopic('setRestoredRoutePath');
  void setInitialRoutePath(String message) => _addMessage('setInitialRoutePath', message);
  Stream<String> get onSetInitialRoutePath => _onTopic('setInitialRoutePath');
  void popRoute() => _addMessage('popRoute');
  Stream<String> get onPopRoute => _onTopic('popRoute');
  void popPage(String message) => _addMessage('onPopPage', message);
  Stream<String> get onPopPage => _onTopic('onPopPage');
  void build() => _addMessage('build');
  Stream<String> get onBuild => _onTopic('build');
}

class _IntervalStreamTransformer extends StreamTransformerBase<Message, Message> {
  const _IntervalStreamTransformer([Duration duration = const Duration(milliseconds: 500)]) : _duration = duration;

  final Duration _duration;

  @override
  Stream<Message> bind(Stream<Message> stream) {
    StreamSubscription<Message>? sub;
    final sc = StreamController<Message>.broadcast(
      onCancel: () => sub?.cancel(),
    );
    var next = DateTime.now();
    sub = stream.asyncMap<Message>((msg) async {
      final now = DateTime.now();
      if (next.isBefore(now)) {
        next = now.add(_duration);
      } else {
        final diff = next.difference(now).abs();
        final currentDelay = (_duration - diff).abs();
        next = next.add(_duration);
        await Future<void>.delayed(currentDelay);
      }
      return msg;
    }).listen(
      sc.add,
      onDone: sc.close,
      onError: sc.addError,
      cancelOnError: true,
    );
    return sc.stream;
  }
}
