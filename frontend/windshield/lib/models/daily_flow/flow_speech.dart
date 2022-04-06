import 'package:flutter/material.dart';

class SpeechFlow {
  String dfId;
  SpeechCat cat;
  String name;
  double value;
  int method;

  SpeechFlow({
    required this.dfId,
    required this.cat,
    required this.name,
    required this.value,
    required this.method,
  });

  Map<String, dynamic> toJson() => {
        'df_id': dfId,
        'category': cat.id,
        'name': name,
        'value': value,
        'method': method,
      };
}

class SpeechCat {
  String id;
  String icon;
  Color color;

  SpeechCat({
    required this.id,
    required this.icon,
    required this.color,
  });
}
