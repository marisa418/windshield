import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:auto_route/auto_route.dart';

import 'package:windshield/styles/theme.dart';
import 'package:windshield/main.dart';
import 'package:windshield/routes/app_router.dart';

class DatePage extends ConsumerWidget {
  const DatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.read(providerStatement).skipDatePage) {
      SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(
              'TEST TEXT',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4!.merge(
                    const TextStyle(
                      color: Colors.black,
                    ),
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () => AutoRouter.of(context).pop(),
                child: const Text('ยืนยัน'),
              ),
            ],
          ),
        );
      });
    }
    return const Date();
  }
}

class Date extends ConsumerWidget {
  const Date({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statement = ref.watch(providerStatement);
    final dateRange = statement.getDateDiff();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            MyTheme.kToDark.shade200,
          ],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'ระยะเวลา ${dateRange.toString()} วัน',
                  style: Theme.of(context).textTheme.headline2!.merge(
                        TextStyle(
                          color: dateRange <= 20 ? Colors.red : Colors.green,
                        ),
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'เริ่มต้นงบ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .merge(const TextStyle(color: Colors.white)),
                        ),
                        Text(
                          statement.startDate,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .merge(const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'สิ้นสุดงบ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .merge(const TextStyle(color: Colors.white)),
                        ),
                        Text(
                          statement.endDate,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .merge(const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          const Flexible(
            flex: 7,
            child: DatePicker(),
          ),
        ],
      ),
    );
  }
}

class DatePicker extends ConsumerWidget {
  const DatePicker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SfDateRangePicker(
      selectionMode: DateRangePickerSelectionMode.range,
      selectionRadius: 20,
      allowViewNavigation: false,
      headerHeight: 100,
      minDate: DateTime.now(),
      maxDate: ref.read(providerStatement).twoMonthLimited
          ? DateTime(
              DateTime.now().year,
              DateTime.now().month + 2,
              0,
            )
          : null,
      headerStyle: DateRangePickerHeaderStyle(
        textAlign: TextAlign.center,
        textStyle: Theme.of(context)
            .textTheme
            .headline1!
            .merge(const TextStyle(color: Colors.white)),
      ),
      selectionTextStyle: Theme.of(context).textTheme.bodyText1!.merge(
            TextStyle(fontSize: 27, color: MyTheme.kToDark.shade500),
          ),
      rangeTextStyle: Theme.of(context).textTheme.bodyText1!.merge(
            const TextStyle(fontSize: 27, color: Colors.white70),
          ),
      startRangeSelectionColor: Colors.white,
      endRangeSelectionColor: Colors.white,
      rangeSelectionColor: Colors.white.withOpacity(.2),
      monthViewSettings: DateRangePickerMonthViewSettings(
        // viewHeaderHeight: 100,
        showTrailingAndLeadingDates: true,
        dayFormat: 'EEE',

        viewHeaderStyle: DateRangePickerViewHeaderStyle(
          textStyle: Theme.of(context).textTheme.headline2!.merge(
                const TextStyle(color: Colors.white, fontSize: 15),
              ),
        ),
      ),
      monthCellStyle: DateRangePickerMonthCellStyle(
        textStyle: Theme.of(context).textTheme.bodyText1!.merge(
              const TextStyle(color: Colors.white, fontSize: 24),
            ),
        todayTextStyle: Theme.of(context).textTheme.bodyText1!.merge(
              const TextStyle(color: Colors.white, fontSize: 24),
            ),
        todayCellDecoration: const ShapeDecoration(
          shape: CircleBorder(),
          color: Colors.transparent,
        ),
        disabledDatesTextStyle: Theme.of(context).textTheme.bodyText1!.merge(
              const TextStyle(fontSize: 18, color: Colors.grey),
            ),
        trailingDatesTextStyle: Theme.of(context).textTheme.bodyText1!.merge(
              const TextStyle(fontSize: 20, color: Colors.white70),
            ),
        leadingDatesTextStyle: Theme.of(context).textTheme.bodyText1!.merge(
              const TextStyle(fontSize: 20, color: Colors.white70),
            ),
      ),
      showActionButtons: true,
      showTodayButton: true,
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        if (args.value is PickerDateRange) {
          ref.read(providerStatement).setStartDate(
              DateFormat('yyyy-MM-dd').format(args.value.startDate));
          ref.read(providerStatement).setEndDate(DateFormat('yyyy-MM-dd')
              .format(args.value.endDate ?? args.value.startDate));
        }
      },
      confirmText: 'บันทึก',
      cancelText: 'ย้อนกลับ',
      onSubmit: (value) {
        if (ref.read(providerStatement).getDateDiff() < 21) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'กรุณาสร้างแผนอย่างต่ำ 21 วัน',
              ),
            ),
          );
        } else {
          ref.read(providerStatement).setCreatePageIndex(1);
        }
      },
      onCancel: () {
        AutoRouter.of(context).pop();
      },
    );
  }
}
