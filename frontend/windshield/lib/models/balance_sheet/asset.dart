import 'category.dart';

class BSheetAsset {
  String id;
  BSheetCategory cat;
  String source;
  double recentVal;
  String benefitType;
  double benefitVal;
  String bsId;

  BSheetAsset({
    required this.id,
    required this.cat,
    required this.source,
    required this.recentVal,
    required this.benefitType,
    required this.benefitVal,
    required this.bsId,
  });

  factory BSheetAsset.fromJson(Map<String, dynamic> json) => BSheetAsset(
        id: json['id'],
        cat: BSheetCategory.fromJson(json['cat_id']),
        source: json['source'],
        recentVal: double.parse(json['recent_value']),
        benefitType: json['benefit_type'] ?? '',
        benefitVal: double.parse(json['benefit_value'] ?? '0'),
        bsId: json['bsheet_id'],
      );
}
