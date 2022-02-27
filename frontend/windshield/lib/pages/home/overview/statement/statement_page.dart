import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import 'package:windshield/main.dart';
import './create/statement_create_page.dart';
import './overview/statement_overview_page.dart';
import 'package:windshield/routes/app_router.dart';

class StatementPage extends ConsumerWidget {
  const StatementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //When user create new statement,
    //needUpdated will notify this Widget to call api again
    // ref.watch(providerStatement.select((value) => value.needUpdated));

    final apiStatement = ref.watch(providerStatementApi);
    return apiStatement.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text('Text : $error'),
      data: (data) {
        if (data.length == 1) {
          SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
            AutoRouter.of(context).push(const StatementCreateRoute());
          });
        }
        return const StatementOverviewPage();
        // if (data.length == 1) {
        //   return const StatementCreatePage();
        // } else {
        //   return const StatementOverviewPage();
        // }
      },
    );
  }
}
