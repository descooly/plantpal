import 'package:flutter/material.dart';
import '../models/care_log.dart';
import '../services/api_service.dart';

class CareProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  List<CareLog> _logs = [];

  List<CareLog> get logs => _logs;

  Future<void> fetchLogs(int plantId) async {
    final res = await _api.get('/care-logs/$plantId'); // можно доработать
    _logs = (res.data as List).map((e) => CareLog.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> addLog(int plantId, String action, String? notes) async {
    await _api.post('/care-logs/$plantId', {'action': action, 'notes': notes});
    await fetchLogs(plantId);
  }
}
