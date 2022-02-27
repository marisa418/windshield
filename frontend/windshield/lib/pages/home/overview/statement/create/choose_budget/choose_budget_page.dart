import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/budget.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/routes/app_router.dart';
import 'header/header.dart';
import 'budget_determine.dart';

class ChooseBudgetPage extends ConsumerWidget {
  const ChooseBudgetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Create a provider first, so it won't get disposed when it's being called.
    ref.watch(providerCategory.select((value) => value.categoryList));

    final categoryApi = ref.watch(providerCategoryApi);
    return categoryApi.when(
      error: (error, stackTrace) => Text('Text : $error'),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (data) {
        return SingleChildScrollView(
          child: Column(
            children: const [
              Header(),
              BudgetDetermine(),
              Footer(),
            ],
          ),
        );
      },
    );
  }
}

class Footer extends ConsumerWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statement = ref.read(providerStatement);
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              if (ref.read(providerStatement).skipDatePage) {
                AutoRouter.of(context).popUntilRouteWithName('StatementRoute');
              } else {
                ref.read(providerStatement).setCreatePageIndex(0);
              }
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
            child: SizedBox(
              width: 125,
              child: Text(
                'ย้อนกลับ',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2!.merge(
                      TextStyle(color: Colors.white),
                    ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final res = await ref.read(apiProvider).createStatement(
                    statement.startDate,
                    statement.endDate,
                    ref.watch(providerCategory).budgetList,
                  );
              if (res) {
                ref.read(providerStatement).setNeedUpdate();
                AutoRouter.of(context).popUntilRouteWithName('StatementRoute');
              }
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),
            ),
            child: SizedBox(
              width: 125,
              child: Text(
                'บันทึก',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2!.merge(
                      const TextStyle(color: Colors.white),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
