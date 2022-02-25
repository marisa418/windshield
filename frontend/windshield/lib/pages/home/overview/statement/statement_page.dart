import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/main.dart';
import './create/statement_create_page.dart';
import './overview/statement_overview_page.dart';

class StatementPage extends ConsumerWidget {
  const StatementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiStatement = ref.watch(providerStatementApi);
    return apiStatement.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text('Text : $error'),
      data: (data) {
        if (data.length == 1) {
          return const StatementCreatePage();
        } else {
          return const StatementOverviewPage();
        }
      },
    );
  }
}
