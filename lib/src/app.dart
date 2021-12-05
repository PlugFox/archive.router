import 'package:flutter/material.dart';
import 'package:router/src/common/widget/app_material_context.dart';
import 'package:router/src/feature/router_debug_view/widget/router_debug_view_switch.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  static void run() => runApp(
        const App(),
      );

  @override
  Widget build(BuildContext context) => const RouterDebugViewSwitch(
        enabled: true,
        child: AppMaterialContext(),
      );
}
