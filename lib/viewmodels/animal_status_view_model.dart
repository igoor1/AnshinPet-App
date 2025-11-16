import 'package:anshinpet/model/animal_status_model.dart';
import 'package:anshinpet/services/repository/animal_status_repository.dart';
import 'package:flutter/material.dart';

class AnimalStatusViewModel with ChangeNotifier {
  final _repo = AnimalStatusRepository();

  List<AnimalStatusModel> _allStatus = [];
  
  List<AnimalStatusModel> _filteredStatus = [];
  List<AnimalStatusModel> get filteredStatus => _filteredStatus;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchAnimalStatus() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repo.fetchAllAnimalStatus();
      _allStatus = response.map((json) => AnimalStatusModel.fromJson(json)).toList();
      _filteredStatus = _allStatus;
    } catch (e) {
      _error = e.toString();
      _allStatus = [];
      _filteredStatus = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterStatus(String query) {
    if (query.isEmpty) {
      _filteredStatus = _allStatus;
    } else {
      _filteredStatus = _allStatus
          .where((status) =>
              status.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}