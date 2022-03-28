class DFlowFlow {
  String id;
  Method method;
  String name;
  double value;
  String detail;
  String dfId;
  Cat cat;

  int methodId;

  DFlowFlow({
    required this.id,
    required this.method,
    required this.name,
    required this.value,
    required this.detail,
    required this.dfId,
    required this.cat,
    this.methodId = 0,
  });

  factory DFlowFlow.fromJson(Map<String, dynamic> json) => DFlowFlow(
        id: json['id'],
        method: Method.fromJson(json['method']),
        name: json['name'],
        value: double.parse(json['value']),
        detail: json['detail'] ?? '',
        dfId: json['df_id'],
        cat: Cat.fromJson(json['category']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'method': method.toJson(),
        'name': name,
        'value': value,
        'detail': detail,
        'df_id': dfId,
        'category': cat,
      };
}

class Method {
  int id;
  String name;
  String icon;

  Method({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory Method.fromJson(Map<String, dynamic> json) => Method(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
      };
}

class Cat {
  String id;
  String name;
  int usedCount;
  String icon;
  bool isDeleted;
  String ftype;

  Cat({
    required this.id,
    required this.name,
    required this.usedCount,
    required this.icon,
    required this.isDeleted,
    required this.ftype,
  });

  factory Cat.fromJson(Map<String, dynamic> json) => Cat(
        id: json['id'],
        name: json['name'],
        usedCount: json['used_count'],
        icon: json['icon'],
        isDeleted: json['isDeleted'],
        ftype: json['ftype'],
      );
}
