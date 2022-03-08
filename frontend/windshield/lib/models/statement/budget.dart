class StmntBudget {
  String id;
  String catId;
  double balance;
  double total;
  double budPerPeriod;
  String freq;
  String fplan;

  StmntBudget({
    required this.id,
    required this.catId,
    required this.balance,
    required this.total,
    required this.budPerPeriod,
    required this.freq,
    required this.fplan,
  });

  factory StmntBudget.fromJson(Map<String, dynamic> json) => StmntBudget(
        id: json['id'],
        catId: json['cat_id'],
        balance: json['used_balance'].toDouble(),
        total: double.parse(json['total_budget']),
        budPerPeriod: double.parse(json['budget_per_period']),
        freq: json['frequency'],
        fplan: json['fplan'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'cat_id': catId,
        'used_balance': balance,
        'total_budget': total,
        'budget_per_period': budPerPeriod,
        'frequency': freq,
        'fplan': fplan,
      };
}
