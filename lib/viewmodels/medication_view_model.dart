import 'package:anshinpet/model/medication_model.dart';
import 'package:flutter/material.dart';
import 'package:anshinpet/services/repository/medication_repository.dart';

class MedicationViewModel with ChangeNotifier {
  final MedicationRepository _repository = MedicationRepository();

  List<MedicationModel> _allMedications = [];
  List<MedicationModel> _filteredMedications = [];
  List<MedicationModel> get filteredMedications => _filteredMedications;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  String _lastSearchQuery = '';

  Future<void> fetchMedications() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.fetchMedications();
      _allMedications =
          response.map<MedicationModel>((json) => MedicationModel.fromJson(json)).toList();
      filterMedications(_lastSearchQuery);
    } catch (e) {
      _error = 'Falha ao carregar medicamentos: ${e.toString()}';
      _allMedications = [];
      _filteredMedications = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void filterMedications(String query) {
    _lastSearchQuery = query;

    if (query.isEmpty) {
      _filteredMedications = [..._allMedications];
    } else {
      final q = query.toLowerCase();
      _filteredMedications = _allMedications.where((med) {
        return med.name.toLowerCase().contains(q) ||
            med.manufacturer.toLowerCase().contains(q) ||
            med.batch.toLowerCase().contains(q);
      }).toList();
    }
    notifyListeners();
  }

  Future<bool> addMedication(MedicationModel med) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final newMedJson = await _repository.createMedication({
        'name': med.name,
        'manufacturer': med.manufacturer,
        'batch': med.batch,
      });

      final newMed = MedicationModel.fromJson(newMedJson);
      _allMedications.insert(0, newMed);
      filterMedications(_lastSearchQuery);
      return true;
    } catch (e) {
      _error = 'Falha ao cadastrar medicamento: ${e.toString()}';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMedication(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.deleteMedication(id);
      _allMedications.removeWhere((med) => med.id == id);
      filterMedications(_lastSearchQuery);
    } catch (e) {
      _error = 'Falha ao excluir medicamento: ${e.toString()}';
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
