import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/main.dart';

class DailyFlowPage extends ConsumerWidget {
  const DailyFlowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiDFlow);
    return api.when(
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => Center(child: CircularProgressIndicator()),
      data: (data) {
        return Container();
      },
    );
  }
}
