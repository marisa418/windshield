import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/statement/category.dart';
import 'package:windshield/providers/budget_provider.dart';
import 'date.dart';
import 'budget_determine/budget_determine.dart';
import '../statement_page.dart';

final provBudget = ChangeNotifierProvider.autoDispose<BudgetProvider>(
    (ref) => BudgetProvider());

final apiCat = FutureProvider.autoDispose<List<StmntCategory>>((ref) async {
  final data = await ref.read(apiProvider).getAllCategories(true);
  ref.read(provBudget).setCatList(data);
  ref.read(provBudget).setCategoryTypeTabs();
  return data;
});

class StatementCreatePage extends ConsumerWidget {
  const StatementCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provBudget.select((e) => e.catList));
    final api = ref.watch(apiCat);
    return api.when(
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (data) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: IndexedStack(
              index:
                  ref.watch(provStatement.select((e) => e.stmntCreatePageIdx)),
              children: const [
                Date(),
                BudgetDetermine(),
              ],
            ),
          ),
        );
      },
    );
  }
}
