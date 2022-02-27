class Budget {
  String catId;
  String fplan;
  int balance;
  int totalBudget;
  int budgetPerPeriod;
  String frequency;
  String dueDate;

  Budget({
    required this.catId,
    required this.fplan,
    required this.balance,
    required this.totalBudget,
    required this.budgetPerPeriod,
    required this.frequency,
    required this.dueDate,
  });

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
        catId: json['cat_id'],
        fplan: json['fplan'],
        balance: json['balance'],
        totalBudget: json['total_budget'],
        budgetPerPeriod: json['budget_per_period'],
        frequency: json['frequency'],
        dueDate: json['due_date'],
      );

  Map<String, dynamic> toJson() => {
        'cat_id': catId,
        'fplan': fplan,
        'balance': balance,
        'total_budget': totalBudget,
        'budget_per_period': budgetPerPeriod,
        'frequency': frequency,
        'due_date': dueDate,
      };
}
