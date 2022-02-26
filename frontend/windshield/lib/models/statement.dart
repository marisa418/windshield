class Statement {
  String id;
  String name;
  bool chosen;
  String start;
  String end;
  int month;

  Statement(
      {required this.id,
      required this.name,
      required this.chosen,
      required this.start,
      required this.end,
      required this.month});

  factory Statement.fromJson(Map<String, dynamic> json) => Statement(
        id: json['id'],
        name: json['name'],
        chosen: json['chosen'],
        start: json['start'],
        end: json['end'],
        month: json['month'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'chosen': chosen,
        'start': start,
        'end': end,
        'month': month,
      };
}
