import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/main.dart';
import 'date.dart';
import 'budget_determine.dart';

class StatementCreatePage extends ConsumerWidget {
  const StatementCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: ref.watch(provStatement.select((e) => e.stmntCreatePageIdx)),
          children: const [
            Date(),
            BudgetDetermine(),
          ],
        ),
      ),
    );
  }
}
