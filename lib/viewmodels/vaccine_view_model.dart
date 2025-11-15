import 'package:anshinpet/model/vaccine_model.dart';
import 'package:anshinpet/services/repository/vaccine_repository.dart';
import 'package:flutter/material.dart';

class VaccineViewModel with ChangeNotifier{
  final VaccineRepository _vaccineRepository = VaccineRepository();

  List<VaccineModel> _allVaccines = [];

  List<VaccineModel> _filteredVaccines = [];
  List<VaccineModel> get filteredVaccines => _filteredVaccines;


  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  String _lastSearchQuery = '';

  Future<void> fetchVaccines() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _vaccineRepository.fetchVaccines();
      _allVaccines = response.map<VaccineModel>((json) => VaccineModel.fromJson(json)).toList();
      _filteredVaccines = _allVaccines;
    } finally{
      _loading = false;
      notifyListeners();
    }
  }

  void filterVaccines(String query) {
    _lastSearchQuery = query;
    if (query.isEmpty) {
      _filteredVaccines = _allVaccines;
    } else{
      final queryLower = query.toLowerCase();
      _filteredVaccines = _allVaccines.where((vaccine) {
        final nameLower = vaccine.name.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    }
    notifyListeners();
  }

    Future<void> updateVaccine(VaccineModel data) async {
    _loading = true;
    notifyListeners();

    try{
      await _vaccineRepository.updateVaccine(data);
      final index = _allVaccines.indexWhere((d) => d.id == data.id);

      if(index != -1){
        _allVaccines[index] = data;
        filterVaccines(_lastSearchQuery);
      }
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

   Future<void> createVaccine(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();

    try {
      final json = await _vaccineRepository.createVaccine(data);
      print(json);
      final newVaccine = VaccineModel.fromJson(json);
      _allVaccines.add(newVaccine);
      filterVaccines(_lastSearchQuery);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> deleteVaccine(int id) async {
    _loading = true;
    notifyListeners();

    try{
      await _vaccineRepository.deleteVaccine(id);

      _allVaccines.removeWhere((vaccine) => vaccine.id == id);
      filterVaccines(_lastSearchQuery);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
