class BSheetLog {
  int id;
  DateTime timestamp;
  double assetValue;
  double debtValue;
  String bsheetId;

  BSheetLog({
    required this.id,
    required this.timestamp,
    required this.assetValue,
    required this.debtValue,
    required this.bsheetId,
  });

  factory BSheetLog.fromJson(Map<String, dynamic> json) => BSheetLog(
        id: json['id'],
        timestamp: DateTime.parse(json['timestamp']),
        assetValue: double.parse(json['asset_value']),
        debtValue: double.parse(json['debt_balance']),
        bsheetId: (json['bsheet_id']),
      );
}
