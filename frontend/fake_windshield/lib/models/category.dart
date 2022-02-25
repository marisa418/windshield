class Category {
  String id;
  String name;
  int usedCount;
  String ftype;
  String userId;

  Category({
    required this.id,
    required this.name,
    required this.usedCount,
    required this.ftype,
    required this.userId,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
        usedCount: json['used_count'],
        ftype: json['ftype'],
        userId: json['user_id'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'used_count': usedCount,
        'ftype': ftype,
        'user_id': userId,
      };
}
