import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/main.dart';
import 'date_page.dart';
import 'choose_budget/choose_budget_page.dart';

class StatementCreatePage extends ConsumerWidget {
  const StatementCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider =
        ref.watch(providerStatement.select((value) => value.createPageIndex));
    return Scaffold(
      body: IndexedStack(
        index: provider,
        children: const [
          DatePage(),
          ChooseBudgetPage(),
        ],
      ),
    );
  }
}
