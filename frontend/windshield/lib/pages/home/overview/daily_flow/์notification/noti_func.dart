import 'package:awesome_notifications/awesome_notifications.dart';

import 'noti_utility.dart';

/*Future<void> createPlantFoodNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title:
          '${Emojis.money_money_bag + Emojis.plant_cactus} Buy Plant Food!!!',
      body: 'Florist at 123 Main St. has 2 in stock',
      bigPicture: 'asset://assets/notification_map.png',
      notificationLayout: NotificationLayout.BigPicture,
    ),
  );
}*/

Future<void> createReminderNotification(
    NotificationWeekAndTime notificationSchedule) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 0,
      channelKey: 'daiy_flow_channel',
      title: '${Emojis.money_money_bag} ถึงเวลาทำรายรับ-จ่ายเเล้วนะ!!!',
      body: 'จะมาทำดีๆ หรือจะมาทำด้วยน้ำตาา',
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'เปิดแอพ',
      ),
    ],
    schedule: NotificationCalendar(
      // weekday: notificationSchedule.dayOfTheWeek,
      hour: notificationSchedule.timeOfDay.hour,
      minute: notificationSchedule.timeOfDay.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
    ),
  );
}

Future<void> cancelScheduledNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}

Future<void> showAllNotifications() async {
  final listNoti = await AwesomeNotifications().listScheduledNotifications();
  print(listNoti);
}
