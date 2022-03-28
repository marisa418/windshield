import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        onPressed: () async => await ref.read(apiProvider).logout(),
        style: ElevatedButton.styleFrom(
          primary: MyTheme.negativeMajor,
        ),
        child: Text('ออกจากระบบ'),
      ),
    );
  }
}
