import 'package:anshinpet/model/disease_model.dart';
import 'package:anshinpet/repository/disease_repository.dart';
import 'package:flutter/cupertino.dart';

class DiseaseViewModel with ChangeNotifier{
  final DiseaseRepository _diseaseRepository = DiseaseRepository();

  List<DiseaseModel> _allDiseases = [];

  List<DiseaseModel> _filteredDiseases = [];
  List<DiseaseModel> get filteredDiseases => _filteredDiseases;


  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  String _lastSearchQuery = '';

  Future<void> fetchDiseases() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _diseaseRepository.fetchDiseases();
      _allDiseases = response.map<DiseaseModel>((json) => DiseaseModel.fromJson(json)).toList();
      _filteredDiseases = _allDiseases;
    } finally{
      _loading = false;
      notifyListeners();
    }
  }

  void filterDiseases(String query) {
    _lastSearchQuery = query;
    if (query.isEmpty) {
      _filteredDiseases = _allDiseases;
    } else{
      final queryLower = query.toLowerCase();
      _filteredDiseases = _allDiseases.where((disease) {
        final nameLower = disease.name.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> updateDisease(DiseaseModel disease) async {
    _loading = true;
    notifyListeners();

    try{
      await _diseaseRepository.updateDisease(disease);
      final index = _allDiseases.indexWhere((d) => d.id == disease.id);

      if(index != -1){
        _allDiseases[index] = disease;
        filterDiseases(_lastSearchQuery);
      }
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}


