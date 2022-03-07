import 'package:intl/intl.dart';

import 'budget.dart';

class Statement {
  String id;
  String name;
  bool chosen;
  DateTime start;
  DateTime end;
  List<Budget> budgets;

  Statement({
    required this.id,
    required this.name,
    required this.chosen,
    required this.start,
    required this.end,
    required this.budgets,
  });

  factory Statement.fromJson(Map<String, dynamic> json) => Statement(
        id: json['id'],
        name: json['name'],
        chosen: json['chosen'],
        start: DateFormat('y-MM-dd').parse(json['start']),
        end: DateFormat('y-MM-dd').parse(json['end']),
        budgets:
            List<Budget>.from(json['budgets'].map((x) => Budget.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'start': start,
        'end': end,
      };
}
