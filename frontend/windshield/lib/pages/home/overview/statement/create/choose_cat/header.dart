import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/styles/theme.dart';

class Header extends ConsumerWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 450,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        // textDirection: TextDirection.LTR,
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      MyTheme.kToDark.shade300,
                    ]),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              // margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
