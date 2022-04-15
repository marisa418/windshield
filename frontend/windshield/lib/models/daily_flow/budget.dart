class DFlowBudget {
  String id;
  double total;
  double budPerPeriod;
  String freq;
  String fplan;
  String catId;

  DFlowBudget({
    required this.id,
    required this.catId,
    required this.total,
    required this.budPerPeriod,
    required this.freq,
    required this.fplan,
  });

  factory DFlowBudget.fromJson(Map<String, dynamic> json) => DFlowBudget(
        id: json['id'],
        total: double.parse(json['total_budget']),
        budPerPeriod: double.parse(json['budget_per_period']),
        freq: json['frequency'],
        fplan: json['fplan'],
        catId: json['cat_id'],
      );

  Map<String, dynamic> toJson() => {
        'category': catId,
        'fplan': fplan,
        "budget_per_period": budPerPeriod,
        "frequency": freq,
      };
}
