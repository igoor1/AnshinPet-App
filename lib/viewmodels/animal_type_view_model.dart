import 'package:anshinpet/model/animal_type_model.dart';
import 'package:anshinpet/services/repository/animal_type_repository.dart';
import 'package:flutter/material.dart';

class AnimalTypeViewModel with ChangeNotifier {
  final _repo = AnimalTypeRepository();

  List<AnimalTypeModel> _allTypes = [];
  
  List<AnimalTypeModel> _filteredTypes = [];
  List<AnimalTypeModel> get filteredTypes => _filteredTypes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchAnimalTypes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repo.fetchAllAnimalTypes();
      _allTypes = response.map((json) => AnimalTypeModel.fromJson(json)).toList();
      _filteredTypes = _allTypes;
    } catch (e) {
      _error = e.toString();
      _allTypes = [];
      _filteredTypes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterTypes(String query) {
    if (query.isEmpty) {
      _filteredTypes = _allTypes;
    } else {
      _filteredTypes = _allTypes
          .where((type) =>
              type.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}