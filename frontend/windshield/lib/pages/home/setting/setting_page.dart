import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_route/auto_route.dart';

import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/routes/app_router.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: const [
        SettingHeader(),
        SettingInfo(),
        ChangePassword(),
        ResetPin(),
        // SetNotificate(),
        // IssueInfo(),
        // GuideInfo(),
        LogoutBt(),
      ],
    );
  }
}

class SettingHeader extends ConsumerWidget {
  const SettingHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(apiProvider.select((e) => e.user));
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
                child: Text(
                  'WINDSHEILD',
                  style: MyTheme.whiteTextTheme.headline2,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
                child: Text(
                  'คุณ ${user?.userId}',
                  style: MyTheme.whiteTextTheme.headline2,
                ),
              ),
            ],
          ),
        ],
      ),
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: MyTheme.majorBackground,
        ),
        //borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class SettingInfo extends ConsumerWidget {
  const SettingInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 70,
      child: Row(
        children: const [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Icon(
              Icons.edit,
              color: Colors.grey,
              size: 30,
            ),
          ),
          Flexible(
            flex: 7,
            fit: FlexFit.tight,
            child: Text(
              'แก้ไขข้อมูลผู้ใช้',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  decoration: TextDecoration.none),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Icon(
              Icons.chevron_right_outlined,
              color: Colors.grey,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class ChangePassword extends ConsumerWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => AutoRouter.of(context).push(OTPRoute(type: 0)),
      child: SizedBox(
        height: 70,
        child: Row(
          children: const [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.key,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
            ),
            Flexible(
              flex: 7,
              fit: FlexFit.tight,
              child: Text(
                'เปลี่ยนรหัสผ่าน',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    decoration: TextDecoration.none),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Icon(
                Icons.chevron_right_outlined,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPin extends ConsumerWidget {
  const ResetPin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => AutoRouter.of(context).push(OTPRoute(type: 1)),
      child: SizedBox(
        height: 70,
        child: Row(
          children: const [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Center(
                child: Icon(
                  Icons.password,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
            ),
            Flexible(
              flex: 7,
              fit: FlexFit.tight,
              child: Text(
                'เปลี่ยน PIN',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    decoration: TextDecoration.none),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Icon(
                Icons.chevron_right_outlined,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingCat extends ConsumerWidget {
  const SettingCat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 70,
      child: Row(
        children: const [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Center(
              child: Icon(
                Icons.book,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ),
          Flexible(
            flex: 7,
            fit: FlexFit.tight,
            child: Text(
              'จัดการหมวดหมู่',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  decoration: TextDecoration.none),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Icon(
              Icons.chevron_right_outlined,
              color: Colors.grey,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class SetNotificate extends ConsumerWidget {
  const SetNotificate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 70,
      child: Row(
        children: const [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Center(
              child: Icon(
                Icons.timer,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ),
          Flexible(
            flex: 7,
            fit: FlexFit.tight,
            child: Text(
              'การแจ้งเตือนทำ\nบัญชีรายรับ-รายจ่าย',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  decoration: TextDecoration.none),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Icon(
              Icons.chevron_right_outlined,
              color: Colors.grey,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class IssueInfo extends ConsumerWidget {
  const IssueInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 70,
      child: Row(
        children: const [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Center(
              child: Icon(
                Icons.warning_rounded,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ),
          Flexible(
            flex: 7,
            fit: FlexFit.tight,
            child: Text(
              'นโยบายและ\nข้อกำหนดการใช้งาน',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  decoration: TextDecoration.none),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Icon(
              Icons.chevron_right_outlined,
              color: Colors.grey,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class GuideInfo extends ConsumerWidget {
  const GuideInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 70,
      child: Row(
        children: const [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Center(
              child: Icon(
                Icons.menu_book_rounded,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ),
          Flexible(
            flex: 7,
            fit: FlexFit.tight,
            child: Text(
              'ไกด์การใช้งาน',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  decoration: TextDecoration.none),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Icon(
              Icons.chevron_right_outlined,
              color: Colors.grey,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class LogoutBt extends ConsumerWidget {
  const LogoutBt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async => await ref.read(apiProvider).logout(),
      child: SizedBox(
        height: 70,
        child: Row(
          children: const [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Center(
                child: Icon(
                  Icons.logout,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
            ),
            Flexible(
              flex: 7,
              fit: FlexFit.tight,
              child: Text(
                'ออกจากระบบ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    decoration: TextDecoration.none),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Icon(
                Icons.chevron_right_outlined,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
