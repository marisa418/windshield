import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/financial_goal/financial_goal.dart';
import 'package:windshield/providers/financial_goal_provider.dart';

final provFGoal = ChangeNotifierProvider.autoDispose<FinancialGoalProvider>(
    (ref) => FinancialGoalProvider());

final apiFGoal = FutureProvider.autoDispose<List<FGoal>>((ref) async {
  // ref.watch(provFGoal.select((value) => value.needFetchAPI));
  final data = await ref.read(apiProvider).getAllGoals();
  return data;
});

class FinancialGoalPage extends ConsumerWidget {
  const FinancialGoalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiFGoal);
    return api.when(
      error: (error, stackTrace) => Text(stackTrace.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (data) {
        print(data[0].goalDate);
        return Container();
      },
    );
  }
}
