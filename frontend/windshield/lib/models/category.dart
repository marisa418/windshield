class Category {
  String id;
  String name;
  int usedCount;
  String ftype;
  String icon;

  bool active = false;
  int total = 0;

  Category({
    required this.id,
    required this.name,
    required this.usedCount,
    required this.ftype,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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
