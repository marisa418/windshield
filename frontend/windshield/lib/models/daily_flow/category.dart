import 'dart:convert';

import '../statement/budget.dart';
import 'flow.dart';

class DFlowCategory {
  String id;
  String name;
  int usedCount;
  String ftype;
  String icon;
  List<StmntBudget> budgets;
  List<DFlowFlow> flows;

  DFlowCategory({
    required this.id,
    required this.name,
    required this.usedCount,
    required this.ftype,
    required this.icon,
    required this.budgets,
    required this.flows,
  });

  factory DFlowCategory.fromJson(Map<String, dynamic> json) => DFlowCategory(
        id: json['id'],
        name: json['name'],
        usedCount: json['used_count'],
        ftype: json['ftype'],
        icon: json['icon'],
        // final data = (jsonDecode(res.toString()) as List)
        //   .map((i) => DFlowCategory.fromJson(i))
        //   .toList();
        budgets: json['budgets']
            .map((i) => StmntBudget.fromJson(jsonDecode(i)))
            .toList(),
        flows: json['flows']
            .map((i) => DFlowFlow.fromJson(jsonDecode(i)))
            .toList(),
        // budgets: List<StmntBudget>.from(
        //   json['budgets']
        //       .map((x) => StmntBudget.fromJson(jsonDecode(x.toString()))),
        // ),
        // flows: List<DFlowFlow>.from(
        //   json['flows']
        //       .map((x) => DFlowFlow.fromJson(jsonDecode(x.toString()))),
        // ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'used_count': usedCount,
        'ftype': ftype,
        'icon': icon,
      };
}
