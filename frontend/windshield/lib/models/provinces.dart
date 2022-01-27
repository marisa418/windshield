import 'dart:convert';

List<Province> provinceFromJson(String str) =>
    List<Province>.from(json.decode(str).map((x) => Province.fromJson(x)));

class Province {
  String id;
  String name;

  Province({required this.id, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) => Province(
        id: json['id'],
        name: json['name_in_thai'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_in_thai': name,
      };
}
