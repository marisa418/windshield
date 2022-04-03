import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/balance_sheet/balance_sheet.dart';

final apiBSheet = FutureProvider.autoDispose<BSheetBalance?>((ref) async {
  ref.watch(provBSheet.select((value) => value.needFetchAPI));
  final data = await ref.read(apiProvider).getBalanceSheet();
  final data2 = await ref.read(apiProvider).getAllCategories(false);
  ref.read(provBSheet).setBs(data!);
  ref.read(provBSheet).setCat(data2);
  ref.read(provBSheet).setBsType();
  ref.read(provBSheet).setCatType();
  return data;
});

class BalanceSheetPage extends ConsumerWidget {
  const BalanceSheetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiBSheet);
    return api.when(
      error: (error, stackTrace) => Text(stackTrace.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (_) {
        return Container();
      },
    );
  }
}
