class CareLog {
  final int id;
  final int plantId;
  final String action;
  final DateTime date;
  final String? notes;

  CareLog({
    required this.id,
    required this.plantId,
    required this.action,
    required this.date,
    this.notes,
  });

  factory CareLog.fromJson(Map<String, dynamic> json) {
    return CareLog(
      id: json['id'],
      plantId: json['plant_id'],
      action: json['action'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }
}
