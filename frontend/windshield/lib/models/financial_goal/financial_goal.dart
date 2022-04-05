import 'package:windshield/models/statement/category.dart';

class FGoal {
  String id;
  StmntCategory cat;
  String name;
  String icon;
  double goal;
  double totalProg;
  DateTime start;
  DateTime? goalDate;
  double progPerPeriod;
  String periodTerm;
  int reward;

  FGoal({
    required this.id,
    required this.cat,
    required this.name,
    required this.icon,
    required this.goal,
    required this.totalProg,
    required this.start,
    this.goalDate,
    required this.progPerPeriod,
    required this.periodTerm,
    required this.reward,
  });

  factory FGoal.fromJson(Map<String, dynamic> json) => FGoal(
        id: json['id'],
        cat: StmntCategory.fromJson(json['category_id']),
        name: json['name'],
        icon: json['icon'],
        goal: double.parse(json['goal']),
        totalProg: double.parse(json['total_progress']),
        start: DateTime.parse(json['start']),
        goalDate: DateTime.tryParse(json['goal_date'] ?? ''),
        progPerPeriod: double.parse(json['progress_per_period']),
        periodTerm: json['period_term'],
        reward: json['reward'],
      );
}
