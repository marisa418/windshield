import '../daily_flow/flow.dart';

class FlowSheet {
  String id;
  List<DFlowFlow> flows;
  DateTime date;

  FlowSheet({
    required this.id,
    required this.flows,
    required this.date,
  });

  factory FlowSheet.fromJson(Map<String, dynamic> json) => FlowSheet(
        id: json['id'],
        flows: List<DFlowFlow>.from(
            json['flows'].map((x) => DFlowFlow.fromJson(x))),
        date: DateTime.parse(json['date']),
      );
}
