import 'package:router/runner_stub.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'package:router/runner_io.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'package:router/runner_web.dart' as runner;

void main() => runner.run();
