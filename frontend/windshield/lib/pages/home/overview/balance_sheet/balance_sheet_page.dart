import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/balance_sheet/balance_sheet.dart';

final apiBSheet = FutureProvider.autoDispose<BSheetBalance?>((ref) async {
  ref.watch(provBSheet.select((value) => value.needFetchAPI));
  final data = await ref.read(apiProvider).getBalanceSheet();
  ref.read(provBSheet).setBs(data!);
  ref.read(provBSheet).setBsType();
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
