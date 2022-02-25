class Statement {
  String id;
  String name;
  bool chosen;
  String start;
  String end;
  String ownerId;
  int month;

  Statement(
      {required this.id,
      required this.name,
      required this.chosen,
      required this.start,
      required this.end,
      required this.ownerId,
      required this.month});

  factory Statement.fromJson(Map<String, dynamic> json) => Statement(
        id: json['id'],
        name: json['name'],
        chosen: json['chosen'],
        start: json['start'],
        end: json['end'],
        ownerId: json['owner_id'],
        month: json['month'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'chosen': chosen,
        'start': start,
        'end': end,
        'owner_id': ownerId,
        'month': month,
      };
}
