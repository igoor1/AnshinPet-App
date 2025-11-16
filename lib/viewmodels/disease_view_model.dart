import 'package:flutter/material.dart';
import 'package:anshinpet/model/disease_model.dart';
import 'package:anshinpet/services/repository/disease_repository.dart';

class DiseaseViewModel with ChangeNotifier {
  final DiseaseRepository _repo = DiseaseRepository();

  List<DiseaseModel> _all = [];
  List<DiseaseModel> _filtered = [];
  List<DiseaseModel> get filteredDiseases => _filtered;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  String _lastQuery = "";

  Future<void> fetchDiseases() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repo.fetchDiseases();
      _all = response.map((e) => DiseaseModel.fromJson(e)).toList();
      filterDiseases(_lastQuery);
    } catch (e) {
      _error = "Falha ao carregar doenças: $e";
    }

    _loading = false;
    notifyListeners();
  }

  void filterDiseases(String query) {
    _lastQuery = query;

    if (query.isEmpty) {
      _filtered = _all;
    } else {
      final q = query.toLowerCase();
      _filtered = _all.where((d) => d.name.toLowerCase().contains(q)).toList();
    }

    notifyListeners();
  }

  Future<void> createDisease(Map<String, dynamic> data) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final json = await _repo.createDisease(data);
      final newDisease = DiseaseModel.fromJson(json);

      _all.insert(0, newDisease);
      filterDiseases(_lastQuery);
    } catch (e) {
      _error = "Falha ao cadastrar doença: $e";
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> updateDisease(DiseaseModel disease, Map<String, String> updatedDisease) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final json = await _repo.updateDisease(disease.id, disease.toJson());
      final updated = DiseaseModel.fromJson(json);

      final index = _all.indexWhere((d) => d.id == updated.id);
      if (index != -1) _all[index] = updated;

      filterDiseases(_lastQuery);
    } catch (e) {
      _error = "Falha ao atualizar: $e";
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> deleteDisease(int id) async {
    _loading = true;
    notifyListeners();

    try {
      await _repo.deleteDisease(id);
      _all.removeWhere((d) => d.id == id);
      filterDiseases(_lastQuery);
    } catch (e) {
      _error = "Falha ao excluir: $e";
    }

    _loading = false;
    notifyListeners();
  }
}
