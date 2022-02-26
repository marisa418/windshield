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
