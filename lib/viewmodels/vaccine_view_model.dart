import 'package:flutter/material.dart';
import 'package:anshinpet/services/repository/vaccine_repository.dart';
import '../model/vaccine_model.dart';
import 'package:anshinpet/data/app_exceptions.dart';

class VaccineViewModel extends ChangeNotifier {
  final VaccineRepository _repository = VaccineRepository();

  List<VaccineModel> vaccines = [];
  List<VaccineModel> filteredVaccines = [];
  bool loading = false;
  String? error;

  Future<void> fetchVaccines() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _repository.fetchVaccines();
      if (response is List) {
        vaccines = response.map((e) => VaccineModel.fromJson(e)).toList();
        filteredVaccines = List.from(vaccines);
      } else {
        error = "Resposta inválida do servidor";
      }
    } catch (e) {
      if (e is UnauthorizedException) {
        error = "Não autorizado";
      } else {
        error = e.toString();
      }
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void filterVaccines(String query) {
    if (query.isEmpty) {
      filteredVaccines = List.from(vaccines);
    } else {
      filteredVaccines = vaccines
          .where((v) =>
              v.name.toLowerCase().contains(query.toLowerCase()) ||
              v.manufacturer.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> deleteVaccine(int id) async {
    try {
      await _repository.deleteVaccine(id);
      vaccines.removeWhere((v) => v.id == id);
      filteredVaccines.removeWhere((v) => v.id == id);
      notifyListeners();
    } catch (e) {
      error = "Erro ao excluir vacina: $e";
      notifyListeners();
    }
  }

  Future<bool> createVaccine(Map<String, dynamic> data) async {
    try {
      final response = await _repository.createVaccine(data);
      final newVaccine = VaccineModel.fromJson(response);
      vaccines.add(newVaccine);
      filteredVaccines.add(newVaccine);
      notifyListeners();
      return true;
    } catch (e) {
      error = "Erro ao cadastrar vacina: $e";
      notifyListeners();
      return false;
    }
  }
}
