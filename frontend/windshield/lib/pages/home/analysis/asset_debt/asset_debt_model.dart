import 'package:intl/intl.dart';

class AssetDebt {
  double maxAsset;
  double maxDebt;
  double maxBalance;
  double minAsset;
  double minDebt;
  double minBalance;
  double avgAsset;
  double avgDebt;
  double avgBalance;

  AssetDebt({
    required this.maxAsset,
    required this.maxDebt,
    required this.maxBalance,
    required this.minAsset,
    required this.minDebt,
    required this.minBalance,
    required this.avgAsset,
    required this.avgDebt,
    required this.avgBalance,
  });

  factory AssetDebt.fromJson(Map<String, dynamic> json) => AssetDebt(
        maxAsset: json['max_asset'] ?? 0,
        maxDebt: json['max_debt'] ?? 0,
        maxBalance: json['max_balance'] ?? 0,
        minAsset: json['min_asset'] ?? 0,
        minDebt: json['min_debt'] ?? 0,
        minBalance: json['min_balance'] ?? 0,
        avgAsset: json['avg_changed_asset'] ?? 0,
        avgDebt: json['avg_changed_debt'] ?? 0,
        avgBalance: json['avg_changed_balance'] ?? 0,
      );
}

class AssetDebtGraph {
  int id;
  DateTime timestamp;
  double asset;
  double debt;
  String bsheetId;

  AssetDebtGraph({
    required this.id,
    required this.timestamp,
    required this.asset,
    required this.debt,
    required this.bsheetId,
  });

  factory AssetDebtGraph.fromJson(Map<String, dynamic> json) => AssetDebtGraph(
        id: json['id'],
        timestamp: DateFormat('y-MM-ddTHH:mm:ss').parse(json['timestamp']),
        asset: double.tryParse(json['asset_value']) ?? 0,
        debt: double.tryParse(json['debt_balance']) ?? 0,
        bsheetId: json['bsheet_id'],
      );
}
