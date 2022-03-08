class StmntCategory {
  String id;
  String name;
  int usedCount;
  String ftype;
  String icon;

  bool active = false;
  double total = 0;

  StmntCategory({
    required this.id,
    required this.name,
    required this.usedCount,
    required this.ftype,
    required this.icon,
  });

  factory StmntCategory.fromJson(Map<String, dynamic> json) => StmntCategory(
        id: json['id'],
        name: json['name'],
        usedCount: json['used_count'],
        ftype: json['ftype'],
        icon: json['icon'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'used_count': usedCount,
        'ftype': ftype,
        'icon': icon,
      };
}
