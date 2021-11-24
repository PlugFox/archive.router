import 'package:flutter/material.dart';
import 'package:router/src/common/router/router.dart';

@immutable
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  void pop(BuildContext context) => AppRouter.canPop(context) ? AppRouter.maybePop(context) : AppRouter.goHome(context);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => pop(context),
          ),
          title: const Text('Не найдено'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 75,
                  child: Text(
                    'Ошибка 404: Контент отсутсвует',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 75,
                  child: ElevatedButton.icon(
                    onPressed: () => pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                    label: const Text(
                      'Вернуться',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
