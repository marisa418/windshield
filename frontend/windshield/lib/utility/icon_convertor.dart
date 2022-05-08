import 'package:flutter/material.dart';

class HelperIcons {
  static Map<String, int> faIcons = <String, int>{
    'briefcase': 0xf0b1,
    'hand-holding-usd': 0xf4c0,
    'business-time': 0xf64a,
    'comment-dollar': 0xf651,
    'dollar-sign': 0xf155,
    'percentage': 0xf541,
    'chart-line': 0xf201,
    'building': 0xf1ad,
    'trophy': 0xf091,
    'utensils': 0xf2e7,
    'house-user': 0xe065,
    'music': 0xf001,
    'bolt': 0xf0e7,
    'heart': 0xf004,
    'route': 0xf4d7,
    'hand-holding-medical': 0xe05c,
    'user-friends': 0xf500,
    'baby': 0xf77c,
    'donate': 0xf4b9,
    'dice': 0xf522,
    'praying-hands': 0xf684,
    'home': 0xf015,
    'graduation-cap': 0xf19d,
    'car': 0xf1b9,
    'shopping-cart': 0xf07a,
    'comments-dollar': 0xf653,
    'file-contract': 0xf56c,
    'coins': 0xf51e,
    'piggy-bank': 0xf4d3,
  };

  static IconData getIconData(String iconName) {
    iconName = iconName.toLowerCase().trim();
    return IconData(
      faIcons[iconName] ?? 0xf0b1,
      fontFamily: 'FontAwesomeSolid',
      fontPackage: 'font_awesome_flutter',
    );
  }
}

List<String> icons = [
  'flag_sharp',
  'airplanemode_active',
  'access_alarms_outlined',
  'access_time_filled_sharp',
  'accessible_forward_rounded',
  'account_balance_sharp',
  'account_balance_outlined',
  'ad_units',
  'ad_units_rounded',
  'adb_outlined',
  'add_business ',
  'add_card_rounded',
  'add_location',
  'add_location_alt_sharp',
  'agriculture_rounded',
  'airline_seat_individual_suite',
  'airline_stops_rounded',
  'airport_shuttle_sharp',
  'airplay_sharp',
  'album_outlined',
  'align_vertical_bottom_outlined',
  'all_inclusive',
  'android_outlined',
  'apple_rounded ',
  'assignment_ind',
  'assignment',
  'assistant_rounded',
  'attach_email ',
  'attach_money_outlined',
  'audiotrack_sharp ',
  'auto_awesome',
  'auto_stories_rounded',
  'bakery_dining_rounded ',
  'balance_outlined',
  'bathtub_rounded',
  'bed_rounded',
  'bedtime_sharp',
  'blender_rounded',
  'boy_sharp'
];

class IconsFinance {
  static Map<String, int> fiIcons = <String, int>{
    'flag_sharp': 0xe989,
    'airplanemode_active': 0xe06e,
    'access_alarms_outlined': 0xee2b,
    'access_time_filled_sharp': 0xe73a,
    'accessible_forward_rounded': 0xe73e,
    'account_balance_sharp': 0xe740,
    'account_balance_outlined': 0xee32,
    'ad_units': 0xe045,
    'ad_units_rounded': 0xf524,
    'adb_outlined': 0xee38,
    'add_business': 0xe04c,
    'add_card_rounded': 0xf02d1,
    'add_location': 0xe054,
    'add_location_alt_sharp': 0xe752,
    'agriculture_rounded': 0xf541,
    'airline_seat_individual_suite': 0xe067,
    'airline_stops_rounded': 0xf02d5,
    'airport_shuttle_sharp': 0xe770,
    'airplay_sharp': 0xe76f,
    'album_outlined': 0xee67,
    'align_vertical_bottom_outlined': 0xee6b,
    'all_inclusive': 0xe07e,
    'android_outlined': 0xee76,
    'apple_rounded': 0xf02d8,
    'assignment_ind': 0xe0a6,
    'assignment': 0xe0a5,
    'assistant_rounded': 0xf58b,
    'attach_email': 0xe0b0,
    'attach_money_outlined': 0xeea2,
    'audiotrack_sharp': 0xe7b4,
    'auto_awesome': 0xe0b7,
    'auto_stories_rounded': 0xf59c,
    'bakery_dining_rounded': 0xf5a6,
    'balance_outlined': 0xf05c1,
    'bathtub_rounded': 0xf5ac,
    'bed_rounded': 0xf5b4,
    'bedtime_sharp': 0xe7d9,
    'blender_rounded': 0xf5bd,
    'boy_sharp': 0xf03d5,
  };

  static IconData getIconData(String iconName) {
    iconName = iconName.toLowerCase().trim();
    return IconData(
      fiIcons[iconName] ?? 0xe989,
      fontFamily: 'MaterialIcons',
    );
  }
}
