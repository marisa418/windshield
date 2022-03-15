import 'asset.dart';
import 'debt.dart';

class BSheetBalance {
  String id;
  String ownerId;
  List<BSheetAsset> assets;
  List<BSheetDebt> debts;

  BSheetBalance({
    required this.id,
    required this.ownerId,
    required this.assets,
    required this.debts,
  });

  factory BSheetBalance.fromJson(Map<String, dynamic> json) => BSheetBalance(
        id: json['id'],
        ownerId: json['owner_id'],
        assets: List<BSheetAsset>.from(
            json['assets'].map((x) => BSheetAsset.fromJson(x))),
        debts: List<BSheetDebt>.from(
            json['debts'].map((x) => BSheetDebt.fromJson(x))),
      );
}
