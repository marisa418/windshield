class DFlowFlow {
  String id;
  Method method;
  String name;
  double value;
  String detail;
  String dfId;
  String catId;

  DFlowFlow({
    required this.id,
    required this.method,
    required this.name,
    required this.value,
    required this.detail,
    required this.dfId,
    required this.catId,
  });

  factory DFlowFlow.fromJson(Map<String, dynamic> json) => DFlowFlow(
        id: json['id'],
        method: Method.fromJson(json['method']),
        name: json['name'],
        value: json['value'],
        detail: json['detail'],
        dfId: json['df_id'],
        catId: json['category'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'method': method.toJson(),
        'name': name,
        'value': value,
        'detail': detail,
        'df_id': dfId,
        'category': catId,
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
