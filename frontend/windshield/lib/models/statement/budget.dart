import 'package:windshield/models/statement/category.dart';

class StmntBudget {
  String id;
  double total;
  double budPerPeriod;
  String freq;
  String fplan;
  StmntCategory cat;

  String catId;

  StmntBudget({
    required this.id,
    required this.cat,
    required this.total,
    required this.budPerPeriod,
    required this.freq,
    required this.fplan,
    this.catId = '',
  });

  factory StmntBudget.fromJson(Map<String, dynamic> json) => StmntBudget(
        id: json['id'],
        total: double.parse(json['total_budget']),
        budPerPeriod: double.parse(json['budget_per_period']),
        freq: json['frequency'],
        fplan: json['fplan'],
        cat: StmntCategory.fromJson(json['cat_id']),
      );

  Map<String, dynamic> toJson() => {
        'cat_id': catId,
        'fplan': fplan,
        "budget_per_period": budPerPeriod,
        "frequency": freq,
      };

  Map<String, dynamic> toJsonUpdate() => {
        'id': id,
        "budget_per_period": budPerPeriod,
        "frequency": freq,
      };
}
