import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../models/care_log.dart';
import '../services/api_service.dart';

class PlantProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  List<Plant> _plants = [];
  Map<int, List<CareLog>> _careLogsMap = {}; // Ключ — plantId, значение — список логов
  bool _isLoading = false;

  List<Plant> get plants => _plants;
  bool get isLoading => _isLoading;

  List<CareLog> getCareLogsForPlant(int plantId) {
    return _careLogsMap[plantId] ?? [];
  }

  Future<void> fetchPlants() async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _api.get('/plants');
      _plants = (res.data as List)
          .map((e) => Plant.fromJson(e as Map<String, dynamic>))
          .toList();

      // После загрузки растений сразу загружаем логи для всех
      for (var plant in _plants) {
        await fetchCareLogs(plant.id);
      }
    } catch (e) {
      print('Ошибка загрузки растений: $e');
      _plants = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCareLogs(int plantId) async {
    try {
      final res = await _api.get('/care-logs/$plantId');
      final logs = (res.data as List)
          .map((e) => CareLog.fromJson(e as Map<String, dynamic>))
          .toList();

      _careLogsMap[plantId] = logs;
      notifyListeners();
    } catch (e) {
      print('Ошибка загрузки журнала для растения $plantId: $e');
      _careLogsMap[plantId] = [];
    }
  }

  Future<bool> addPlant({
    required String name,
    required String species,
    required int categoryId,
    String? location,
  }) async {
    try {
      await _api.post('/plants', {
        "name": name,
        "species": species,
        "category_id": categoryId,
        "location": location ?? "",
      });
      await fetchPlants();
      return true;
    } catch (e) {
      print('Ошибка добавления растения: $e');
      return false;
    }
  }

  Future<bool> addCareLog(int plantId, String action, String? notes) async {
    try {
      await _api.post('/care-logs/$plantId', {
        "action": action,
        "notes": notes ?? "",
      });
      await fetchCareLogs(plantId);   // обновляем только для этого растения
      return true;
    } catch (e) {
      print('Ошибка добавления записи ухода: $e');
      return false;
    }
  }
}
