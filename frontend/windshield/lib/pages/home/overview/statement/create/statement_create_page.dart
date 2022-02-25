import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/main.dart';
import 'date_page.dart';
import 'choose_cat_page.dart';

class StatementCreatePage extends ConsumerWidget {
  const StatementCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: IndexedStack(
        index: ref.watch(providerStatement).createPageIndex,
        children: const [
          DatePage(),
          ChooseCatPage(),
        ],
      ),
    );
  }
}
