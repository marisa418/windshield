import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windshield/utility/icon_convertor.dart';

import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:windshield/main.dart';
import 'package:windshield/models/balance_sheet/balance_sheet.dart';
import 'package:windshield/models/daily_flow/flow.dart';
import 'package:windshield/pages/home/overview/balance_sheet/create_balance.dart';
import 'package:windshield/styles/theme.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:badges/badges.dart';
import 'package:windshield/routes/app_router.dart';


class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SettingHeader(),
        SettingInfo(),
        ResetPassword(),
        ResetPin(),
        SettingCat(),
        SetNotificate(),
        IssueInfo(),
        GuideInfo(),
        LogoutBt(),
        Center(
          child: ElevatedButton(
            onPressed: () async => await ref.read(apiProvider).logout(),
            style: ElevatedButton.styleFrom(
              primary: MyTheme.negativeMajor,
            ),
            child: Text('ออกจากระบบ'),
          ),
        ),
      ],
    );
  }
}

class SettingHeader extends ConsumerWidget {
  const SettingHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
                child: Text(
                  'WINDSHEILD',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      decoration: TextDecoration.none),
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
                child: Text(
                  'คุณ ชื่อผู้ใช้',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      decoration: TextDecoration.none),
                ),
              ),
            ],
          ),
        ]),
        height: 150,
        width: 500,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromARGB(255, 82, 54, 255),
                Color.fromARGB(255, 117, 161, 227),
              ]),
          //borderRadius: BorderRadius.circular(10),
        ));
  }
}

class SettingInfo extends ConsumerWidget {
  const SettingInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: const Icon(
                Icons.edit,
                color: Colors.grey,
                size: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
              child: Text(
                'แก้ไขข้อมูลผู้ใช้',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    decoration: TextDecoration.none),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 125, top: 20),
              child: const Icon(
                Icons.chevron_right_outlined,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class ResetPassword extends ConsumerWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: const Icon(
                Icons.key,
                color: Colors.grey,
                size: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
              child: Text(
                'เปลี่ยนรหัสผ่าน',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    decoration: TextDecoration.none),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 120, top: 20),
              child: const Icon(
                Icons.chevron_right_outlined,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class ResetPin extends ConsumerWidget {
  const ResetPin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: const Icon(
                Icons.key,
                color: Colors.grey,
                size: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
              child: Text(
                'เปลี่ยน PIN',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    decoration: TextDecoration.none),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 158, top: 20),
              child: const Icon(
                Icons.chevron_right_outlined,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class SettingCat extends ConsumerWidget {
  const SettingCat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: const Icon(
                Icons.book,
                color: Colors.grey,
                size: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
              child: Text(
                'จัดการหมวดหมู่',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    decoration: TextDecoration.none),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 114, top: 20),
              child: const Icon(
                Icons.chevron_right_outlined,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class SetNotificate extends ConsumerWidget {
  const SetNotificate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: const Icon(
                Icons.timer,
                color: Colors.grey,
                size: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
              child: Text(
                'การแจ้งเตือนทำ\nบัญชีรายรับ-รายจ่าย',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    decoration: TextDecoration.none),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 105, top: 20),
              child: const Icon(
                Icons.chevron_right_outlined,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class IssueInfo extends ConsumerWidget {
  const IssueInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: const Icon(
                Icons.warning_rounded,
                color: Colors.grey,
                size: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
              child: Text(
                'นโยบายและ\nข้อกำหนดการใช้งาน',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    decoration: TextDecoration.none),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 112, top: 20),
              child: const Icon(
                Icons.chevron_right_outlined,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class GuideInfo extends ConsumerWidget {
  const GuideInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: const Icon(
                Icons.warning_rounded,
                color: Colors.grey,
                size: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
              child: Text(
                'ไกด์การใช้งาน',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    decoration: TextDecoration.none),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 135, top: 20),
              child: const Icon(
                Icons.chevron_right_outlined,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class LogoutBt extends ConsumerWidget {
  const LogoutBt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: const Icon(
                Icons.logout,
                color: Colors.grey,
                size: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
              child: Text(
                'ออกจากระบบ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    decoration: TextDecoration.none),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 108, top: 20),
              child: const Icon(
                Icons.chevron_right_outlined,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}