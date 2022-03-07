class Budget {
  String id;
  String catId;
  double balance;
  double total;
  double budPerPeriod;
  String freq;
  String fplan;

  Budget({
    required this.id,
    required this.catId,
    required this.balance,
    required this.total,
    required this.budPerPeriod,
    required this.freq,
    required this.fplan,
  });

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
        id: json['id'],
        catId: json['cat_id'],
        balance: json['balance'],
        total: json['total_budget'],
        budPerPeriod: json['budget_per_period'],
        freq: json['frequency'],
        fplan: json['fplan'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'cat_id': catId,
        'balance': balance,
        'total_budget': total,
        'budget_per_period': budPerPeriod,
        'frequency': freq,
        'fplan': fplan,
      };
}
