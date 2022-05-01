import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:windshield/styles/theme.dart';

// int createUniqueId() {
//   return DateTime.now().millisecondsSinceEpoch.remainder(100000);
// }

class NotificationWeekAndTime {
  // final int dayOfTheWeek;
  final TimeOfDay timeOfDay;

  NotificationWeekAndTime({
    // required this.dayOfTheWeek,
    required this.timeOfDay,
  });
}

Future<NotificationWeekAndTime?> pickSchedule(BuildContext context) async {
  // List<String> weekdays = [
  //   'จันทร์',
  //   'อังคาร',
  //   'พุธ',
  //   'พฤหัส',
  //   'ศุกร์',
  //   'เสาร์',
  //   'อาทิตย์',
  // ];
  TimeOfDay? timeOfDay;
  DateTime now = DateTime.now();
  // int? selectedDay;

  // await showDialog(
  //   context: context,
  //   builder: (context) {
  //     return AlertDialog(
  //       title: const Text(
  //         'เตือนฉันทุกๆวัน: ',
  //         textAlign: TextAlign.center,
  //       ),
  //       content: Wrap(
  //         alignment: WrapAlignment.center,
  //         spacing: 3,
  //         children: [
  //           for (int index = 0; index < weekdays.length; index++)
  //             ElevatedButton(
  //               onPressed: () {
  //                 selectedDay = index + 1;
  //                 Navigator.pop(context);
  //               },
  //               style: ButtonStyle(
  //                 backgroundColor: MaterialStateProperty.all(
  //                   MyTheme.primaryMajor,
  //                 ),
  //               ),
  //               child: Text(weekdays[index]),
  //             ),
  //         ],
  //       ),
  //     );
  //   },
  // );

  // if (selectedDay != null) {
  //   timeOfDay = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.fromDateTime(
  //       now.add(
  //         const Duration(minutes: 1),
  //       ),
  //     ),
  //     builder: (BuildContext context, Widget? child) {
  //       return Theme(
  //         data: ThemeData(
  //           colorScheme: ColorScheme.light(
  //             primary: MyTheme.primaryMajor,
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );

  //   if (timeOfDay != null) {
  //     const storage = FlutterSecureStorage();
  //     await storage.write(key: 'time', value: timeOfDay.format(context));
  //     return NotificationWeekAndTime(
  //       dayOfTheWeek: selectedDay!,
  //       timeOfDay: timeOfDay,
  //     );
  //   }
  // }

  //--------------------------ลบข้างล่างนี้ถึง...--------------------------
  timeOfDay = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(
      now.add(
        const Duration(minutes: 1),
      ),
    ),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(
            primary: MyTheme.primaryMajor,
          ),
        ),
        child: child!,
      );
    },
  );

  if (timeOfDay != null) {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'time', value: timeOfDay.format(context));
    return NotificationWeekAndTime(
      timeOfDay: timeOfDay,
    );
  }
  //--------------------------ตรงนี้--------------------------

  return null;
}
