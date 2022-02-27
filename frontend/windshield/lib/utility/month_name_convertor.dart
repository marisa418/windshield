import 'package:flutter/material.dart';

class HelperMonth {
  static Map<String, int> MMM = <String, int>{
    'มกรา': 1,
    'กุมภา': 2,
    'มีนา': 3,
    'เมษา': 4,
    'พฤษภา': 5,
    'มิถุนา': 6,
    'กรกฎา': 7,
    'สิงหา': 8,
    'กันยา': 9,
    'ตุลา': 10,
    'พฤศจิกา': 11,
    'ธันวา': 12,
  };

  static Map<String, int> MMMM = <String, int>{
    'มกราคม': 1,
    'กุมภาพันธ์': 2,
    'มีนาคม': 3,
    'เมษายน': 4,
    'พฤษภาคม': 5,
    'มิถุนายน': 6,
    'กรกฎาคม': 7,
    'สิงหาคม': 8,
    'กันยายน': 9,
    'ตุลาคม': 10,
    'พฤศจิกายน': 11,
    'ธันวาคม': 12,
  };

  static int MMMtoint(String name) {
    return MMM[name] ?? 0;
  }

  static int MMMMtoint(String name) {
    return MMMM[name] ?? 0;
  }

  static String inttoMMM(int num) {
    return MMM.keys.firstWhere((k) => MMM[k] == num, orElse: () => '');
  }

  static String inttoMMMM(int num) {
    return MMMM.keys.firstWhere((k) => MMMM[k] == num, orElse: () => '');
  }
}
