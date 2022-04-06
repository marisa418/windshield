import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:date_picker_timeline/extra/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windshield/pages/home/overview/statement/create/date.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/icon_convertor.dart';

class DailyFlowOverviewPage extends ConsumerWidget {
  const DailyFlowOverviewPage({Key? key}) : super(key: key);
  getCurrentDate() {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";

    return formattedDate; //DateFormat.MMMd().format(today)
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 170,
                    width: 450,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Theme.of(context).primaryColor,
                            MyTheme.kToDark.shade300,
                          ]),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
                              child: Text(
                                'บัญชีรายรับ-รายจ่าย',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 10.0, 0.0, 0.0),
                          child: Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                              ),
                              children: [
                                const WidgetSpan(
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: '${getCurrentDate()}',
                                )
                              ],
                            ),
                          ),
                        ),
                        //DatePickerTimeline(),
                      ],
                    ),
                  ),
                ],
              ),
              Container(color: Colors.white, height: 170),
            ],
          ),
        ),
      ),
    );
  }
}

/*class DatePickerTimeline extends ConsumerWidget {
  var monthTextStyle;

  var currentDate;

  var width;

  var height;

  var dayTextStyle;

  var dateTextStyle;

  var selectionColor;

  var daysCount;

  var onDateChange;

  var locale;

  Date datetime;

  DatePickerTimeline({
    required this.datetime,
    Key? key,
    this.width,
    this.height = 80,
    this.monthTextStyle = defaultMonthTextStyle,
    this.dayTextStyle = defaultDayTextStyle,
    this.dateTextStyle = defaultDateTextStyle,
    this.selectionColor = AppColors.defaultSelectionColor,
    this.daysCount = 50000,
    this.onDateChange,
    this.locale,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DatePickerTimeline(
          DateTime.now(),
          onDateChange: (date) {
            // New date selected
            print(date.day.toString());
          },
        ),
      ],
    );
  }
}
*/