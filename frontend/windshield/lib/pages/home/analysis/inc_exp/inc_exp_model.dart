import 'package:intl/intl.dart';

class IncExp {
  double avgInc;
  double avgIncWorking;
  double avgIncAsset;
  double avgIncOther;
  double avgExp;
  double avgExpInconsist;
  double avgExpConsist;
  double avgSavInv;

  IncExp({
    required this.avgInc,
    required this.avgIncWorking,
    required this.avgIncAsset,
    required this.avgIncOther,
    required this.avgExp,
    required this.avgExpInconsist,
    required this.avgExpConsist,
    required this.avgSavInv,
  });

  factory IncExp.fromJson(Map<String, dynamic> json) => IncExp(
        avgInc: json['avg_income'] ?? 0,
        avgIncWorking: json['avg_working_income'] ?? 0,
        avgIncAsset: json['avg_invest_income'] ?? 0,
        avgIncOther: json['avg_other_income'] ?? 0,
        avgExp: json['avg_expense'] ?? 0,
        avgExpInconsist: json['avg_inconsist_expense'] ?? 0,
        avgExpConsist: json['avg_consist_expense'] ?? 0,
        avgSavInv: json['avg_saving'] ?? 0,
      );
}

class IncExpGraph {
  String id;
  double income;
  double expense;
  DateTime? date;
  int? month;
  int? year;

  IncExpGraph({
    required this.id,
    required this.income,
    required this.expense,
    this.date,
    this.month,
    this.year,
  });

  factory IncExpGraph.fromJson(Map<String, dynamic> json) => IncExpGraph(
        id: json['id'] ?? '',
        income: double.parse(json['incomes'] ?? '0'),
        expense: double.parse(json['expenses'] ?? '0'),
        date: json['date'] == null ? null : DateTime.parse(json['date']),
        month: json['month'],
        year: json['year'],
      );
}
