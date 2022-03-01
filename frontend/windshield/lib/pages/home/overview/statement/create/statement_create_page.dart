import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import 'package:windshield/main.dart';
import 'date_page.dart';
import 'choose_budget/choose_budget_page.dart';

class StatementCreatePage extends ConsumerWidget {
  const StatementCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider =
        ref.watch(providerStatement.select((value) => value.createPageIndex));
    return WillPopScope(
      onWillPop: () async {
        if (ref.read(providerStatement).statementList.length != 1) {
          return true;
        }
        AutoRouter.of(context).popUntilRouteWithName('HomeRoute');
        return false;
      },
      child: Scaffold(
        body: IndexedStack(
          index: provider,
          children: const [
            DatePage(),
            ChooseBudgetPage(),
          ],
        ),
      ),
    );
  }
}
