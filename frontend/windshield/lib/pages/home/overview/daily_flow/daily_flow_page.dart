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
        return Scaffold(
          body: Column(
            children: [
              const DailyList(),
              Container(
                height: 100,
                color: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}

class DailyList extends ConsumerWidget {
  const DailyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incWorking = ref.watch(provDFlow);
    return Expanded(
      child: SingleChildScrollView(
          child: Column(
        children: [
          Container(color: Colors.pink, height: 200),
          Container(color: Colors.red, height: 200),
          GridView.builder(
            shrinkWrap: true,
            itemCount: incWorking.incWorkingList.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200),
            itemBuilder: (_, index) {
              print(index);
              return Container(height: 50, width: 50, color: Colors.purple);
            },
          ),
        ],
      )),
    );
  }
}
