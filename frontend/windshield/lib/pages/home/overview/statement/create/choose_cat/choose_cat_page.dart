import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/routes/app_router.dart';
import 'header.dart';
import 'choose_cat.dart';

class ChooseCatPage extends ConsumerWidget {
  const ChooseCatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryApi = ref.watch(providerCategoryApi);
    return categoryApi.when(
      error: (error, stackTrace) => Text('Text : $error'),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (data) {
        return SingleChildScrollView(
          child: Column(
            children: const [
              Header(),
              ChooseCat(),
            ],
          ),
        );
      },
    );
  }
}
