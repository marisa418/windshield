import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';
import '../statement_page.dart';

class Date extends ConsumerWidget {
  const Date({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: MyTheme.majorBackground,
        ),
      ),
      child: Column(
        children: const [
          Flexible(
            flex: 15,
            child: Header(),
          ),
          Flexible(
            flex: 70,
            child: DatePicker(),
          ),
          Flexible(
            flex: 15,
            child: Footer(),
          ),
        ],
      ),
    );
  }
}

class Header extends ConsumerWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final start = ref.watch(provStatement.select((e) => e.start));
    final end = ref.watch(provStatement.select((e) => e.end));
    final diff = ref.watch(provStatement.select((e) => e.getDateDiff()));
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text('เริ่มต้นงบ', style: MyTheme.whiteTextTheme.bodyText1),
                Text(
                  DateFormat('dd MMM y').format(start),
                  style: MyTheme.whiteTextTheme.headline4,
                ),
              ],
            ),
            Column(
              children: [
                Text('รวม', style: MyTheme.whiteTextTheme.bodyText1),
                Text(
                  diff.toString(),
                  style: MyTheme.whiteTextTheme.headline4,
                ),
              ],
            ),
            Column(
              children: [
                Text('สิ้นสุดงบ', style: MyTheme.whiteTextTheme.bodyText1),
                Text(
                  DateFormat('dd MMM y').format(end),
                  style: MyTheme.whiteTextTheme.headline4,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class DatePicker extends ConsumerStatefulWidget {
  const DatePicker({Key? key}) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends ConsumerState<DatePicker> {
  final DateRangePickerController _controller = DateRangePickerController();
  @override
  Widget build(BuildContext context) {
    return SfDateRangePicker(
      controller: _controller,
      selectionMode: DateRangePickerSelectionMode.range,
      minDate: ref.watch(provStatement).minDate,
      maxDate: ref.watch(provStatement).maxDate,
      initialSelectedRange: PickerDateRange(
        ref.watch(provStatement).start,
        ref.watch(provStatement).end,
      ),
      allowViewNavigation: false,
      headerStyle: DateRangePickerHeaderStyle(
        textAlign: TextAlign.center,
        textStyle: MyTheme.whiteTextTheme.headline2,
      ),
      headerHeight: 100,
      monthViewSettings: DateRangePickerMonthViewSettings(
        viewHeaderStyle: DateRangePickerViewHeaderStyle(
          textStyle: MyTheme.whiteTextTheme.headline4,
        ),
      ),
      monthCellStyle: DateRangePickerMonthCellStyle(
        textStyle: MyTheme.whiteTextTheme.headline4,
      ),
      selectionRadius: 30,
      rangeSelectionColor: Colors.white.withOpacity(.2),
      startRangeSelectionColor: Colors.white,
      endRangeSelectionColor: Colors.white,
      selectionTextStyle: MyTheme.whiteTextTheme.headline4!.merge(
        TextStyle(color: MyTheme.primaryMajor),
      ),
      rangeTextStyle: MyTheme.whiteTextTheme.headline4!.merge(
        TextStyle(color: MyTheme.primaryMajor),
      ),
      onSelectionChanged: (args) {
        _controller.selectedRange = PickerDateRange(
          ref.watch(provStatement).minDate,
          args.value.endDate,
        );
        ref.read(provStatement).setStart(ref.watch(provStatement).minDate);
        if (args.value.endDate != null) {
          ref.read(provStatement).setEnd(args.value.endDate);
        }
      },
    );
  }
}

class Footer extends ConsumerWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Container(
              width: 140,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.arrow_left,
                    color: MyTheme.primaryMajor,
                  ),
                  Text(
                    'ย้อนกลับ',
                    style: MyTheme.whiteTextTheme.headline3!.merge(
                      TextStyle(color: MyTheme.primaryMajor),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => AutoRouter.of(context).pop(),
          ),
          GestureDetector(
            child: Container(
              width: 140,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'ถัดไป',
                    style: MyTheme.whiteTextTheme.headline3!.merge(
                      TextStyle(color: MyTheme.primaryMajor),
                    ),
                  ),
                  Icon(
                    Icons.arrow_right,
                    color: MyTheme.primaryMajor,
                  ),
                ],
              ),
            ),
            onTap: () async {
              final canCreate = ref.read(provStatement).canCreateStmnt();
              if (canCreate.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(canCreate)),
                );
              } else {
                showDialog(
                  useRootNavigator: false,
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                        'เมื่อกดปุ่มยืนยันแล้วท่านจะไม่สามารถกลับมาแก้ไขระยะเวลาได้'),
                    actions: [
                      TextButton(
                        child: const Text('ยกเลิก'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('ยืนยัน'),
                        onPressed: () async {
                          final id =
                              await ref.read(apiProvider).createStatement(
                                    'แผนการเงิน',
                                    ref.read(provStatement).start,
                                    ref.read(provStatement).end,
                                  );
                          if (id != '') {
                            AutoRouter.of(context).pop();
                            ref.read(provStatement).setStmntId(id);
                            ref.read(provStatement).setStmntCreatePageIdx(1);
                            ref.read(provStatement).setNeedFetchAPI();
                          } else {
                            AutoRouter.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('เกิดข้อผิดพลาด')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
