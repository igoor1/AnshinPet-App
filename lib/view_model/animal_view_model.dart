import 'package:anshinpet/model/animal_model.dart';
import 'package:anshinpet/repository/animal_respository.dart';
import 'package:flutter/widgets.dart';

class AnimalViewModel with ChangeNotifier {
  final AnimalRespository _animalRespository = AnimalRespository();

  List<AnimalModel> _animals = [];
  List<AnimalModel> get animals => _animals;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> fetchAnimals() async {
    _loading = true;
    notifyListeners();

    try {
      final response = await _animalRespository.fetchAnimals();
      _animals = response.map<AnimalModel>((json) {
        try {
          final model = AnimalModel.fromJson(json);
          return model;
        } catch (e) {
          throw e;
        }
      }).toList();
    } catch (e) {
      print(e);
      _animals = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> createAnimal(a, c) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await _animalRespository.fetchAnimals();
      _animals = response.map<AnimalModel>((json) {
        try {
          final model = AnimalModel.fromJson(json);
          return true;
        } catch (e) {
          throw e;
        }
      }).toList();
    } catch (e) {
      print(e);
      _animals = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
