import 'budget.dart';

class StmntStatement {
  String id;
  String name;
  bool chosen;
  DateTime start;
  DateTime end;
  List<StmntBudget> budgets;

  StmntStatement({
    required this.id,
    required this.name,
    required this.chosen,
    required this.start,
    required this.end,
    required this.budgets,
  });

  factory StmntStatement.fromJson(Map<String, dynamic> json) => StmntStatement(
        id: json['id'],
        name: json['name'],
        chosen: json['chosen'],
        start: DateTime.parse(json['start']),
        end: DateTime.parse(json['end']),
        budgets: List<StmntBudget>.from(
            json['budgets'].map((x) => StmntBudget.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'start': start,
        'end': end,
      };
}
