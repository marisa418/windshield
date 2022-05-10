class Budget {
  String id;
  double incWorkingBud;
  double incAssetBud;
  double incOtherBud;
  double expInConsistBud;
  double expConsistBud;
  double savInvBud;
  String name;
  bool chosen;
  DateTime start;
  DateTime end;
  double incWorkingFlow;
  double incAssetFlow;
  double incOtherFlow;
  double expInConsistFlow;
  double expConsistFlow;
  double savInvFlow;
  int count;

  Budget({
    required this.id,
    required this.incWorkingBud,
    required this.incAssetBud,
    required this.incOtherBud,
    required this.expInConsistBud,
    required this.expConsistBud,
    required this.savInvBud,
    required this.name,
    required this.chosen,
    required this.start,
    required this.end,
    required this.incWorkingFlow,
    required this.incAssetFlow,
    required this.incOtherFlow,
    required this.expInConsistFlow,
    required this.expConsistFlow,
    required this.savInvFlow,
    required this.count,
  });

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
        id: json['id'],
        incWorkingBud: json['working_income_budget'] ?? 0,
        incAssetBud: json['invest_income_budget'] ?? 0,
        incOtherBud: json['other_income_budget'] ?? 0,
        expInConsistBud: json['inconsist_expense_budget'] ?? 0,
        expConsistBud: json['consist_expense_budget'] ?? 0,
        savInvBud: json['saving_n_invest_budget'] ?? 0,
        name: json['name'],
        chosen: json['chosen'],
        start: DateTime.parse(json['start']),
        end: DateTime.parse(json['end']),
        incWorkingFlow: json['working_income_flow'] ?? 0,
        incAssetFlow: json['invest_income_flow'] ?? 0,
        incOtherFlow: json['other_income_flow'] ?? 0,
        expInConsistFlow: json['inconsist_expense_flow'] ?? 0,
        expConsistFlow: json['consist_expense_flow'] ?? 0,
        savInvFlow: json['saving_n_invest_flow'] ?? 0,
        count: json['count'],
      );
}
