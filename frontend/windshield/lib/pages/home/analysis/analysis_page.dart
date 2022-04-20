import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Analysis extends ConsumerWidget {
  const Analysis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        Container(
          height: 500,
          color: Colors.red,
        ),
        Container(
          height: 500,
          color: Colors.green,
        ),
      ],
    );
  }
}
