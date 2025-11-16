import 'package:flutter/material.dart';
import 'package:anshinpet/model/vaccine_model.dart';
import 'package:anshinpet/services/repository/vaccine_repository.dart';

class VaccineViewModel extends ChangeNotifier {
  final VaccineRepository _repo = VaccineRepository();

  List<Vaccine> vaccines = [];
  bool isLoading = false;

  Future<void> loadVaccines() async {
    isLoading = true;
    notifyListeners();

    final response = await _repo.fetchVaccines();

    vaccines = response
        .map<Vaccine>((json) => Vaccine.fromJson(json))
        .toList();

    isLoading = false;
    notifyListeners();
  }

  Future<bool> addVaccine(Vaccine vaccine) async {
    try {
      await _repo.createVaccine(vaccine.toJson());
      await loadVaccines();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteVaccine(int id) async {
    try {
      await _repo.deleteVaccine(id);
      await loadVaccines();
      return true;
    } catch (e) {
      return false;
    }
  }
}
