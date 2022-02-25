class Budget {
  String id;
  String fplan;
  int balance;
  int totalBudget;
  int budgetPerPeriod;
  String date;

  Budget({
    required this.id,
    required this.fplan,
    required this.balance,
    required this.totalBudget,
    required this.budgetPerPeriod,
    required this.date,
  });

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
        id: json['id'],
        fplan: json['fplan'],
        balance: json['balance'],
        totalBudget: json['total_budget'],
        budgetPerPeriod: json['budget_per_period'],
        date: json['date'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fplan': fplan,
        'balance': balance,
        'total_budget': totalBudget,
        'budget_per_period': budgetPerPeriod,
        'date': date,
      };
}
