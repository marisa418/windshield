import 'package:windshield/models/statement/category.dart';

class BSheetDebt {
  String id;
  StmntCategory cat;
  double balance;
  String creditor;
  double interest;
  DateTime debtTerm;
  double minimum;
  int suspend;
  int impRanking;
  String bsId;

  BSheetDebt({
    required this.id,
    required this.cat,
    required this.balance,
    required this.creditor,
    required this.interest,
    required this.debtTerm,
    required this.minimum,
    required this.suspend,
    required this.impRanking,
    required this.bsId,
  });

  factory BSheetDebt.fromJson(Map<String, dynamic> json) => BSheetDebt(
        id: json['id'],
        cat: StmntCategory.fromJson(json['cat_id']),
        balance: double.parse(json['balance']),
        creditor: json['creditor'],
        interest: double.parse(json['interest'] ?? '0'),
        debtTerm: json['debt_term'] ?? DateTime.now(),
        minimum: double.parse(json['minimum'] ?? '0'),
        suspend: json['suspend'] ?? 0,
        impRanking: json['imp_ranking'],
        bsId: json['bsheet_id'],
      );
}
