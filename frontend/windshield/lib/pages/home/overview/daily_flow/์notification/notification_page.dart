import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../styles/theme.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: MyTheme.majorBackground,
                ),
              ),
              child: Container(
                child: Column(
                  children: const [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
                      child: Text(
                        'ถึงเวลาบันทึกบัญชีราย \nรับ-รายจ่ายของคุณเเล้ว',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          decoration: TextDecoration.none,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
